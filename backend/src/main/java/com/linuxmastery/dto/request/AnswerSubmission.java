package com.linuxmastery.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record AnswerSubmission(
    @NotBlank String questionId,
    @NotBlank @Size(max = 500) String selectedAnswer
) {}
