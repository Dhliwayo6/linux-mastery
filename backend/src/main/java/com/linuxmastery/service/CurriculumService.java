package com.linuxmastery.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.linuxmastery.dto.response.*;
import com.linuxmastery.entity.*;
import com.linuxmastery.entity.Module;
import com.linuxmastery.exception.ForbiddenException;
import com.linuxmastery.exception.ResourceNotFoundException;
import com.linuxmastery.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CurriculumService {

    private final ModuleRepository moduleRepository;
    private final SectionRepository sectionRepository;
    private final UserRepository userRepository;
    private final SectionCompletionRepository sectionCompletionRepository;
    private final UserProgressRepository userProgressRepository;
    private final ObjectMapper objectMapper;

    public CurriculumService(ModuleRepository moduleRepository,
                             SectionRepository sectionRepository,
                             UserRepository userRepository,
                             SectionCompletionRepository sectionCompletionRepository,
                             UserProgressRepository userProgressRepository) {
        this.moduleRepository = moduleRepository;
        this.sectionRepository = sectionRepository;
        this.userRepository = userRepository;
        this.sectionCompletionRepository = sectionCompletionRepository;
        this.userProgressRepository = userProgressRepository;
        this.objectMapper = new ObjectMapper();
    }

    public List<ModuleResponse> getModulesWithProgress(String userId) {
        List<Module> allModules = moduleRepository.findAllByOrderByOrderIndexAsc();
        List<ModuleResponse> responses = new ArrayList<>();

        boolean previousModuleCompleted = true; // First module is always unlocked

        for (Module module : allModules) {
            // Module is unlocked if orderIndex == 1 OR previous module was completed
            boolean unlocked = (module.getOrderIndex() == 1) || previousModuleCompleted;

            Optional<UserProgress> progressOpt = userProgressRepository.findByUserIdAndModuleId(userId, module.getId());
            int sectionsCompleted = progressOpt.map(UserProgress::getSectionsCompleted).orElse(0);
            boolean completed = progressOpt.map(UserProgress::getModuleCompleted).orElse(false);

            // Populate sections summary
            List<SectionSummaryResponse> sectionsList = new ArrayList<>();
            List<Section> sections = module.getSections();
            boolean previousSectionCompleted = true; // First section is unlocked if module is unlocked

            for (Section section : sections) {
                boolean sectionCompleted = sectionCompletionRepository.findByUserIdAndSectionId(userId, section.getId()).isPresent();
                boolean sectionUnlocked = unlocked && (section.getOrderIndex() == 1 || previousSectionCompleted);

                sectionsList.add(new SectionSummaryResponse(
                        section.getId(),
                        section.getTitle(),
                        section.getOrderIndex(),
                        sectionUnlocked,
                        sectionCompleted
                ));

                previousSectionCompleted = sectionCompleted;
            }

            responses.add(new ModuleResponse(
                    module.getId(),
                    module.getSlug(),
                    module.getTitle(),
                    module.getDescription(),
                    module.getLevel(),
                    module.getOrderIndex(),
                    unlocked,
                    sectionsCompleted,
                    sections.size(),
                    completed,
                    sectionsList
            ));

            // For the next iteration, previousModuleCompleted is this module's completed status
            previousModuleCompleted = completed;
        }

        return responses;
    }

    public ModuleResponse getModuleWithProgress(String moduleId, String userId) {
        List<ModuleResponse> allModules = getModulesWithProgress(userId);
        return allModules.stream()
                .filter(m -> m.id().equals(moduleId))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Module not found"));
    }

    public SectionResponse getSectionDetails(String moduleId, String sectionId, String userId) {
        Section section = sectionRepository.findById(sectionId)
                .orElseThrow(() -> new ResourceNotFoundException("Section not found"));

        if (!section.getModule().getId().equals(moduleId)) {
            throw new IllegalArgumentException("Section does not belong to the specified module");
        }

        List<ModuleResponse> modules = getModulesWithProgress(userId);
        ModuleResponse parentModule = modules.stream()
                .filter(m -> m.id().equals(moduleId))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Module not found"));

        SectionSummaryResponse sectionSummary = parentModule.sections().stream()
                .filter(s -> s.id().equals(sectionId))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Section not found"));

        if (!sectionSummary.unlocked()) {
            throw new ForbiddenException("Section is locked");
        }

        List<QuizQuestionResponse> quizResponses = section.getQuizQuestions().stream()
                .map(q -> {
                    List<QuizOption> options = List.of();
                    try {
                        options = objectMapper.readValue(q.getOptionsJson(), new com.fasterxml.jackson.core.type.TypeReference<List<QuizOption>>() {});
                    } catch (Exception ignored) {
                    }
                    return new QuizQuestionResponse(
                            q.getId(),
                            q.getQuestionText(),
                            q.getQuestionType(),
                            options,
                            q.getOrderIndex()
                    );
                })
                .toList();

        return new SectionResponse(
                section.getId(),
                moduleId,
                section.getTitle(),
                section.getContentMd(),
                section.getOrderIndex(),
                sectionSummary.unlocked(),
                sectionSummary.completed(),
                quizResponses
        );
    }

    public void completeSection(String moduleId, String sectionId, String userId) {
        Section section = sectionRepository.findById(sectionId)
                .orElseThrow(() -> new ResourceNotFoundException("Section not found"));

        if (!section.getModule().getId().equals(moduleId)) {
            throw new IllegalArgumentException("Section does not belong to the specified module");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        List<ModuleResponse> modules = getModulesWithProgress(userId);
        ModuleResponse parentModule = modules.stream()
                .filter(m -> m.id().equals(moduleId))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Module not found"));

        SectionSummaryResponse sectionSummary = parentModule.sections().stream()
                .filter(s -> s.id().equals(sectionId))
                .findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Section not found"));

        if (!sectionSummary.unlocked()) {
            throw new ForbiddenException("Section is locked");
        }

        Optional<SectionCompletion> existingCompletion = sectionCompletionRepository.findByUserIdAndSectionId(userId, sectionId);
        if (existingCompletion.isEmpty()) {
            SectionCompletion completion = SectionCompletion.builder()
                    .user(user)
                    .section(section)
                    .build();
            sectionCompletionRepository.save(completion);
        }

        long completedCount = sectionCompletionRepository.countByUserIdAndSection_Module_Id(userId, moduleId);
        int totalSections = section.getModule().getSections().size();

        UserProgress progress = userProgressRepository.findByUserIdAndModuleId(userId, moduleId)
                .orElseGet(() -> UserProgress.builder()
                        .user(user)
                        .module(section.getModule())
                        .build());

        progress.setSectionsCompleted((int) completedCount);
        progress.setTotalSections(totalSections);

        userProgressRepository.save(progress);
    }

    public List<UserProgressResponse> getUserProgressList(String userId) {
        List<Module> allModules = moduleRepository.findAllByOrderByOrderIndexAsc();
        List<UserProgressResponse> responses = new ArrayList<>();

        for (Module module : allModules) {
            Optional<UserProgress> progressOpt = userProgressRepository.findByUserIdAndModuleId(userId, module.getId());
            if (progressOpt.isPresent()) {
                UserProgress progress = progressOpt.get();
                responses.add(new UserProgressResponse(
                        progress.getId(),
                        module.getId(),
                        module.getTitle(),
                        module.getSlug(),
                        progress.getSectionsCompleted(),
                        progress.getTotalSections() != null ? progress.getTotalSections() : module.getSections().size(),
                        progress.getBestAssessmentScore(),
                        progress.getAssessmentPassed(),
                        progress.getBestProjectScore(),
                        progress.getModuleCompleted(),
                        progress.getModuleCompletedAt()
                ));
            } else {
                responses.add(new UserProgressResponse(
                        null,
                        module.getId(),
                        module.getTitle(),
                        module.getSlug(),
                        0,
                        module.getSections().size(),
                        null,
                        false,
                        null,
                        false,
                        null
                ));
            }
        }
        return responses;
    }
}
