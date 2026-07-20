package com.linuxmastery.dto.response;

public record AuthResponse(
    String accessToken,
    String email,
    String displayName
) {}
