package com.linuxmastery.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

@Component
public class JwtTokenProvider {

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.refresh-secret}")
    private String refreshSecret;

    @Value("${jwt.access-expiration-ms}")
    private long accessExpirationMs;

    @Value("${jwt.refresh-expiration-ms}")
    private long refreshExpirationMs;

    public long getRefreshExpirationMs() {
        return refreshExpirationMs;
    }

    public String generateAccessToken(String userId, String role) {
        return Jwts.builder()
            .subject(userId)
            .claim("role", role)
            .expiration(new Date(System.currentTimeMillis() + accessExpirationMs))
            .signWith(getAccessKey())
            .compact();
    }

    public String generateRefreshToken(String userId) {
        return Jwts.builder()
            .subject(userId)
            .expiration(new Date(System.currentTimeMillis() + refreshExpirationMs))
            .signWith(getRefreshKey())
            .compact();
    }

    public Claims validateAccessToken(String token) {
        return Jwts.parser().verifyWith(getAccessKey()).build()
            .parseSignedClaims(token).getPayload();
    }

    public Claims validateRefreshToken(String token) {
        return Jwts.parser().verifyWith(getRefreshKey()).build()
            .parseSignedClaims(token).getPayload();
    }

    private SecretKey getAccessKey() {
        return Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));
    }

    private SecretKey getRefreshKey() {
        return Keys.hmacShaKeyFor(refreshSecret.getBytes(StandardCharsets.UTF_8));
    }
}
