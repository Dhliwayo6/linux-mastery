package com.linuxmastery.service;

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
class ProjectServiceTest {

    @Mock
    private ProjectRepository projectRepository;
    @Mock
    private ProjectSubmissionRepository projectSubmissionRepository;
    @Mock
    private UserProgressRepository userProgressRepository;
    @Mock
    private UserRepository userRepository;
    @Mock
    private ModuleRepository moduleRepository;
    @Mock
    private ScriptRunner scriptRunner;
    @Mock
    private TestCaseEvaluator testCaseEvaluator;
    @Mock
    private MemoGenerator memoGenerator;

    private ProjectService projectService;

    @BeforeEach
    void setUp() {
        projectService = new ProjectService(
                projectRepository,
                projectSubmissionRepository,
                userProgressRepository,
                userRepository,
                moduleRepository,
                scriptRunner,
                testCaseEvaluator,
                memoGenerator
        );
    }

    @Test
    void getProjectBrief_Success() {
        String moduleId = "mod-1";
        Project project = new Project();
        project.setId("proj-1");
        project.setTitle("sysinfo.sh");
        project.setBriefMd("Brief content");

        when(projectRepository.findByModuleId(moduleId)).thenReturn(Optional.of(project));

        ProjectResponse response = projectService.getProjectBrief(moduleId);

        assertEquals("proj-1", response.id());
        assertEquals("sysinfo.sh", response.title());
        assertEquals("Brief content", response.briefMd());
    }

    @Test
    void getProjectBrief_NotFound_ThrowsResourceNotFoundException() {
        String moduleId = "mod-1";
        when(projectRepository.findByModuleId(moduleId)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class, () -> projectService.getProjectBrief(moduleId));
    }

    @Test
    void submitProject_EmptyScript_ThrowsIllegalArgumentException() {
        String moduleId = "mod-1";
        String userId = "user-123";
        Project project = new Project();
        project.setId("proj-1");

        when(projectRepository.findByModuleId(moduleId)).thenReturn(Optional.of(project));
        when(projectSubmissionRepository.countByUserIdAndProjectId(userId, "proj-1")).thenReturn(0L);

        assertThrows(IllegalArgumentException.class, () -> projectService.submitProject(moduleId, userId, ""));
    }

    @Test
    void submitProject_NoShebang_ThrowsIllegalArgumentException() {
        String moduleId = "mod-1";
        String userId = "user-123";
        Project project = new Project();
        project.setId("proj-1");

        when(projectRepository.findByModuleId(moduleId)).thenReturn(Optional.of(project));
        when(projectSubmissionRepository.countByUserIdAndProjectId(userId, "proj-1")).thenReturn(0L);

        assertThrows(IllegalArgumentException.class, () -> projectService.submitProject(moduleId, userId, "echo 'hello'"));
    }

    @Test
    void submitProject_TooManyAttempts_ThrowsTooManyAttemptsException() {
        String moduleId = "mod-1";
        String userId = "user-123";
        Project project = new Project();
        project.setId("proj-1");

        when(projectRepository.findByModuleId(moduleId)).thenReturn(Optional.of(project));
        when(projectSubmissionRepository.countByUserIdAndProjectId(userId, "proj-1")).thenReturn(3L);

        assertThrows(TooManyAttemptsException.class, () -> projectService.submitProject(moduleId, userId, "#!/bin/bash"));
    }

    @Test
    void submitProject_GradesSuccessfullyAndUpdatesProgress() {
        String moduleId = "mod-1";
        String userId = "user-123";
        String script = "#!/bin/bash\necho Hostname";

        Project project = new Project();
        project.setId("proj-1");
        project.setTitle("sysinfo.sh");

        ProjectTestCase tc1 = new ProjectTestCase();
        tc1.setId("ptc-1");
        tc1.setDescription("Exits with 0");
        tc1.setWeight(2);
        project.getTestCases().add(tc1);

        Module module = Module.builder().id(moduleId).sections(new ArrayList<>()).build();
        User user = User.builder().id(userId).build();

        when(projectRepository.findByModuleId(moduleId)).thenReturn(Optional.of(project));
        when(projectSubmissionRepository.countByUserIdAndProjectId(userId, "proj-1")).thenReturn(0L);
        
        RunResult runResult = new RunResult("Hostname", "", 0, false);
        when(scriptRunner.run(script)).thenReturn(runResult);

        TestCaseResult tcResult = new TestCaseResult("ptc-1", "Exits with 0", 2, true, "0", "0");
        when(testCaseEvaluator.evaluate(eq(tc1), eq(runResult), eq(script))).thenReturn(tcResult);
        when(testCaseEvaluator.calculateScore(any())).thenReturn(100);
        when(memoGenerator.generate(eq("sysinfo.sh"), eq(100), any(), eq(runResult))).thenReturn("Memo content");

        when(moduleRepository.findById(moduleId)).thenReturn(Optional.of(module));

        UserProgress progress = UserProgress.builder()
                .user(user)
                .module(module)
                .sectionsCompleted(0)
                .totalSections(0)
                .assessmentPassed(true)
                .bestProjectScore(null)
                .build();
        when(userProgressRepository.findByUserIdAndModuleId(userId, moduleId)).thenReturn(Optional.of(progress));

        ProjectSubmissionResponse response = projectService.submitProject(moduleId, userId, script);

        assertEquals(100, response.score());
        assertEquals(1, response.attemptNumber());
        assertEquals("Memo content", response.memoMd());

        verify(projectSubmissionRepository).save(any(ProjectSubmission.class));
        verify(userProgressRepository).save(argThat(p ->
                p.getBestProjectScore().compareTo(BigDecimal.valueOf(100)) == 0 &&
                p.getModuleCompleted() // complete because assessmentPassed is true and sectionsCompleted >= totalSections
        ));
    }
}
