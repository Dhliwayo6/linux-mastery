package com.linuxmastery.service;

import com.linuxmastery.entity.PasswordResetToken;
import com.linuxmastery.entity.Role;
import com.linuxmastery.entity.User;
import com.linuxmastery.exception.ResourceNotFoundException;
import com.linuxmastery.repository.PasswordResetTokenRepository;
import com.linuxmastery.repository.UserRepository;
import com.linuxmastery.security.AuthTokens;
import com.linuxmastery.security.JwtTokenProvider;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
@Transactional
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordResetTokenRepository resetTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider tokenProvider;
    private final StringRedisTemplate redisTemplate;
    private final EmailService emailService;
    private final SecureRandom secureRandom = new SecureRandom();
    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(AuthService.class);

    private String getClientIP() {
        try {
            org.springframework.web.context.request.RequestAttributes attributes = 
                org.springframework.web.context.request.RequestContextHolder.getRequestAttributes();
            if (attributes instanceof org.springframework.web.context.request.ServletRequestAttributes) {
                jakarta.servlet.http.HttpServletRequest req = 
                    ((org.springframework.web.context.request.ServletRequestAttributes) attributes).getRequest();
                String xfHeader = req.getHeader("X-Forwarded-For");
                if (xfHeader == null) {
                    return req.getRemoteAddr();
                }
                return xfHeader.split(",")[0].trim();
            }
        } catch (Exception ignored) {}
        return "unknown";
    }

    @Autowired
    public AuthService(UserRepository userRepository,
                       PasswordResetTokenRepository resetTokenRepository,
                       PasswordEncoder passwordEncoder,
                       JwtTokenProvider tokenProvider,
                       StringRedisTemplate redisTemplate,
                       EmailService emailService) {
        this.userRepository = userRepository;
        this.resetTokenRepository = resetTokenRepository;
        this.passwordEncoder = passwordEncoder;
        this.tokenProvider = tokenProvider;
        this.redisTemplate = redisTemplate;
        this.emailService = emailService;
    }

    public User registerUser(String email, String rawPassword, String displayName) {
        if (userRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("Email already registered");
        }
        User user = User.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode(rawPassword))
                .displayName(displayName)
                .role(email.equalsIgnoreCase("admin@linuxmastery.com") ? Role.ADMIN : Role.STUDENT)
                .active(false)
                .build();
        User savedUser = userRepository.save(user);
        
        sendRegistrationOtp(email);

        log.info("Successful registration: userId={}, timestamp={}", savedUser.getId(), java.time.Instant.now());
        return savedUser;
    }

    public AuthTokens loginUser(String email, String rawPassword) {
        try {
            User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new BadCredentialsException("Invalid email or password"));

            if (!passwordEncoder.matches(rawPassword, user.getPasswordHash())) {
                throw new BadCredentialsException("Invalid email or password");
            }

            if (!user.isActive()) {
                throw new BadCredentialsException("Invalid email or password");
            }

            String accessToken = tokenProvider.generateAccessToken(user.getId(), user.getRole().name());
            String refreshToken = tokenProvider.generateRefreshToken(user.getId());

            // Store refresh token in Redis matching the token's expiration TTL
            redisTemplate.opsForValue().set("refresh:" + user.getId(), refreshToken, tokenProvider.getRefreshExpirationMs(), TimeUnit.MILLISECONDS);

            log.info("Successful login: userId={}, ip={}, timestamp={}", user.getId(), getClientIP(), java.time.Instant.now());

            return new AuthTokens(accessToken, refreshToken);
        } catch (BadCredentialsException e) {
            log.warn("Failed login: ip={}, timestamp={}", getClientIP(), java.time.Instant.now());
            throw e;
        }
    }

    public AuthTokens refreshAccessToken(String refreshToken) {
        if (refreshToken == null) {
            throw new BadCredentialsException("Missing refresh token");
        }
        try {
            Claims claims = tokenProvider.validateRefreshToken(refreshToken);
            String userId = claims.getSubject();

            String storedToken = redisTemplate.opsForValue().get("refresh:" + userId);
            if (storedToken == null || !storedToken.equals(refreshToken)) {
                // If token is missing from Redis (revoked/rotated), reject
                throw new BadCredentialsException("Invalid or expired refresh token");
            }

            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new BadCredentialsException("User not found"));

            if (!user.isActive()) {
                throw new BadCredentialsException("Invalid or expired refresh token");
            }

            String newAccessToken = tokenProvider.generateAccessToken(user.getId(), user.getRole().name());
            String newRefreshToken = tokenProvider.generateRefreshToken(user.getId());

            // Rotate refresh token in Redis with matching TTL
            redisTemplate.opsForValue().set("refresh:" + user.getId(), newRefreshToken, tokenProvider.getRefreshExpirationMs(), TimeUnit.MILLISECONDS);

            return new AuthTokens(newAccessToken, newRefreshToken);
        } catch (JwtException e) {
            throw new BadCredentialsException("Invalid or expired refresh token");
        }
    }

    public void logoutUser(String refreshToken) {
        if (refreshToken == null) {
            return;
        }
        try {
            Claims claims = tokenProvider.validateRefreshToken(refreshToken);
            String userId = claims.getSubject();
            redisTemplate.delete("refresh:" + userId);
        } catch (JwtException ignored) {
            // Ignore token validation issues on logout
        }
    }

    public void requestPasswordReset(String email) {
        log.info("Password reset request: ip={}, timestamp={}", getClientIP(), java.time.Instant.now());
        userRepository.findByEmail(email).ifPresent(user -> {
            byte[] bytes = new byte[32];
            secureRandom.nextBytes(bytes);
            String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
            String tokenHash = passwordEncoder.encode(token);

            PasswordResetToken prt = PasswordResetToken.builder()
                    .user(user)
                    .tokenHash(tokenHash)
                    .expiresAt(LocalDateTime.now().plusMinutes(30))
                    .build();
            resetTokenRepository.save(prt);

            emailService.sendPasswordResetEmail(user.getEmail(), token);
        });
    }

    public void resetPassword(String token, String newPassword) {
        LocalDateTime now = LocalDateTime.now();
        List<PasswordResetToken> activeTokens = resetTokenRepository.findByUsedFalseAndExpiresAtAfter(now).stream()
                .filter(t -> passwordEncoder.matches(token, t.getTokenHash()))
                .toList();

        if (activeTokens.isEmpty()) {
            throw new ResourceNotFoundException("Invalid or expired password reset token");
        }

        PasswordResetToken resetToken = activeTokens.get(0);
        User user = resetToken.getUser();
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        resetToken.setUsed(true);
        resetTokenRepository.save(resetToken);

        log.info("Password reset completed: userId={}, timestamp={}", user.getId(), java.time.Instant.now());
    }

    public void sendRegistrationOtp(String email) {
        String otp = String.format("%06d", secureRandom.nextInt(1000000));
        redisTemplate.opsForValue().set("otp:register:" + email, otp, 15, TimeUnit.MINUTES);
        emailService.sendRegistrationOtpEmail(email, otp);
    }

    public void resendRegistrationOtp(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        if (user.isActive()) {
            throw new IllegalArgumentException("User is already verified");
        }
        sendRegistrationOtp(email);
    }

    public AuthTokens verifyRegistrationOtp(String email, String otp) {
        String storedOtp = redisTemplate.opsForValue().get("otp:register:" + email);
        if (storedOtp == null || !storedOtp.equals(otp)) {
            throw new IllegalArgumentException("Invalid or expired verification code");
        }

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        user.setActive(true);
        userRepository.save(user);

        redisTemplate.delete("otp:register:" + email);

        String accessToken = tokenProvider.generateAccessToken(user.getId(), user.getRole().name());
        String refreshToken = tokenProvider.generateRefreshToken(user.getId());
        redisTemplate.opsForValue().set("refresh:" + user.getId(), refreshToken, tokenProvider.getRefreshExpirationMs(), TimeUnit.MILLISECONDS);

        log.info("Successful OTP verification: userId={}, timestamp={}", user.getId(), java.time.Instant.now());
        return new AuthTokens(accessToken, refreshToken);
    }

    public void requestPasswordResetOtp(String email) {
        log.info("Password reset OTP request: email={}, ip={}, timestamp={}", email, getClientIP(), java.time.Instant.now());
        userRepository.findByEmail(email).ifPresent(user -> {
            String otp = String.format("%06d", secureRandom.nextInt(1000000));
            redisTemplate.opsForValue().set("otp:reset:" + email, otp, 15, TimeUnit.MINUTES);
            emailService.sendPasswordResetOtpEmail(user.getEmail(), otp);
        });
    }

    public String verifyPasswordResetOtp(String email, String otp) {
        String storedOtp = redisTemplate.opsForValue().get("otp:reset:" + email);
        if (storedOtp == null || !storedOtp.equals(otp)) {
            throw new IllegalArgumentException("Invalid or expired password reset code");
        }

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        String tokenHash = passwordEncoder.encode(token);

        PasswordResetToken prt = PasswordResetToken.builder()
                .user(user)
                .tokenHash(tokenHash)
                .expiresAt(LocalDateTime.now().plusMinutes(30))
                .build();
        resetTokenRepository.save(prt);

        redisTemplate.delete("otp:reset:" + email);

        log.info("Password reset OTP verified: userId={}, timestamp={}", user.getId(), java.time.Instant.now());
        return token;
    }

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }
}
