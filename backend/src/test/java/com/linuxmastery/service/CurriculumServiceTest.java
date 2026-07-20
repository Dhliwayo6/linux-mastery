package com.linuxmastery.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.linuxmastery.dto.response.*;
import com.linuxmastery.entity.*;
import com.linuxmastery.entity.Module;
import com.linuxmastery.exception.ForbiddenException;
import com.linuxmastery.exception.ResourceNotFoundException;
import com.linuxmastery.repository.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CurriculumServiceTest {

    @Mock
    private ModuleRepository moduleRepository;
    @Mock
    private SectionRepository sectionRepository;
    @Mock
    private UserRepository userRepository;
    @Mock
    private SectionCompletionRepository sectionCompletionRepository;
    @Mock
    private UserProgressRepository userProgressRepository;

    private CurriculumService curriculumService;

    @BeforeEach
    void setUp() {
        curriculumService = new CurriculumService(
                moduleRepository,
                sectionRepository,
                userRepository,
                sectionCompletionRepository,
                userProgressRepository
        );
    }

    @Test
    void getModulesWithProgress_LocksAndUnlocksCorrectly() {
        String userId = "user-123";

        // Setup Module 1
        Module mod1 = Module.builder()
                .id("mod-1")
                .slug("slug-1")
                .title("Module 1")
                .description("Desc 1")
                .level("Beginner")
                .orderIndex(1)
                .build();
        Section sec1_1 = Section.builder().id("sec-1-1").module(mod1).orderIndex(1).title("Sec 1.1").build();
        Section sec1_2 = Section.builder().id("sec-1-2").module(mod1).orderIndex(2).title("Sec 1.2").build();
        mod1.setSections(List.of(sec1_1, sec1_2));

        // Setup Module 2
        Module mod2 = Module.builder()
                .id("mod-2")
                .slug("slug-2")
                .title("Module 2")
                .description("Desc 2")
                .level("Intermediate")
                .orderIndex(2)
                .build();
        Section sec2_1 = Section.builder().id("sec-2-1").module(mod2).orderIndex(1).title("Sec 2.1").build();
        mod2.setSections(List.of(sec2_1));

        List<Module> modules = List.of(mod1, mod2);
        when(moduleRepository.findAllByOrderByOrderIndexAsc()).thenReturn(modules);

        // Scenario 1: New user (no progress)
        when(userProgressRepository.findByUserIdAndModuleId(userId, "mod-1")).thenReturn(Optional.empty());
        when(userProgressRepository.findByUserIdAndModuleId(userId, "mod-2")).thenReturn(Optional.empty());
        when(sectionCompletionRepository.findByUserIdAndSectionId(userId, "sec-1-1")).thenReturn(Optional.empty());
        when(sectionCompletionRepository.findByUserIdAndSectionId(userId, "sec-1-2")).thenReturn(Optional.empty());
        when(sectionCompletionRepository.findByUserIdAndSectionId(userId, "sec-2-1")).thenReturn(Optional.empty());

        List<ModuleResponse> responses = curriculumService.getModulesWithProgress(userId);

        assertEquals(2, responses.size());
        
        // Module 1 is unlocked because orderIndex = 1
        assertTrue(responses.get(0).unlocked());
        // Section 1.1 is unlocked because it's first section in unlocked module
        assertTrue(responses.get(0).sections().get(0).unlocked());
        // Section 1.2 is locked because Section 1.1 is not completed
        assertFalse(responses.get(0).sections().get(1).unlocked());

        // Module 2 is locked because Module 1 is not completed
        assertFalse(responses.get(1).unlocked());
        // Section 2.1 is locked because Module 2 is locked
        assertFalse(responses.get(1).sections().get(0).unlocked());

        // Scenario 2: Module 1 is completed
        UserProgress up1 = UserProgress.builder()
                .moduleCompleted(true)
                .sectionsCompleted(2)
                .build();
        when(userProgressRepository.findByUserIdAndModuleId(userId, "mod-1")).thenReturn(Optional.of(up1));
        when(sectionCompletionRepository.findByUserIdAndSectionId(userId, "sec-1-1")).thenReturn(Optional.of(mock(SectionCompletion.class)));
        when(sectionCompletionRepository.findByUserIdAndSectionId(userId, "sec-1-2")).thenReturn(Optional.of(mock(SectionCompletion.class)));

        responses = curriculumService.getModulesWithProgress(userId);

        assertTrue(responses.get(0).unlocked());
        assertTrue(responses.get(0).sections().get(0).unlocked());
        assertTrue(responses.get(0).sections().get(1).unlocked());

        // Module 2 is unlocked now because Module 1 was completed
        assertTrue(responses.get(1).unlocked());
        assertTrue(responses.get(1).sections().get(0).unlocked());
    }

    @Test
    void getSectionDetails_Success_FiltersAnswers() {
        String userId = "user-123";

        Module mod1 = Module.builder().id("mod-1").orderIndex(1).build();
        QuizQuestion question = QuizQuestion.builder()
                .id("q-1")
                .questionText("Question 1?")
                .questionType(QuestionType.MULTIPLE_CHOICE)
                .optionsJson("[{\"id\":\"a\",\"text\":\"Option A\"},{\"id\":\"b\",\"text\":\"Option B\"}]")
                .correctAnswer("a")
                .explanation("Correct is A")
                .orderIndex(1)
                .build();

        Section sec1_1 = Section.builder()
                .id("sec-1-1")
                .module(mod1)
                .orderIndex(1)
                .title("Sec 1.1")
                .contentMd("Markdown content")
                .quizQuestions(List.of(question))
                .build();
        mod1.setSections(List.of(sec1_1));

        when(sectionRepository.findById("sec-1-1")).thenReturn(Optional.of(sec1_1));
        when(moduleRepository.findAllByOrderByOrderIndexAsc()).thenReturn(List.of(mod1));

        SectionResponse response = curriculumService.getSectionDetails("mod-1", "sec-1-1", userId);

        assertEquals("sec-1-1", response.id());
        assertEquals("Markdown content", response.contentMd());
        assertEquals(1, response.quizQuestions().size());

        QuizQuestionResponse qResp = response.quizQuestions().get(0);
        assertEquals("q-1", qResp.id());
        assertEquals("Question 1?", qResp.questionText());
        assertEquals(2, qResp.options().size());
        assertEquals("a", qResp.options().get(0).id());
        assertEquals("Option A", qResp.options().get(0).text());
        // Verify correct answer/explanation are NOT in the response DTO
        // Since the record fields are only (id, questionText, questionType, options, orderIndex),
        // there is no way correct answer/explanation leaks.
    }

    @Test
    void getSectionDetails_Locked_ThrowsForbidden() {
        String userId = "user-123";

        Module mod1 = Module.builder().id("mod-1").orderIndex(1).build();
        Section sec1_1 = Section.builder().id("sec-1-1").module(mod1).orderIndex(1).title("Sec 1.1").build();
        Section sec1_2 = Section.builder().id("sec-1-2").module(mod1).orderIndex(2).title("Sec 1.2").build();
        mod1.setSections(List.of(sec1_1, sec1_2));

        when(sectionRepository.findById("sec-1-2")).thenReturn(Optional.of(sec1_2));
        when(moduleRepository.findAllByOrderByOrderIndexAsc()).thenReturn(List.of(mod1));
        when(sectionCompletionRepository.findByUserIdAndSectionId(userId, "sec-1-1")).thenReturn(Optional.empty());

        assertThrows(ForbiddenException.class, () -> 
                curriculumService.getSectionDetails("mod-1", "sec-1-2", userId));
    }

    @Test
    void completeSection_Success_SavesProgress() {
        String userId = "user-123";
        User user = User.builder().id(userId).email("test@test.com").build();

        Module mod1 = Module.builder().id("mod-1").orderIndex(1).build();
        Section sec1_1 = Section.builder().id("sec-1-1").module(mod1).orderIndex(1).title("Sec 1.1").build();
        mod1.setSections(List.of(sec1_1));

        when(sectionRepository.findById("sec-1-1")).thenReturn(Optional.of(sec1_1));
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        when(moduleRepository.findAllByOrderByOrderIndexAsc()).thenReturn(List.of(mod1));
        when(sectionCompletionRepository.findByUserIdAndSectionId(userId, "sec-1-1")).thenReturn(Optional.empty());
        when(sectionCompletionRepository.countByUserIdAndSection_Module_Id(userId, "mod-1")).thenReturn(1L);
        when(userProgressRepository.findByUserIdAndModuleId(userId, "mod-1")).thenReturn(Optional.empty());

        curriculumService.completeSection("mod-1", "sec-1-1", userId);

        verify(sectionCompletionRepository).save(any(SectionCompletion.class));
        verify(userProgressRepository).save(argThat(progress -> 
                progress.getSectionsCompleted() == 1 &&
                progress.getTotalSections() == 1 &&
                !progress.getModuleCompleted() // must not be marked complete yet
        ));
    }
}
