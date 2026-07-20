package com.linuxmastery.dto.response;

public record TestCaseResult(
    String testCaseId,
    String description,
    int weight,
    boolean passed,
    String expected,
    String actual
) {}
