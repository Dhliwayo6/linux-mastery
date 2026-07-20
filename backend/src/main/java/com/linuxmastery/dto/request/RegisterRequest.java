package com.linuxmastery.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record RegisterRequest(
    @NotBlank(message = "Email is required") 
    @Email(message = "Invalid email format") 
    String email,

    @NotBlank(message = "Password is required") 
    @Size(min = 8, message = "Password must be at least 8 characters") 
    @Pattern(regexp = "^(?=.*[A-Z])(?=.*\\d).+$", message = "Password must contain at least one uppercase letter and one digit")
    String password,

    @NotBlank(message = "Display name is required")
    @Size(max = 100, message = "Display name must be less than 100 characters")
    String displayName
) {}
