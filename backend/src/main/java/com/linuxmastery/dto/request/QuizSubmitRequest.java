package com.linuxmastery.dto.request;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import java.util.List;

public record QuizSubmitRequest(
    @NotEmpty @Size(max = 5) List<AnswerSubmission> answers
) {}
