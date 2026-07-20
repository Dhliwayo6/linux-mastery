package com.linuxmastery.dto.response;

public record RegisterResponse(
    String email,
    boolean verificationRequired
) {}
