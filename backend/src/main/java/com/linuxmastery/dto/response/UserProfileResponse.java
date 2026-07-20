package com.linuxmastery.dto.response;

public record UserProfileResponse(
    String id,
    String email,
    String displayName,
    String role
) {}
