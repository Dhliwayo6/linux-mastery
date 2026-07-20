package com.linuxmastery.dto.response;

public record SectionSummaryResponse(
    String id,
    String title,
    Integer orderIndex,
    boolean unlocked,
    boolean completed
) {}
