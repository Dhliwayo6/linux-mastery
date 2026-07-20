package com.linuxmastery.dto.response;

import java.util.List;

public record SectionResponse(
    String id,
    String moduleId,
    String title,
    String contentMd,
    Integer orderIndex,
    boolean unlocked,
    boolean completed,
    List<QuizQuestionResponse> quizQuestions
) {}
