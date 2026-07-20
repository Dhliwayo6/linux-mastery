package com.linuxmastery.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ProjectSubmitRequest(
    @NotBlank(message = "Script content cannot be blank")
    @Size(max = 50000, message = "Script content must be less than 50KB")
    String script
) {}
