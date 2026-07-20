package com.linuxmastery.controller;

import com.linuxmastery.dto.response.ApiResponse;
import com.linuxmastery.dto.response.UserProgressResponse;
import com.linuxmastery.service.CurriculumService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/progress")
public class ProgressController {

    private final CurriculumService curriculumService;

    public ProgressController(CurriculumService curriculumService) {
        this.curriculumService = curriculumService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<UserProgressResponse>>> getProgress() {
        String userId = currentUserId();
        List<UserProgressResponse> progress = curriculumService.getUserProgressList(userId);
        return ResponseEntity.ok(new ApiResponse<>(true, progress, null));
    }

    private String currentUserId() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }
}
