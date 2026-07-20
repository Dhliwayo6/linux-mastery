package com.linuxmastery.dto.response;

public record AdminQuestionResponse(
    String id,
    String moduleId,
    String questionText,
    String optionsJson,
    String correctAnswer,
    String explanation
) {}
