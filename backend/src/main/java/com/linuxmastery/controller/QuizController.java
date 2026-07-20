package com.linuxmastery.controller;

import com.linuxmastery.dto.request.QuizSubmitRequest;
import com.linuxmastery.dto.response.ApiResponse;
import com.linuxmastery.dto.response.QuizResultResponse;
import com.linuxmastery.entity.QuizAttempt;
import com.linuxmastery.service.QuizService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/quiz")
public class QuizController {

    private final QuizService quizService;

    public QuizController(QuizService quizService) {
        this.quizService = quizService;
    }

    @PostMapping("/{sectionId}/submit")
    public ResponseEntity<ApiResponse<QuizResultResponse>> submit(
            @PathVariable String sectionId,
            @Valid @RequestBody QuizSubmitRequest request) {
        String userId = currentUserId();
        QuizResultResponse result = quizService.submitSectionQuiz(sectionId, userId, request.answers());
        return ResponseEntity.ok(new ApiResponse<>(true, result, null));
    }

    @GetMapping("/{sectionId}/history")
    public ResponseEntity<ApiResponse<List<QuizAttempt>>> history(@PathVariable String sectionId) {
        String userId = currentUserId();
        List<QuizAttempt> history = quizService.getQuizHistory(sectionId, userId);
        return ResponseEntity.ok(new ApiResponse<>(true, history, null));
    }

    private String currentUserId() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }
}
