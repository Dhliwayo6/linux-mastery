package com.linuxmastery.dto.response;

import java.util.List;

public record AssessmentQuestionResponse(
    String id,
    String questionText,
    List<QuizOption> options
) {}
