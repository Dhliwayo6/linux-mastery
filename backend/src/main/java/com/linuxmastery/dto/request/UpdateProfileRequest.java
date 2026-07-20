package com.linuxmastery.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record UpdateProfileRequest(
    @NotBlank(message = "Display name is required")
    @Size(max = 50, message = "Display name cannot exceed 50 characters")
    String displayName,

    @NotBlank(message = "Email is required")
    @Email(message = "Email must be valid")
    String email
) {}
