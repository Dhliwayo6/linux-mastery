package com.linuxmastery.service;

import com.linuxmastery.entity.PasswordResetToken;
import com.linuxmastery.entity.Role;
import com.linuxmastery.entity.User;
import com.linuxmastery.repository.PasswordResetTokenRepository;
import com.linuxmastery.repository.UserRepository;
import com.linuxmastery.security.AuthTokens;
import com.linuxmastery.security.JwtTokenProvider;
import io.jsonwebtoken.Claims;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import com.linuxmastery.exception.ResourceNotFoundException;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordResetTokenRepository resetTokenRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtTokenProvider tokenProvider;

    @Mock
    private StringRedisTemplate redisTemplate;

    @Mock
    private ValueOperations<String, String> valueOperations;

    @Mock
    private EmailService emailService;

    private AuthService authService;

    @BeforeEach
    void setUp() {
        authService = new AuthService(
                userRepository,
                resetTokenRepository,
                passwordEncoder,
                tokenProvider,
                redisTemplate,
                emailService
        );
    }

    @Test
    void registerUser_Success() {
        String email = "test@example.com";
        String rawPassword = "Password123";
        String encodedPassword = "encodedPassword123";
        String displayName = "Test User";

        when(userRepository.existsByEmail(email)).thenReturn(false);
        when(passwordEncoder.encode(rawPassword)).thenReturn(encodedPassword);
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);

        User user = authService.registerUser(email, rawPassword, displayName);

        assertNotNull(user);
        assertEquals(email, user.getEmail());
        assertEquals(encodedPassword, user.getPasswordHash());
        assertEquals(displayName, user.getDisplayName());
        assertEquals(Role.STUDENT, user.getRole());
        assertFalse(user.isActive());
        verify(userRepository).save(any(User.class));
        verify(valueOperations).set(eq("otp:register:" + email), any(String.class), eq(15L), eq(TimeUnit.MINUTES));
        verify(emailService).sendRegistrationOtpEmail(eq(email), any(String.class));
    }

    @Test
    void registerUser_DuplicateEmail_ThrowsException() {
        String email = "test@example.com";
        when(userRepository.existsByEmail(email)).thenReturn(true);

        assertThrows(IllegalArgumentException.class, () ->
                authService.registerUser(email, "Password123", "Test User"));
    }

    @Test
    void loginUser_Success() {
        String email = "test@example.com";
        String rawPassword = "Password123";
        String userId = "user-uuid";

        User user = User.builder()
                .id(userId)
                .email(email)
                .passwordHash("hashedPass")
                .role(Role.STUDENT)
                .build();

        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches(rawPassword, "hashedPass")).thenReturn(true);
        when(tokenProvider.generateAccessToken(userId, "STUDENT")).thenReturn("access-token");
        when(tokenProvider.generateRefreshToken(userId)).thenReturn("refresh-token");
        when(tokenProvider.getRefreshExpirationMs()).thenReturn(604800000L);
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);

        AuthTokens tokens = authService.loginUser(email, rawPassword);

        assertNotNull(tokens);
        assertEquals("access-token", tokens.accessToken());
        assertEquals("refresh-token", tokens.refreshToken());
        verify(valueOperations).set(eq("refresh:" + userId), eq("refresh-token"), eq(604800000L), eq(TimeUnit.MILLISECONDS));
    }

    @Test
    void loginUser_InvalidPassword_ThrowsException() {
        String email = "test@example.com";
        User user = User.builder()
                .email(email)
                .passwordHash("hashedPass")
                .build();

        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("WrongPass", "hashedPass")).thenReturn(false);

        assertThrows(BadCredentialsException.class, () -> authService.loginUser(email, "WrongPass"));
    }

    @Test
    void refreshAccessToken_Success() {
        String refreshToken = "valid-refresh-token";
        String userId = "user-uuid";
        Claims claims = mock(Claims.class);
        when(claims.getSubject()).thenReturn(userId);

        User user = User.builder()
                .id(userId)
                .role(Role.STUDENT)
                .build();

        when(tokenProvider.validateRefreshToken(refreshToken)).thenReturn(claims);
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        when(valueOperations.get("refresh:" + userId)).thenReturn(refreshToken);
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(tokenProvider.generateAccessToken(userId, "STUDENT")).thenReturn("new-access-token");
        when(tokenProvider.generateRefreshToken(userId)).thenReturn("new-refresh-token");

        when(tokenProvider.getRefreshExpirationMs()).thenReturn(604800000L);

        AuthTokens tokens = authService.refreshAccessToken(refreshToken);

        assertNotNull(tokens);
        assertEquals("new-access-token", tokens.accessToken());
        assertEquals("new-refresh-token", tokens.refreshToken());
        verify(valueOperations).set(eq("refresh:" + userId), eq("new-refresh-token"), eq(604800000L), eq(TimeUnit.MILLISECONDS));
    }

    @Test
    void logoutUser_Success() {
        String refreshToken = "valid-refresh-token";
        String userId = "user-uuid";
        Claims claims = mock(Claims.class);
        when(claims.getSubject()).thenReturn(userId);

        when(tokenProvider.validateRefreshToken(refreshToken)).thenReturn(claims);

        authService.logoutUser(refreshToken);

        verify(redisTemplate).delete("refresh:" + userId);
    }

    @Test
    void requestPasswordResetOtp_SendsEmail() {
        String email = "test@example.com";
        User user = User.builder()
                .email(email)
                .build();

        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);

        authService.requestPasswordResetOtp(email);

        verify(valueOperations).set(eq("otp:reset:" + email), any(String.class), eq(15L), eq(TimeUnit.MINUTES));
        verify(emailService).sendPasswordResetOtpEmail(eq(email), any(String.class));
    }

    @Test
    void verifyRegistrationOtp_Success() {
        String email = "test@example.com";
        String otp = "123456";
        User user = User.builder()
                .id("user-uuid")
                .email(email)
                .role(Role.STUDENT)
                .active(false)
                .build();

        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        when(valueOperations.get("otp:register:" + email)).thenReturn(otp);
        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));
        when(tokenProvider.generateAccessToken("user-uuid", "STUDENT")).thenReturn("access-token");
        when(tokenProvider.generateRefreshToken("user-uuid")).thenReturn("refresh-token");
        when(tokenProvider.getRefreshExpirationMs()).thenReturn(604800000L);

        AuthTokens tokens = authService.verifyRegistrationOtp(email, otp);

        assertNotNull(tokens);
        assertEquals("access-token", tokens.accessToken());
        assertEquals("refresh-token", tokens.refreshToken());
        assertTrue(user.isActive());
        verify(userRepository).save(user);
        verify(redisTemplate).delete("otp:register:" + email);
    }

    @Test
    void verifyRegistrationOtp_InvalidOtp_ThrowsException() {
        String email = "test@example.com";
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        when(valueOperations.get("otp:register:" + email)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () -> authService.verifyRegistrationOtp(email, "123456"));
    }

    @Test
    void verifyPasswordResetOtp_Success() {
        String email = "test@example.com";
        String otp = "654321";
        User user = User.builder()
                .id("user-uuid")
                .email(email)
                .build();

        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        when(valueOperations.get("otp:reset:" + email)).thenReturn(otp);
        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));
        when(passwordEncoder.encode(any(String.class))).thenReturn("hashedToken");

        String resetToken = authService.verifyPasswordResetOtp(email, otp);

        assertNotNull(resetToken);
        verify(resetTokenRepository).save(any(PasswordResetToken.class));
        verify(redisTemplate).delete("otp:reset:" + email);
    }

    @Test
    void verifyPasswordResetOtp_InvalidOtp_ThrowsException() {
        String email = "test@example.com";
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        when(valueOperations.get("otp:reset:" + email)).thenReturn(null);

        assertThrows(IllegalArgumentException.class, () -> authService.verifyPasswordResetOtp(email, "654321"));
    }

    @Test
    void resetPassword_Success() {
        String rawToken = "raw-token";
        String newPassword = "NewPassword123";
        User user = User.builder()
                .passwordHash("oldHash")
                .build();

        PasswordResetToken prt = PasswordResetToken.builder()
                .user(user)
                .tokenHash("hashedToken")
                .expiresAt(LocalDateTime.now().plusHours(1))
                .used(false)
                .build();

        when(resetTokenRepository.findByUsedFalseAndExpiresAtAfter(any())).thenReturn(Collections.singletonList(prt));
        when(passwordEncoder.matches(rawToken, "hashedToken")).thenReturn(true);
        when(passwordEncoder.encode(newPassword)).thenReturn("newHashedPass");

        authService.resetPassword(rawToken, newPassword);

        assertTrue(prt.isUsed());
        assertEquals("newHashedPass", user.getPasswordHash());
        verify(userRepository).save(user);
        verify(resetTokenRepository).save(prt);
    }

    @Test
    void loginUser_InactiveUser_ThrowsException() {
        String email = "test@example.com";
        String rawPassword = "Password123";
        String userId = "user-uuid";

        User user = User.builder()
                .id(userId)
                .email(email)
                .passwordHash("hashedPass")
                .active(false)
                .build();

        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches(rawPassword, "hashedPass")).thenReturn(true);

        assertThrows(BadCredentialsException.class, () -> authService.loginUser(email, rawPassword));
    }

    @Test
    void refreshAccessToken_InactiveUser_ThrowsException() {
        String refreshToken = "valid-refresh-token";
        String userId = "user-uuid";
        Claims claims = mock(Claims.class);
        when(claims.getSubject()).thenReturn(userId);

        User user = User.builder()
                .id(userId)
                .role(Role.STUDENT)
                .active(false)
                .build();

        when(tokenProvider.validateRefreshToken(refreshToken)).thenReturn(claims);
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        when(valueOperations.get("refresh:" + userId)).thenReturn(refreshToken);
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));

        assertThrows(BadCredentialsException.class, () -> authService.refreshAccessToken(refreshToken));
    }

    @Test
    void resetPassword_SecondUse_ThrowsException() {
        String rawToken = "raw-token";
        String newPassword = "NewPassword123";

        when(resetTokenRepository.findByUsedFalseAndExpiresAtAfter(any())).thenReturn(Collections.emptyList());

        assertThrows(ResourceNotFoundException.class, () -> authService.resetPassword(rawToken, newPassword));
    }

    @Test
    void resetPassword_ExpiredToken_ThrowsException() {
        String rawToken = "raw-token";
        String newPassword = "NewPassword123";

        when(resetTokenRepository.findByUsedFalseAndExpiresAtAfter(any())).thenReturn(Collections.emptyList());

        assertThrows(ResourceNotFoundException.class, () -> authService.resetPassword(rawToken, newPassword));
    }

    @Test
    void requestPasswordReset_NonExistentEmail_DoesNotThrow() {
        String email = "missing@example.com";
        when(userRepository.findByEmail(email)).thenReturn(Optional.empty());

        assertDoesNotThrow(() -> authService.requestPasswordReset(email));
        verify(resetTokenRepository, never()).save(any());
        verify(emailService, never()).sendPasswordResetEmail(any(), any());
    }
}
