package com.linuxmastery.exception;

import com.linuxmastery.dto.response.ApiResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(GlobalExceptionHandler.class);

    private void logSecurityEvent(jakarta.servlet.http.HttpServletRequest request, int status, Exception ex) {
        org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        String userId = (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) ? auth.getName() : "anonymous";
        
        log.warn("API Error: status={}, method={}, path={}, userId={}, exception={}",
                status, request.getMethod(), request.getRequestURI(), userId, ex.getMessage());
    }

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<ApiResponse<Void>> handleBadCredentials(BadCredentialsException ex, jakarta.servlet.http.HttpServletRequest request) {
        logSecurityEvent(request, 401, ex);
        return ResponseEntity.status(401).body(new ApiResponse<>(false, null, "Invalid email or password"));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Void>> handleValidation(MethodArgumentNotValidException ex, jakarta.servlet.http.HttpServletRequest request) {
        String errorMsg = ex.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        logSecurityEvent(request, 400, ex);
        return ResponseEntity.status(400).body(new ApiResponse<>(false, null, errorMsg));
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleNotFound(ResourceNotFoundException ex, jakarta.servlet.http.HttpServletRequest request) {
        logSecurityEvent(request, 404, ex);
        return ResponseEntity.status(404).body(new ApiResponse<>(false, null, ex.getMessage()));
    }

    @ExceptionHandler(ForbiddenException.class)
    public ResponseEntity<ApiResponse<Void>> handleForbidden(ForbiddenException ex, jakarta.servlet.http.HttpServletRequest request) {
        logSecurityEvent(request, 403, ex);
        return ResponseEntity.status(403).body(new ApiResponse<>(false, null, ex.getMessage()));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse<Void>> handleIllegalArgument(IllegalArgumentException ex, jakarta.servlet.http.HttpServletRequest request) {
        logSecurityEvent(request, 400, ex);
        return ResponseEntity.status(400).body(new ApiResponse<>(false, null, ex.getMessage()));
    }

    @ExceptionHandler(TooManyAttemptsException.class)
    public ResponseEntity<ApiResponse<Void>> handleTooManyAttempts(TooManyAttemptsException ex, jakarta.servlet.http.HttpServletRequest request) {
        logSecurityEvent(request, 400, ex);
        return ResponseEntity.status(400).body(new ApiResponse<>(false, null, ex.getMessage()));
    }

    @ExceptionHandler(RateLimitExceededException.class)
    public ResponseEntity<ApiResponse<Void>> handleRateLimitExceeded(RateLimitExceededException ex, jakarta.servlet.http.HttpServletRequest request) {
        logSecurityEvent(request, 429, ex);
        return ResponseEntity.status(429).body(new ApiResponse<>(false, null, ex.getMessage()));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGenericException(Exception ex, jakarta.servlet.http.HttpServletRequest request) {
        logSecurityEvent(request, 500, ex);
        return ResponseEntity.status(500).body(new ApiResponse<>(false, null, "An unexpected error occurred. Please try again later."));
    }
}
