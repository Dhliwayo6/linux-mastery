package com.linuxmastery.dto.response;

public record QuestionFeedback(
    String questionId,
    boolean correct,
    String selectedAnswer,
    String correctAnswer,
    String explanation
) {}
