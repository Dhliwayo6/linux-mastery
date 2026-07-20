package com.linuxmastery.controller;

import com.linuxmastery.config.RateLimitFilter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;

import java.io.IOException;

import static org.junit.jupiter.api.Assertions.*;

class RateLimitIntegrationTest {

    private RateLimitFilter filter;

    @BeforeEach
    void setUp() {
        filter = new RateLimitFilter();
        SecurityContextHolder.clearContext();
    }

    @Test
    void loginRateLimiting_failedAttemptsTrigger429() throws Exception {
        // 5 failed login attempts
        for (int i = 0; i < 5; i++) {
            MockFilterChain filterChain = new MockFilterChain() {
                @Override
                public void doFilter(jakarta.servlet.ServletRequest request, jakarta.servlet.ServletResponse response) 
                        throws IOException, ServletException {
                    ((MockHttpServletResponse) response).setStatus(401);
                    super.doFilter(request, response);
                }
            };
            MockHttpServletRequest request = new MockHttpServletRequest("POST", "/api/v1/auth/login");
            request.setRemoteAddr("1.2.3.4");
            MockHttpServletResponse response = new MockHttpServletResponse();
            
            filter.doFilter(request, response, filterChain);
            assertEquals(401, response.getStatus());
        }

        // The 6th attempt should be blocked and return 429
        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/api/v1/auth/login");
        request.setRemoteAddr("1.2.3.4");
        MockHttpServletResponse response = new MockHttpServletResponse();
        
        filter.doFilter(request, response, new MockFilterChain());
        assertEquals(429, response.getStatus());
        assertNotNull(response.getHeader("Retry-After"));
    }

    @Test
    void registerRateLimiting_triggers429() throws Exception {
        // Perform 10 registration attempts
        for (int i = 0; i < 10; i++) {
            MockHttpServletRequest request = new MockHttpServletRequest("POST", "/api/v1/auth/register");
            request.setRemoteAddr("1.2.3.4");
            MockHttpServletResponse response = new MockHttpServletResponse();
            
            filter.doFilter(request, response, new MockFilterChain());
            assertEquals(200, response.getStatus());
        }

        // The 11th registration attempt should return 429
        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/api/v1/auth/register");
        request.setRemoteAddr("1.2.3.4");
        MockHttpServletResponse response = new MockHttpServletResponse();
        
        filter.doFilter(request, response, new MockFilterChain());
        assertEquals(429, response.getStatus());
    }

    @Test
    void projectSubmissionRateLimiting_triggers429() throws Exception {
        // Mock authentication context for user
        SecurityContextHolder.getContext().setAuthentication(
            new UsernamePasswordAuthenticationToken("mock-user", "password")
        );

        // Perform 5 submissions
        for (int i = 0; i < 5; i++) {
            MockHttpServletRequest request = new MockHttpServletRequest("POST", "/api/v1/project/mod1/submit");
            MockHttpServletResponse response = new MockHttpServletResponse();
            
            filter.doFilter(request, response, new MockFilterChain());
            assertEquals(200, response.getStatus());
        }

        // The 6th submission should return 429
        MockHttpServletRequest request = new MockHttpServletRequest("POST", "/api/v1/project/mod1/submit");
        MockHttpServletResponse response = new MockHttpServletResponse();
        
        filter.doFilter(request, response, new MockFilterChain());
        assertEquals(429, response.getStatus());
    }
}
