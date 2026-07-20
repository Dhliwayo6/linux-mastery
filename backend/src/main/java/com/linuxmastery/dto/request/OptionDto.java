package com.linuxmastery.dto.request;

import jakarta.validation.constraints.NotBlank;

public record OptionDto(
    @NotBlank String id,
    @NotBlank String text
) {}
