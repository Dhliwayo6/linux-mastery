package com.linuxmastery.dto.response;

import java.util.List;

public record ProjectSubmissionResponse(
    int score,
    List<TestCaseResult> results,
    String memoMd,
    int attemptNumber
) {}
