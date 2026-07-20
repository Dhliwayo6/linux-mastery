package com.linuxmastery.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import java.util.List;

public record AdminQuestionRequest(
    @NotBlank String moduleId,
    @NotBlank String questionText,
    @NotEmpty @Size(min = 4, max = 4) List<OptionDto> options,
    @NotBlank String correctAnswer,
    @NotBlank String explanation
) {}
