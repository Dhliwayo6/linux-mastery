package com.linuxmastery.dto.response;

import java.util.List;

public record ModuleResponse(
    String id,
    String slug,
    String title,
    String description,
    String level,
    Integer orderIndex,
    boolean unlocked,
    int sectionsCompleted,
    int totalSections,
    boolean completed,
    List<SectionSummaryResponse> sections
) {}
