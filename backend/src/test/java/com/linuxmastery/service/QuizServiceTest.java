package com.linuxmastery.service;

import com.linuxmastery.dto.request.AnswerSubmission;
import com.linuxmastery.dto.response.QuizResultResponse;
import com.linuxmastery.entity.Module;
import com.linuxmastery.entity.QuestionType;
import com.linuxmastery.entity.QuizAttempt;
import com.linuxmastery.entity.QuizQuestion;
import com.linuxmastery.entity.Section;
import com.linuxmastery.repository.QuizAttemptRepository;
import com.linuxmastery.repository.QuizQuestionRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class QuizServiceTest {

    @Mock
    private QuizQuestionRepository quizQuestionRepository;
    @Mock
    private QuizAttemptRepository quizAttemptRepository;
    @Mock
    private CurriculumService curriculumService;

    private QuizService quizService;

    @BeforeEach
    void setUp() {
        quizService = new QuizService(
                quizQuestionRepository,
                quizAttemptRepository,
                curriculumService
        );
    }

    @Test
    void submitSectionQuiz_AllCorrect_Scores100AndPasses() {
        String userId = "user-123";
        String sectionId = "sec-1-1";

        Module module = Module.builder().id("mod-1").build();
        Section section = Section.builder().id(sectionId).module(module).build();

        QuizQuestion q1 = QuizQuestion.builder()
                .id("q-1")
                .section(section)
                .questionType(QuestionType.MULTIPLE_CHOICE)
                .correctAnswer("a")
                .explanation("Exp 1")
                .build();
        QuizQuestion q2 = QuizQuestion.builder()
                .id("q-2")
                .section(section)
                .questionType(QuestionType.TRUE_FALSE)
                .correctAnswer("true")
                .explanation("Exp 2")
                .build();

        when(quizQuestionRepository.findBySectionIdOrderByOrderIndexAsc(sectionId))
                .thenReturn(List.of(q1, q2));

        List<AnswerSubmission> answers = List.of(
                new AnswerSubmission("q-1", "a"),
                new AnswerSubmission("q-2", "true")
        );

        QuizResultResponse response = quizService.submitSectionQuiz(sectionId, userId, answers);

        assertEquals(100.0, response.score());
        assertTrue(response.passed());
        assertEquals(2, response.feedback().size());
        assertTrue(response.feedback().get(0).correct());
        assertTrue(response.feedback().get(1).correct());

        verify(quizAttemptRepository).save(any(QuizAttempt.class));
        verify(curriculumService).completeSection("mod-1", sectionId, userId);
    }

    @Test
    void submitSectionQuiz_AllWrong_Scores0AndFails() {
        String userId = "user-123";
        String sectionId = "sec-1-1";

        Module module = Module.builder().id("mod-1").build();
        Section section = Section.builder().id(sectionId).module(module).build();

        QuizQuestion q1 = QuizQuestion.builder()
                .id("q-1")
                .section(section)
                .questionType(QuestionType.MULTIPLE_CHOICE)
                .correctAnswer("a")
                .explanation("Exp 1")
                .build();

        when(quizQuestionRepository.findBySectionIdOrderByOrderIndexAsc(sectionId))
                .thenReturn(List.of(q1));

        List<AnswerSubmission> answers = List.of(
                new AnswerSubmission("q-1", "b") // wrong
        );

        QuizResultResponse response = quizService.submitSectionQuiz(sectionId, userId, answers);

        assertEquals(0.0, response.score());
        assertFalse(response.passed());
        assertEquals(1, response.feedback().size());
        assertFalse(response.feedback().get(0).correct());

        verify(quizAttemptRepository).save(any(QuizAttempt.class));
        verify(curriculumService, never()).completeSection(anyString(), anyString(), anyString());
    }

    @Test
    void submitSectionQuiz_FillInBlank_CaseInsensitiveAndTrimmed() {
        String userId = "user-123";
        String sectionId = "sec-1-1";

        Module module = Module.builder().id("mod-1").build();
        Section section = Section.builder().id(sectionId).module(module).build();

        QuizQuestion q1 = QuizQuestion.builder()
                .id("q-1")
                .section(section)
                .questionType(QuestionType.FILL_IN_BLANK)
                .correctAnswer("  ls -la  ")
                .explanation("Exp 1")
                .build();

        when(quizQuestionRepository.findBySectionIdOrderByOrderIndexAsc(sectionId))
                .thenReturn(List.of(q1));

        List<AnswerSubmission> answers = List.of(
                new AnswerSubmission("q-1", "LS -LA") // case-insensitive, needs trim
        );

        QuizResultResponse response = quizService.submitSectionQuiz(sectionId, userId, answers);

        assertEquals(100.0, response.score());
        assertTrue(response.passed());
        assertTrue(response.feedback().get(0).correct());

        verify(quizAttemptRepository).save(any(QuizAttempt.class));
        verify(curriculumService).completeSection("mod-1", sectionId, userId);
    }

    @Test
    void submitSectionQuiz_SqlInjectionAttempt_TreatedAsLiteralAndIncorrect() {
        String userId = "user-123";
        String sectionId = "sec-1-1";

        Module module = Module.builder().id("mod-1").build();
        Section section = Section.builder().id(sectionId).module(module).build();

        QuizQuestion q1 = QuizQuestion.builder()
                .id("q-1")
                .section(section)
                .questionType(QuestionType.MULTIPLE_CHOICE)
                .correctAnswer("a")
                .explanation("Exp 1")
                .build();

        when(quizQuestionRepository.findBySectionIdOrderByOrderIndexAsc(sectionId))
                .thenReturn(List.of(q1));

        // Submit SQL injection string
        List<AnswerSubmission> answers = List.of(
                new AnswerSubmission("q-1", "' OR '1'='1")
        );

        QuizResultResponse response = quizService.submitSectionQuiz(sectionId, userId, answers);

        assertEquals(0.0, response.score());
        assertFalse(response.passed());
        assertEquals(1, response.feedback().size());
        assertFalse(response.feedback().get(0).correct());
        assertEquals("a", response.feedback().get(0).correctAnswer());
        
        verify(quizAttemptRepository).save(any(QuizAttempt.class));
        verify(curriculumService, never()).completeSection(anyString(), anyString(), anyString());
    }
}
