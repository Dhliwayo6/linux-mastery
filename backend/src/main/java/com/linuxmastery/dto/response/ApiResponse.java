package com.linuxmastery.dto.response;

public record ApiResponse<T>(
    boolean success,
    T data,
    String error
) {}
