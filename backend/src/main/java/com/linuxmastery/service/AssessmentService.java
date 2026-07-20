package com.linuxmastery.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.linuxmastery.dto.request.AnswerSubmission;
import com.linuxmastery.dto.response.AssessmentQuestionResponse;
import com.linuxmastery.dto.response.AssessmentResultResponse;
import com.linuxmastery.dto.response.QuestionFeedback;
import com.linuxmastery.dto.response.QuizOption;
import com.linuxmastery.entity.AssessmentAttempt;
import com.linuxmastery.entity.AssessmentQuestion;
import com.linuxmastery.entity.Module;
import com.linuxmastery.entity.User;
import com.linuxmastery.entity.UserProgress;
import com.linuxmastery.exception.ForbiddenException;
import com.linuxmastery.exception.ResourceNotFoundException;
import com.linuxmastery.repository.AssessmentAttemptRepository;
import com.linuxmastery.repository.AssessmentQuestionRepository;
import com.linuxmastery.repository.ModuleRepository;
import com.linuxmastery.repository.SectionCompletionRepository;
import com.linuxmastery.repository.UserRepository;
import com.linuxmastery.repository.UserProgressRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AssessmentService {

    private final AssessmentQuestionRepository assessmentQuestionRepository;
    private final AssessmentAttemptRepository assessmentAttemptRepository;
    private final ModuleRepository moduleRepository;
    private final SectionCompletionRepository sectionCompletionRepository;
    private final UserProgressRepository userProgressRepository;
    private final UserRepository userRepository;
    private final ObjectMapper objectMapper;

    public AssessmentService(AssessmentQuestionRepository assessmentQuestionRepository,
                             AssessmentAttemptRepository assessmentAttemptRepository,
                             ModuleRepository moduleRepository,
                             SectionCompletionRepository sectionCompletionRepository,
                             UserProgressRepository userProgressRepository,
                             UserRepository userRepository) {
        this.assessmentQuestionRepository = assessmentQuestionRepository;
        this.assessmentAttemptRepository = assessmentAttemptRepository;
        this.moduleRepository = moduleRepository;
        this.sectionCompletionRepository = sectionCompletionRepository;
        this.userProgressRepository = userProgressRepository;
        this.userRepository = userRepository;
        this.objectMapper = new ObjectMapper();
    }

    public List<AssessmentQuestionResponse> getAssessment(String moduleId, String userId) {
        Module module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new ResourceNotFoundException("Module not found"));

        long completedCount = sectionCompletionRepository.countByUserIdAndSection_Module_Id(userId, moduleId);
        int totalSections = module.getSections().size();

        if (totalSections == 0 || completedCount < totalSections) {
            throw new ForbiddenException("Complete all sections before taking the assessment");
        }

        List<AssessmentQuestion> allQuestions = assessmentQuestionRepository.findByModuleId(moduleId);
        if (allQuestions.size() < 10) {
            throw new IllegalStateException("Not enough assessment questions in the question bank for this module");
        }

        // Shuffle and pick 10
        List<AssessmentQuestion> pool = new ArrayList<>(allQuestions);
        Collections.shuffle(pool);
        List<AssessmentQuestion> selected = pool.subList(0, 10);

        return selected.stream().map(q -> {
            List<QuizOption> options = parseOptions(q.getOptionsJson());
            // Shuffle the options to make it dynamic
            List<QuizOption> shuffledOptions = new ArrayList<>(options);
            Collections.shuffle(shuffledOptions);
            return new AssessmentQuestionResponse(q.getId(), q.getQuestionText(), shuffledOptions);
        }).toList();
    }

    public AssessmentResultResponse submitAssessment(String moduleId, String userId,
                                                     List<AnswerSubmission> answers, int durationSecs) {
        Module module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new ResourceNotFoundException("Module not found"));

        List<AssessmentQuestion> moduleQuestions = assessmentQuestionRepository.findByModuleId(moduleId);
        List<QuestionFeedback> feedback = new ArrayList<>();
        int correctCount = 0;

        for (AnswerSubmission answer : answers) {
            AssessmentQuestion question = moduleQuestions.stream()
                    .filter(q -> q.getId().equals(answer.questionId()))
                    .findFirst()
                    .orElseThrow(() -> new ResourceNotFoundException("Question not found in this module's assessment pool"));

            boolean correct = question.getCorrectAnswer().equals(answer.selectedAnswer());
            if (correct) {
                correctCount++;
            }

            feedback.add(new QuestionFeedback(
                    question.getId(),
                    correct,
                    answer.selectedAnswer(),
                    question.getCorrectAnswer(),
                    question.getExplanation()
            ));
        }

        double score = (correctCount * 100.0) / 10.0;
        boolean passed = score >= 70.0;

        // Persist the attempt
        AssessmentAttempt attempt = new AssessmentAttempt();
        attempt.setUserId(userId);
        attempt.setModuleId(moduleId);
        try {
            attempt.setAnswersJson(objectMapper.writeValueAsString(answers));
        } catch (Exception e) {
            attempt.setAnswersJson("[]");
        }
        attempt.setScore(BigDecimal.valueOf(score));
        attempt.setPassed(passed);
        attempt.setDurationSecs(durationSecs);
        assessmentAttemptRepository.save(attempt);

        // Update progress
        UserProgress progress = userProgressRepository.findByUserIdAndModuleId(userId, moduleId)
                .orElseGet(() -> {
                    User user = userRepository.findById(userId)
                            .orElseThrow(() -> new ResourceNotFoundException("User not found"));
                    return UserProgress.builder()
                            .user(user)
                            .module(module)
                            .sectionsCompleted(0)
                            .totalSections(module.getSections().size())
                            .build();
                });

        if (passed) {
            progress.setAssessmentPassed(true);
        }

        BigDecimal currentBest = progress.getBestAssessmentScore();
        if (currentBest == null || BigDecimal.valueOf(score).compareTo(currentBest) > 0) {
            progress.setBestAssessmentScore(BigDecimal.valueOf(score));
        }

        // Check if module is now complete
        boolean allSectionsCompleted = progress.getSectionsCompleted() >= progress.getTotalSections();
        boolean assessmentPassed = progress.getAssessmentPassed() != null && progress.getAssessmentPassed();
        boolean projectSubmitted = progress.getBestProjectScore() != null;
        if (allSectionsCompleted && assessmentPassed && projectSubmitted) {
            progress.setModuleCompleted(true);
            progress.setModuleCompletedAt(LocalDateTime.now());
        }

        userProgressRepository.save(progress);

        return new AssessmentResultResponse(score, passed, feedback);
    }

    @Transactional(readOnly = true)
    public List<AssessmentAttempt> getAssessmentHistory(String moduleId, String userId) {
        return assessmentAttemptRepository.findByUserIdAndModuleIdOrderByCreatedAtDesc(userId, moduleId);
    }

    private List<QuizOption> parseOptions(String optionsJson) {
        try {
            return objectMapper.readValue(optionsJson, new TypeReference<List<QuizOption>>() {});
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
}
