package com.linuxmastery.controller;

import com.linuxmastery.dto.request.AdminQuestionRequest;
import com.linuxmastery.dto.response.AdminUserResponse;
import com.linuxmastery.dto.response.AdminQuestionResponse;
import com.linuxmastery.dto.response.ApiResponse;
import com.linuxmastery.entity.AssessmentQuestion;
import com.linuxmastery.entity.Module;
import com.linuxmastery.entity.User;
import com.linuxmastery.entity.UserProgress;
import com.linuxmastery.exception.ResourceNotFoundException;
import com.linuxmastery.repository.AssessmentQuestionRepository;
import com.linuxmastery.repository.ModuleRepository;
import com.linuxmastery.repository.UserProgressRepository;
import com.linuxmastery.repository.UserRepository;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/admin")
@Transactional
public class AdminController {

    private final UserRepository userRepository;
    private final UserProgressRepository userProgressRepository;
    private final AssessmentQuestionRepository assessmentQuestionRepository;
    private final ModuleRepository moduleRepository;
    private final com.fasterxml.jackson.databind.ObjectMapper objectMapper = new com.fasterxml.jackson.databind.ObjectMapper();

    public AdminController(UserRepository userRepository,
                           UserProgressRepository userProgressRepository,
                           AssessmentQuestionRepository assessmentQuestionRepository,
                           ModuleRepository moduleRepository) {
        this.userRepository = userRepository;
        this.userProgressRepository = userProgressRepository;
        this.assessmentQuestionRepository = assessmentQuestionRepository;
        this.moduleRepository = moduleRepository;
    }

    @GetMapping("/users")
    public ResponseEntity<ApiResponse<List<AdminUserResponse>>> getUsers() {
        List<User> users = userRepository.findAll();
        List<AdminUserResponse> responses = new ArrayList<>();
        for (User user : users) {
            long completedModules = userProgressRepository.findByUserId(user.getId())
                    .stream()
                    .filter(UserProgress::getModuleCompleted)
                    .count();
            responses.add(new AdminUserResponse(
                    user.getId(),
                    user.getDisplayName(),
                    user.getEmail(),
                    user.getRole(),
                    completedModules
            ));
        }
        return ResponseEntity.ok(new ApiResponse<>(true, responses, null));
    }

    @GetMapping("/questions")
    public ResponseEntity<ApiResponse<List<AdminQuestionResponse>>> getQuestions(@RequestParam String moduleId) {
        List<AssessmentQuestion> questions = assessmentQuestionRepository.findByModuleId(moduleId);
        List<AdminQuestionResponse> responses = questions.stream()
                .map(q -> new AdminQuestionResponse(
                        q.getId(),
                        q.getModule().getId(),
                        q.getQuestionText(),
                        q.getOptionsJson(),
                        q.getCorrectAnswer(),
                        q.getExplanation()
                ))
                .toList();
        return ResponseEntity.ok(new ApiResponse<>(true, responses, null));
    }

    @PostMapping("/questions")
    public ResponseEntity<ApiResponse<AdminQuestionResponse>> createQuestion(@Valid @RequestBody AdminQuestionRequest request) {
        Module module = moduleRepository.findById(request.moduleId())
                .orElseThrow(() -> new ResourceNotFoundException("Module not found"));

        String optionsJson;
        try {
            optionsJson = objectMapper.writeValueAsString(request.options());
        } catch (com.fasterxml.jackson.core.JsonProcessingException e) {
            throw new IllegalArgumentException("Invalid options format", e);
        }

        AssessmentQuestion question = AssessmentQuestion.builder()
                .module(module)
                .questionText(request.questionText())
                .optionsJson(optionsJson)
                .correctAnswer(request.correctAnswer())
                .explanation(request.explanation())
                .build();

        AssessmentQuestion saved = assessmentQuestionRepository.save(question);
        AdminQuestionResponse response = new AdminQuestionResponse(
                saved.getId(),
                saved.getModule().getId(),
                saved.getQuestionText(),
                saved.getOptionsJson(),
                saved.getCorrectAnswer(),
                saved.getExplanation()
        );
        return ResponseEntity.ok(new ApiResponse<>(true, response, null));
    }

    @PutMapping("/questions/{id}")
    public ResponseEntity<ApiResponse<AdminQuestionResponse>> updateQuestion(@PathVariable String id, @Valid @RequestBody AdminQuestionRequest request) {
        AssessmentQuestion question = assessmentQuestionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Question not found"));

        String optionsJson;
        try {
            optionsJson = objectMapper.writeValueAsString(request.options());
        } catch (com.fasterxml.jackson.core.JsonProcessingException e) {
            throw new IllegalArgumentException("Invalid options format", e);
        }

        question.setQuestionText(request.questionText());
        question.setOptionsJson(optionsJson);
        question.setCorrectAnswer(request.correctAnswer());
        question.setExplanation(request.explanation());

        AssessmentQuestion saved = assessmentQuestionRepository.save(question);
        AdminQuestionResponse response = new AdminQuestionResponse(
                saved.getId(),
                saved.getModule().getId(),
                saved.getQuestionText(),
                saved.getOptionsJson(),
                saved.getCorrectAnswer(),
                saved.getExplanation()
        );
        return ResponseEntity.ok(new ApiResponse<>(true, response, null));
    }

    @DeleteMapping("/questions/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteQuestion(@PathVariable String id) {
        if (!assessmentQuestionRepository.existsById(id)) {
            throw new ResourceNotFoundException("Question not found");
        }
        assessmentQuestionRepository.deleteById(id);
        return ResponseEntity.ok(new ApiResponse<>(true, null, null));
    }
}
