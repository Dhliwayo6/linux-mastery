package com.linuxmastery.sandbox;

public record RunResult(
    String stdout,
    String stderr,
    int exitCode,
    boolean timedOut
) {}
