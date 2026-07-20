package com.linuxmastery.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import java.util.List;

public record AssessmentSubmitRequest(
    @NotEmpty @Size(min = 10, max = 10) List<AnswerSubmission> answers,
    @Min(1) @Max(900) int durationSecs
) {}
