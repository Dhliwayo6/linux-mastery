package com.linuxmastery.dto.response;

import java.util.List;

public record AssessmentResultResponse(
    double score,
    boolean passed,
    List<QuestionFeedback> feedback
) {}
