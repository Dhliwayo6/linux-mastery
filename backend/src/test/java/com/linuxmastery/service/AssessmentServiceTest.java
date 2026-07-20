package com.linuxmastery.service;

import com.linuxmastery.dto.request.AnswerSubmission;
import com.linuxmastery.dto.response.AssessmentQuestionResponse;
import com.linuxmastery.dto.response.AssessmentResultResponse;
import com.linuxmastery.entity.AssessmentAttempt;
import com.linuxmastery.entity.AssessmentQuestion;
import com.linuxmastery.entity.Module;
import com.linuxmastery.entity.Section;
import com.linuxmastery.entity.User;
import com.linuxmastery.entity.UserProgress;
import com.linuxmastery.exception.ForbiddenException;
import com.linuxmastery.repository.AssessmentAttemptRepository;
import com.linuxmastery.repository.AssessmentQuestionRepository;
import com.linuxmastery.repository.ModuleRepository;
import com.linuxmastery.repository.SectionCompletionRepository;
import com.linuxmastery.repository.UserProgressRepository;
import com.linuxmastery.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AssessmentServiceTest {

    @Mock
    private AssessmentQuestionRepository assessmentQuestionRepository;
    @Mock
    private AssessmentAttemptRepository assessmentAttemptRepository;
    @Mock
    private ModuleRepository moduleRepository;
    @Mock
    private SectionCompletionRepository sectionCompletionRepository;
    @Mock
    private UserProgressRepository userProgressRepository;
    @Mock
    private UserRepository userRepository;

    private AssessmentService assessmentService;

    @BeforeEach
    void setUp() {
        assessmentService = new AssessmentService(
                assessmentQuestionRepository,
                assessmentAttemptRepository,
                moduleRepository,
                sectionCompletionRepository,
                userProgressRepository,
                userRepository
        );
    }

    @Test
    void getAssessment_LocksWhenSectionsIncomplete_ThrowsForbidden() {
        String userId = "user-123";
        String moduleId = "mod-1";

        Module module = Module.builder()
                .id(moduleId)
                .sections(List.of(new Section(), new Section())) // 2 sections
                .build();

        when(moduleRepository.findById(moduleId)).thenReturn(Optional.of(module));
        when(sectionCompletionRepository.countByUserIdAndSection_Module_Id(userId, moduleId)).thenReturn(1L); // only 1 complete

        assertThrows(ForbiddenException.class, () -> assessmentService.getAssessment(moduleId, userId));
    }

    @Test
    void getAssessment_Returns10ShuffledQuestions() {
        String userId = "user-123";
        String moduleId = "mod-1";

        Module module = Module.builder()
                .id(moduleId)
                .sections(List.of(new Section(), new Section()))
                .build();

        List<AssessmentQuestion> questions = new ArrayList<>();
        for (int i = 1; i <= 12; i++) {
            questions.add(AssessmentQuestion.builder()
                    .id("aq-" + i)
                    .questionText("Question " + i)
                    .optionsJson("[{\"id\":\"a\",\"text\":\"A\"},{\"id\":\"b\",\"text\":\"B\"}]")
                    .correctAnswer("a")
                    .explanation("Exp")
                    .build());
        }

        when(moduleRepository.findById(moduleId)).thenReturn(Optional.of(module));
        when(sectionCompletionRepository.countByUserIdAndSection_Module_Id(userId, moduleId)).thenReturn(2L); // 2 complete
        when(assessmentQuestionRepository.findByModuleId(moduleId)).thenReturn(questions);

        List<AssessmentQuestionResponse> result = assessmentService.getAssessment(moduleId, userId);

        assertEquals(10, result.size());
        // Verify they are from the pool
        assertTrue(result.stream().allMatch(q -> q.id().startsWith("aq-")));
    }

    @Test
    void submitAssessment_PassesAndUpdateProgress() {
        String userId = "user-123";
        String moduleId = "mod-1";

        Module module = Module.builder().id(moduleId).sections(List.of(new Section())).build();
        User user = User.builder().id(userId).build();

        List<AssessmentQuestion> questions = new ArrayList<>();
        List<AnswerSubmission> submissions = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            questions.add(AssessmentQuestion.builder()
                    .id("aq-" + i)
                    .correctAnswer("a")
                    .explanation("Exp")
                    .build());
            submissions.add(new AnswerSubmission("aq-" + i, i <= 8 ? "a" : "b")); // 8 correct, 2 incorrect -> 80%
        }

        when(moduleRepository.findById(moduleId)).thenReturn(Optional.of(module));
        when(assessmentQuestionRepository.findByModuleId(moduleId)).thenReturn(questions);

        UserProgress progress = UserProgress.builder()
                .user(user)
                .module(module)
                .sectionsCompleted(1)
                .totalSections(1)
                .assessmentPassed(false)
                .bestAssessmentScore(BigDecimal.ZERO)
                .bestProjectScore(BigDecimal.valueOf(100.0))
                .build();
        when(userProgressRepository.findByUserIdAndModuleId(userId, moduleId)).thenReturn(Optional.of(progress));

        AssessmentResultResponse response = assessmentService.submitAssessment(moduleId, userId, submissions, 120);

        assertEquals(80.0, response.score());
        assertTrue(response.passed());
        assertEquals(10, response.feedback().size());

        verify(assessmentAttemptRepository).save(any(AssessmentAttempt.class));
        verify(userProgressRepository).save(argThat(p ->
                p.getAssessmentPassed() &&
                p.getBestAssessmentScore().compareTo(BigDecimal.valueOf(80.0)) == 0 &&
                p.getModuleCompleted() // fully completed because sections are complete too
        ));
    }

    @Test
    void submitAssessment_FailsAndDoesNotUpdatePassed() {
        String userId = "user-123";
        String moduleId = "mod-1";

        Module module = Module.builder().id(moduleId).sections(List.of(new Section())).build();
        User user = User.builder().id(userId).build();

        List<AssessmentQuestion> questions = new ArrayList<>();
        List<AnswerSubmission> submissions = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            questions.add(AssessmentQuestion.builder()
                    .id("aq-" + i)
                    .correctAnswer("a")
                    .explanation("Exp")
                    .build());
            submissions.add(new AnswerSubmission("aq-" + i, i <= 5 ? "a" : "b")); // 5 correct -> 50%
        }

        when(moduleRepository.findById(moduleId)).thenReturn(Optional.of(module));
        when(assessmentQuestionRepository.findByModuleId(moduleId)).thenReturn(questions);

        UserProgress progress = UserProgress.builder()
                .user(user)
                .module(module)
                .sectionsCompleted(1)
                .totalSections(1)
                .assessmentPassed(false)
                .bestAssessmentScore(BigDecimal.ZERO)
                .build();
        when(userProgressRepository.findByUserIdAndModuleId(userId, moduleId)).thenReturn(Optional.of(progress));

        AssessmentResultResponse response = assessmentService.submitAssessment(moduleId, userId, submissions, 120);

        assertEquals(50.0, response.score());
        assertFalse(response.passed());

        verify(assessmentAttemptRepository).save(any(AssessmentAttempt.class));
        verify(userProgressRepository).save(argThat(p ->
                !p.getAssessmentPassed() &&
                p.getBestAssessmentScore().compareTo(BigDecimal.valueOf(50.0)) == 0 &&
                !p.getModuleCompleted()
        ));
    }
}
