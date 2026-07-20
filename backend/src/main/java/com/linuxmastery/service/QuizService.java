package com.linuxmastery.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.linuxmastery.dto.request.AnswerSubmission;
import com.linuxmastery.dto.response.QuestionFeedback;
import com.linuxmastery.dto.response.QuizResultResponse;
import com.linuxmastery.entity.QuestionType;
import com.linuxmastery.entity.QuizAttempt;
import com.linuxmastery.entity.QuizQuestion;
import com.linuxmastery.exception.ResourceNotFoundException;
import com.linuxmastery.repository.QuizAttemptRepository;
import com.linuxmastery.repository.QuizQuestionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class QuizService {

    private final QuizQuestionRepository quizQuestionRepository;
    private final QuizAttemptRepository quizAttemptRepository;
    private final CurriculumService curriculumService;
    private final ObjectMapper objectMapper;

    public QuizService(QuizQuestionRepository quizQuestionRepository,
                       QuizAttemptRepository quizAttemptRepository,
                       CurriculumService curriculumService) {
        this.quizQuestionRepository = quizQuestionRepository;
        this.quizAttemptRepository = quizAttemptRepository;
        this.curriculumService = curriculumService;
        this.objectMapper = new ObjectMapper();
    }

    public QuizResultResponse submitSectionQuiz(String sectionId, String userId, List<AnswerSubmission> answers) {
        List<QuizQuestion> questions = quizQuestionRepository.findBySectionIdOrderByOrderIndexAsc(sectionId);
        if (questions.isEmpty()) {
            throw new ResourceNotFoundException("No quiz questions found for this section");
        }

        List<QuestionFeedback> feedback = new ArrayList<>();
        int correctCount = 0;

        for (AnswerSubmission answer : answers) {
            QuizQuestion question = questions.stream()
                    .filter(q -> q.getId().equals(answer.questionId()))
                    .findFirst()
                    .orElseThrow(() -> new ResourceNotFoundException("Question not found in this section's quiz"));

            boolean correct;
            if (question.getQuestionType() == QuestionType.FILL_IN_BLANK) {
                correct = question.getCorrectAnswer().trim().equalsIgnoreCase(answer.selectedAnswer().trim());
            } else {
                correct = question.getCorrectAnswer().equals(answer.selectedAnswer());
            }

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

        double score = (correctCount * 100.0) / questions.size();
        boolean passed = score >= 60.0;

        // Persist the attempt
        QuizAttempt attempt = new QuizAttempt();
        attempt.setUserId(userId);
        attempt.setSectionId(sectionId);
        try {
            attempt.setAnswersJson(objectMapper.writeValueAsString(answers));
        } catch (Exception e) {
            attempt.setAnswersJson("[]");
        }
        attempt.setScore(BigDecimal.valueOf(score));
        attempt.setPassed(passed);
        quizAttemptRepository.save(attempt);

        if (passed) {
            // Note: Section completion updates UserProgress. We need parent module ID.
            // Let's get the module ID from the first question.
            String moduleId = questions.get(0).getSection().getModule().getId();
            curriculumService.completeSection(moduleId, sectionId, userId);
        }

        return new QuizResultResponse(score, passed, feedback);
    }

    @Transactional(readOnly = true)
    public List<QuizAttempt> getQuizHistory(String sectionId, String userId) {
        return quizAttemptRepository.findByUserIdAndSectionIdOrderByCreatedAtDesc(userId, sectionId);
    }
}
