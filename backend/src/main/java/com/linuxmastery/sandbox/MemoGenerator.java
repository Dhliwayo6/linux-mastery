package com.linuxmastery.sandbox;

import com.linuxmastery.dto.response.TestCaseResult;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class MemoGenerator {

    public String generate(String projectTitle, int score, List<TestCaseResult> results, RunResult runResult) {
        StringBuilder memo = new StringBuilder();
        memo.append("# Submission Memo: ").append(projectTitle).append("\n\n");
        memo.append("**Score: ").append(score).append("/100**\n\n");

        if (runResult.timedOut()) {
            memo.append("> **Warning:** Your script exceeded the 10-second time limit and was terminated.\n\n");
        }

        memo.append("## Test Results\n\n");
        memo.append("| Test | Weight | Result |\n|------|--------|--------|\n");
        for (TestCaseResult r : results) {
            memo.append("| ").append(r.description()).append(" | ").append(r.weight())
                .append(" | ").append(r.passed() ? "Pass" : "Fail").append(" |\n");
        }

        List<TestCaseResult> failed = results.stream().filter(r -> !r.passed()).toList();
        if (!failed.isEmpty()) {
            memo.append("\n## What to Fix\n\n");
            for (TestCaseResult r : failed) {
                memo.append("### ").append(r.description()).append("\n");
                memo.append("- **Expected:** `").append(r.expected()).append("`\n");
                if (r.actual() != null && !r.actual().isBlank()) {
                    String snippet = r.actual().length() > 300 ? r.actual().substring(0, 300) : r.actual();
                    memo.append("- **Your output:**\n```\n").append(snippet).append("\n```\n\n");
                }
            }
        }

        if (runResult.stderr() != null && !runResult.stderr().isBlank()) {
            String snippet = runResult.stderr().length() > 500
                ? runResult.stderr().substring(0, 500) : runResult.stderr();
            memo.append("\n## Standard Error Output\n\n```\n").append(snippet).append("\n```\n");
        }

        return memo.toString();
    }
}
