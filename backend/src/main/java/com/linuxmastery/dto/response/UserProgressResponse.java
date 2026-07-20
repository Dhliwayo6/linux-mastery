package com.linuxmastery.dto.response;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record UserProgressResponse(
    String id,
    String moduleId,
    String moduleTitle,
    String moduleSlug,
    Integer sectionsCompleted,
    Integer totalSections,
    BigDecimal bestAssessmentScore,
    boolean assessmentPassed,
    BigDecimal bestProjectScore,
    boolean moduleCompleted,
    LocalDateTime moduleCompletedAt
) {}
