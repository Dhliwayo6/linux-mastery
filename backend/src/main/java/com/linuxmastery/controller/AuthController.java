package com.linuxmastery.controller;

import com.linuxmastery.dto.request.ForgotPasswordRequest;
import com.linuxmastery.dto.request.LoginRequest;
import com.linuxmastery.dto.request.RegisterRequest;
import com.linuxmastery.dto.request.ResetPasswordRequest;
import com.linuxmastery.dto.request.VerifyOtpRequest;
import com.linuxmastery.dto.request.ResendOtpRequest;
import com.linuxmastery.dto.response.ApiResponse;
import com.linuxmastery.dto.response.AuthResponse;
import com.linuxmastery.dto.response.RegisterResponse;
import com.linuxmastery.dto.response.ForgotPasswordVerifyResponse;
import com.linuxmastery.security.AuthTokens;
import com.linuxmastery.service.AuthService;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.linuxmastery.entity.User;
import java.time.Duration;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    private final AuthService authService;

    @Autowired
    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<RegisterResponse>> register(@Valid @RequestBody RegisterRequest req,
                                                                  HttpServletResponse response) {
        authService.registerUser(req.email(), req.password(), req.displayName());
        return ResponseEntity.ok(new ApiResponse<>(true, new RegisterResponse(req.email(), true), null));
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest req,
                                                           HttpServletResponse response) {
        AuthTokens tokens = authService.loginUser(req.email(), req.password());
        User user = authService.getUserByEmail(req.email());

        ResponseCookie cookie = ResponseCookie.from("refreshToken", tokens.refreshToken())
                .httpOnly(true).secure(true).sameSite("Strict")
                .maxAge(Duration.ofDays(7)).path("/api/v1/auth").build();
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());

        return ResponseEntity.ok(new ApiResponse<>(true, new AuthResponse(tokens.accessToken(), user.getEmail(), user.getDisplayName()), null));
    }

    @PostMapping("/refresh")
    public ResponseEntity<ApiResponse<AuthResponse>> refresh(
            @CookieValue(name = "refreshToken", required = false) String refreshToken,
            HttpServletResponse response) {
        AuthTokens tokens = authService.refreshAccessToken(refreshToken);

        ResponseCookie cookie = ResponseCookie.from("refreshToken", tokens.refreshToken())
                .httpOnly(true).secure(true).sameSite("Strict")
                .maxAge(Duration.ofDays(7)).path("/api/v1/auth").build();
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());

        return ResponseEntity.ok(new ApiResponse<>(true, new AuthResponse(tokens.accessToken(), null, null), null));
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@CookieValue(name = "refreshToken", required = false) String refreshToken,
                                       HttpServletResponse response) {
        authService.logoutUser(refreshToken);

        ResponseCookie cookie = ResponseCookie.from("refreshToken", "")
                .httpOnly(true).secure(true).sameSite("Strict")
                .maxAge(0).path("/api/v1/auth").build();
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());

        return ResponseEntity.ok().build();
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<Void> forgotPassword(@Valid @RequestBody ForgotPasswordRequest req) {
        authService.requestPasswordResetOtp(req.email());
        return ResponseEntity.ok().build();
    }

    @PostMapping("/verify-registration")
    public ResponseEntity<ApiResponse<AuthResponse>> verifyRegistration(
            @Valid @RequestBody VerifyOtpRequest req,
            HttpServletResponse response) {
        AuthTokens tokens = authService.verifyRegistrationOtp(req.email(), req.otp());
        User user = authService.getUserByEmail(req.email());

        ResponseCookie cookie = ResponseCookie.from("refreshToken", tokens.refreshToken())
                .httpOnly(true).secure(true).sameSite("Strict")
                .maxAge(Duration.ofDays(7)).path("/api/v1/auth").build();
        response.addHeader(HttpHeaders.SET_COOKIE, cookie.toString());

        return ResponseEntity.ok(new ApiResponse<>(true, new AuthResponse(tokens.accessToken(), user.getEmail(), user.getDisplayName()), null));
    }

    @PostMapping("/resend-registration-otp")
    public ResponseEntity<ApiResponse<Void>> resendRegistrationOtp(@Valid @RequestBody ResendOtpRequest req) {
        authService.resendRegistrationOtp(req.email());
        return ResponseEntity.ok(new ApiResponse<>(true, null, null));
    }

    @PostMapping("/verify-reset-otp")
    public ResponseEntity<ApiResponse<ForgotPasswordVerifyResponse>> verifyResetOtp(
            @Valid @RequestBody VerifyOtpRequest req) {
        String resetToken = authService.verifyPasswordResetOtp(req.email(), req.otp());
        return ResponseEntity.ok(new ApiResponse<>(true, new ForgotPasswordVerifyResponse(resetToken), null));
    }

    @PostMapping("/reset-password")
    public ResponseEntity<Void> resetPassword(@Valid @RequestBody ResetPasswordRequest req) {
        authService.resetPassword(req.token(), req.newPassword());
        return ResponseEntity.ok().build();
    }
}
