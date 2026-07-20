package com.linuxmastery.controller;

import com.linuxmastery.dto.request.ProjectSubmitRequest;
import com.linuxmastery.dto.response.ApiResponse;
import com.linuxmastery.dto.response.ProjectResponse;
import com.linuxmastery.dto.response.ProjectSubmissionResponse;
import com.linuxmastery.entity.ProjectSubmission;
import com.linuxmastery.service.ProjectService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/project")
public class ProjectController {

    private final ProjectService projectService;

    public ProjectController(ProjectService projectService) {
        this.projectService = projectService;
    }

    @GetMapping("/{moduleId}")
    public ResponseEntity<ApiResponse<ProjectResponse>> getBrief(@PathVariable String moduleId) {
        ProjectResponse response = projectService.getProjectBrief(moduleId);
        return ResponseEntity.ok(new ApiResponse<>(true, response, null));
    }

    @PostMapping("/{moduleId}/submit")
    public ResponseEntity<ApiResponse<ProjectSubmissionResponse>> submit(
            @PathVariable String moduleId,
            @Valid @RequestBody ProjectSubmitRequest request) {
        
        String userId = currentUserId();
        ProjectSubmissionResponse response = projectService.submitProject(moduleId, userId, request.script());
        return ResponseEntity.ok(new ApiResponse<>(true, response, null));
    }

    @GetMapping("/{moduleId}/history")
    public ResponseEntity<ApiResponse<List<ProjectSubmission>>> history(@PathVariable String moduleId) {
        String userId = currentUserId();
        List<ProjectSubmission> history = projectService.getSubmissionHistory(moduleId, userId);
        return ResponseEntity.ok(new ApiResponse<>(true, history, null));
    }

    private String currentUserId() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }
}
