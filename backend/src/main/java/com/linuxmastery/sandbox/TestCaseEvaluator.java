package com.linuxmastery.sandbox;

import com.linuxmastery.dto.response.TestCaseResult;
import com.linuxmastery.entity.ProjectTestCase;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.regex.Pattern;

@Component
public class TestCaseEvaluator {

    public TestCaseResult evaluate(ProjectTestCase testCase, RunResult result, String scriptContent) {
        boolean passed;
        String actual;

        switch (testCase.getTestType()) {
            case EXIT_CODE -> {
                actual = String.valueOf(result.exitCode());
                passed = actual.equals(testCase.getExpected());
            }
            case STDOUT_CONTAINS -> {
                actual = result.stdout();
                passed = result.stdout().contains(testCase.getExpected());
            }
            case STDOUT_MATCHES -> {
                actual = result.stdout();
                passed = Pattern.compile(testCase.getExpected(), Pattern.CASE_INSENSITIVE | Pattern.DOTALL)
                    .matcher(result.stdout()).find();
            }
            case COMMAND_USED -> {
                actual = scriptContent;
                passed = scriptContent.contains(testCase.getExpected());
            }
            default -> throw new IllegalStateException("Unknown test type");
        }

        String truncated = actual != null && actual.length() > 500 ? actual.substring(0, 500) : actual;
        return new TestCaseResult(
            testCase.getId(),
            testCase.getDescription(),
            testCase.getWeight(),
            passed,
            testCase.getExpected(),
            truncated
        );
    }

    public int calculateScore(List<TestCaseResult> results) {
        int totalWeight = results.stream().mapToInt(TestCaseResult::weight).sum();
        int earnedWeight = results.stream().filter(TestCaseResult::passed)
            .mapToInt(TestCaseResult::weight).sum();
        return totalWeight == 0 ? 0 : Math.round((earnedWeight * 100.0f) / totalWeight);
    }
}
