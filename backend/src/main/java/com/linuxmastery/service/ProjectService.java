package com.linuxmastery.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.linuxmastery.dto.response.ProjectResponse;
import com.linuxmastery.dto.response.ProjectSubmissionResponse;
import com.linuxmastery.dto.response.TestCaseResult;
import com.linuxmastery.entity.*;
import com.linuxmastery.entity.Module;
import com.linuxmastery.exception.ResourceNotFoundException;
import com.linuxmastery.exception.TooManyAttemptsException;
import com.linuxmastery.repository.*;
import com.linuxmastery.sandbox.MemoGenerator;
import com.linuxmastery.sandbox.RunResult;
import com.linuxmastery.sandbox.ScriptRunner;
import com.linuxmastery.sandbox.TestCaseEvaluator;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
@Transactional
public class ProjectService {

    private final ProjectRepository projectRepository;
    private final ProjectSubmissionRepository projectSubmissionRepository;
    private final UserProgressRepository userProgressRepository;
    private final UserRepository userRepository;
    private final ModuleRepository moduleRepository;
    private final ScriptRunner scriptRunner;
    private final TestCaseEvaluator testCaseEvaluator;
    private final MemoGenerator memoGenerator;
    private final ObjectMapper objectMapper;

    public ProjectService(ProjectRepository projectRepository,
                          ProjectSubmissionRepository projectSubmissionRepository,
                          UserProgressRepository userProgressRepository,
                          UserRepository userRepository,
                          ModuleRepository moduleRepository,
                          ScriptRunner scriptRunner,
                          TestCaseEvaluator testCaseEvaluator,
                          MemoGenerator memoGenerator) {
        this.projectRepository = projectRepository;
        this.projectSubmissionRepository = projectSubmissionRepository;
        this.userProgressRepository = userProgressRepository;
        this.userRepository = userRepository;
        this.moduleRepository = moduleRepository;
        this.scriptRunner = scriptRunner;
        this.testCaseEvaluator = testCaseEvaluator;
        this.memoGenerator = memoGenerator;
        this.objectMapper = new ObjectMapper();
    }

    public ProjectResponse getProjectBrief(String moduleId) {
        Project project = projectRepository.findByModuleId(moduleId)
                .orElseThrow(() -> new ResourceNotFoundException("Project not found for module: " + moduleId));
        return new ProjectResponse(project.getId(), project.getTitle(), project.getBriefMd());
    }

    public List<ProjectSubmission> getSubmissionHistory(String moduleId, String userId) {
        Project project = projectRepository.findByModuleId(moduleId)
                .orElseThrow(() -> new ResourceNotFoundException("Project not found for module: " + moduleId));
        return projectSubmissionRepository.findByUserIdAndProjectIdOrderByCreatedAtDesc(userId, project.getId());
    }

    public ProjectSubmissionResponse submitProject(String moduleId, String userId, String scriptContent) {
        Project project = projectRepository.findByModuleId(moduleId)
                .orElseThrow(() -> new ResourceNotFoundException("Project not found for module: " + moduleId));

        long attemptCount = projectSubmissionRepository.countByUserIdAndProjectId(userId, project.getId());
        if (attemptCount >= 3) {
            throw new TooManyAttemptsException("Maximum submission attempts reached for this project");
        }

        validateScript(scriptContent);

        RunResult runResult = scriptRunner.run(scriptContent);

        List<TestCaseResult> results = project.getTestCases().stream()
                .map(tc -> testCaseEvaluator.evaluate(tc, runResult, scriptContent))
                .toList();

        int score = testCaseEvaluator.calculateScore(results);
        String memo = memoGenerator.generate(project.getTitle(), score, results, runResult);

        ProjectSubmission submission = new ProjectSubmission();
        submission.setUserId(userId);
        submission.setProjectId(project.getId());
        submission.setScriptContent(scriptContent);
        submission.setScore(BigDecimal.valueOf(score));
        submission.setTestResultsJson(serializeResults(results));
        submission.setMemoMd(memo);
        submission.setAttemptNumber((int) attemptCount + 1);
        projectSubmissionRepository.save(submission);

        // Update progress
        Module module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new ResourceNotFoundException("Module not found: " + moduleId));

        UserProgress progress = userProgressRepository.findByUserIdAndModuleId(userId, moduleId)
                .orElseGet(() -> {
                    User user = userRepository.findById(userId)
                            .orElseThrow(() -> new ResourceNotFoundException("User not found: " + userId));
                    return UserProgress.builder()
                            .user(user)
                            .module(module)
                            .sectionsCompleted(0)
                            .totalSections(module.getSections().size())
                            .build();
                });

        BigDecimal scoreDecimal = BigDecimal.valueOf(score);
        BigDecimal currentBest = progress.getBestProjectScore();
        if (currentBest == null || scoreDecimal.compareTo(currentBest) > 0) {
            progress.setBestProjectScore(scoreDecimal);
        }

        boolean allSectionsCompleted = progress.getSectionsCompleted() >= progress.getTotalSections();
        boolean assessmentPassed = progress.getAssessmentPassed() != null && progress.getAssessmentPassed();
        boolean projectSubmitted = progress.getBestProjectScore() != null;
        if (allSectionsCompleted && assessmentPassed && projectSubmitted) {
            progress.setModuleCompleted(true);
            progress.setModuleCompletedAt(LocalDateTime.now());
        }

        userProgressRepository.save(progress);

        return new ProjectSubmissionResponse(score, results, memo, (int) attemptCount + 1);
    }

    private void validateScript(String scriptContent) {
        if (scriptContent == null || scriptContent.trim().isEmpty()) {
            throw new IllegalArgumentException("Script content cannot be empty");
        }
        if (scriptContent.length() > 50000) {
            throw new IllegalArgumentException("Script content exceeds maximum allowed size of 50KB");
        }
        if (!scriptContent.startsWith("#!")) {
            throw new IllegalArgumentException("Script must start with a valid shebang (e.g., #!/bin/bash or #!/usr/bin/env bash)");
        }
    }

    private String serializeResults(List<TestCaseResult> results) {
        try {
            return objectMapper.writeValueAsString(results);
        } catch (Exception e) {
            return "[]";
        }
    }
}
