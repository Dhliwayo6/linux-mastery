package com.linuxmastery.config;

import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class RateLimitFilter extends OncePerRequestFilter {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(RateLimitFilter.class);

    private final Map<String, Bucket> loginFailBuckets = new ConcurrentHashMap<>();
    private final Map<String, Bucket> registerBuckets = new ConcurrentHashMap<>();
    private final Map<String, Bucket> forgotPasswordBuckets = new ConcurrentHashMap<>();
    private final Map<String, Bucket> projectSubmitBuckets = new ConcurrentHashMap<>();
    private final Map<String, Bucket> quizAssessmentBuckets = new ConcurrentHashMap<>();
    private final Map<String, Bucket> defaultBuckets = new ConcurrentHashMap<>();

    private Bucket createLoginFailBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(5, Refill.intervally(5, Duration.ofMinutes(15))))
            .build();
    }

    private Bucket createRegisterBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(10, Refill.intervally(10, Duration.ofHours(1))))
            .build();
    }

    private Bucket createForgotPasswordBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(10, Refill.intervally(10, Duration.ofHours(1))))
            .build();
    }

    private Bucket createProjectSubmitBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(5, Refill.intervally(5, Duration.ofMinutes(1))))
            .build();
    }

    private Bucket createQuizAssessmentBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(60, Refill.intervally(60, Duration.ofMinutes(1))))
            .build();
    }

    private Bucket createDefaultBucket() {
        return Bucket.builder()
            .addLimit(Bandwidth.classic(100, Refill.intervally(100, Duration.ofMinutes(1))))
            .build();
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        String method = request.getMethod();
        String ip = getClientIP(request);

        // 1. POST /api/v1/auth/login: 5 failed attempts per IP per 15 minutes
        if (path.equals("/api/v1/auth/login") && method.equalsIgnoreCase("POST")) {
            Bucket failBucket = loginFailBuckets.computeIfAbsent(ip, k -> createLoginFailBucket());
            io.github.bucket4j.EstimationProbe probe = failBucket.estimateAbilityToConsume(1);
            if (!probe.canBeConsumed()) {
                long seconds = probe.getNanosToWaitForRefill() / 1_000_000_000L;
                send429Response(response, seconds <= 0 ? 1 : seconds, ip, path);
                return;
            }

            filterChain.doFilter(request, response);

            if (response.getStatus() == 401 || response.getStatus() == 400) {
                failBucket.tryConsume(1);
            }
            return;
        }

        // 2. POST /api/v1/auth/register: 10 per hour per IP
        if (path.equals("/api/v1/auth/register") && method.equalsIgnoreCase("POST")) {
            Bucket bucket = registerBuckets.computeIfAbsent(ip, k -> createRegisterBucket());
            io.github.bucket4j.ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);
            if (!probe.isConsumed()) {
                long seconds = probe.getNanosToWaitForRefill() / 1_000_000_000L;
                send429Response(response, seconds <= 0 ? 1 : seconds, ip, path);
                return;
            }
            filterChain.doFilter(request, response);
            return;
        }

        // 3. POST /api/v1/auth/forgot-password: 10 per hour per IP
        if (path.equals("/api/v1/auth/forgot-password") && method.equalsIgnoreCase("POST")) {
            Bucket bucket = forgotPasswordBuckets.computeIfAbsent(ip, k -> createForgotPasswordBucket());
            io.github.bucket4j.ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);
            if (!probe.isConsumed()) {
                long seconds = probe.getNanosToWaitForRefill() / 1_000_000_000L;
                send429Response(response, seconds <= 0 ? 1 : seconds, ip, path);
                return;
            }
            filterChain.doFilter(request, response);
            return;
        }

        // 4. Authenticated endpoints rate limits
        if (path.startsWith("/api/v1/")) {
            org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            String userKey = (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) ? auth.getName() : ip;

            Bucket bucket;
            if (path.startsWith("/api/v1/project/") && path.endsWith("/submit") && method.equalsIgnoreCase("POST")) {
                bucket = projectSubmitBuckets.computeIfAbsent(userKey, k -> createProjectSubmitBucket());
            } else if (path.contains("/quiz") || path.contains("/assessment")) {
                bucket = quizAssessmentBuckets.computeIfAbsent(userKey, k -> createQuizAssessmentBucket());
            } else {
                bucket = defaultBuckets.computeIfAbsent(userKey, k -> createDefaultBucket());
            }

            io.github.bucket4j.ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);
            if (!probe.isConsumed()) {
                long seconds = probe.getNanosToWaitForRefill() / 1_000_000_000L;
                send429Response(response, seconds <= 0 ? 1 : seconds, userKey, path);
                return;
            }
        }

        filterChain.doFilter(request, response);
    }

    private void send429Response(HttpServletResponse response, long retryAfterSeconds, String limitKey, String path) throws IOException {
        log.warn("Rate limit exceeded: key={}, path={}, timestamp={}", limitKey, path, java.time.Instant.now());
        response.setStatus(429);
        response.setHeader("Retry-After", String.valueOf(retryAfterSeconds));
        response.setContentType("application/json");
        response.getWriter().write("{\"success\":false,\"data\":null,\"error\":\"Too many requests. Please try again later.\"}");
    }

    private String getClientIP(HttpServletRequest request) {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader == null) {
            return request.getRemoteAddr();
        }
        return xfHeader.split(",")[0].trim();
    }
}
