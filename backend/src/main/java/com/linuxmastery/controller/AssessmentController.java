package com.linuxmastery.controller;

import com.linuxmastery.dto.request.AssessmentSubmitRequest;
import com.linuxmastery.dto.response.ApiResponse;
import com.linuxmastery.dto.response.AssessmentQuestionResponse;
import com.linuxmastery.dto.response.AssessmentResultResponse;
import com.linuxmastery.entity.AssessmentAttempt;
import com.linuxmastery.service.AssessmentService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/assessment")
public class AssessmentController {

    private final AssessmentService assessmentService;

    public AssessmentController(AssessmentService assessmentService) {
        this.assessmentService = assessmentService;
    }

    @GetMapping("/{moduleId}")
    public ResponseEntity<ApiResponse<List<AssessmentQuestionResponse>>> getAssessment(
            @PathVariable String moduleId) {
        String userId = currentUserId();
        List<AssessmentQuestionResponse> questions = assessmentService.getAssessment(moduleId, userId);
        return ResponseEntity.ok(new ApiResponse<>(true, questions, null));
    }

    @PostMapping("/{moduleId}/submit")
    public ResponseEntity<ApiResponse<AssessmentResultResponse>> submit(
            @PathVariable String moduleId,
            @Valid @RequestBody AssessmentSubmitRequest request) {
        String userId = currentUserId();
        AssessmentResultResponse result = assessmentService.submitAssessment(
                moduleId, userId, request.answers(), request.durationSecs()
        );
        return ResponseEntity.ok(new ApiResponse<>(true, result, null));
    }

    @GetMapping("/{moduleId}/history")
    public ResponseEntity<ApiResponse<List<AssessmentAttempt>>> history(@PathVariable String moduleId) {
        String userId = currentUserId();
        List<AssessmentAttempt> history = assessmentService.getAssessmentHistory(moduleId, userId);
        return ResponseEntity.ok(new ApiResponse<>(true, history, null));
    }

    private String currentUserId() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }
}
