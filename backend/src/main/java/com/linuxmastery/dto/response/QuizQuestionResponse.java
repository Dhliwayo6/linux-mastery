package com.linuxmastery.dto.response;

import com.linuxmastery.entity.QuestionType;
import java.util.List;

public record QuizQuestionResponse(
    String id,
    String questionText,
    QuestionType questionType,
    List<QuizOption> options,
    Integer orderIndex
) {}
