package com.linuxmastery.controller;

import com.linuxmastery.dto.response.ApiResponse;
import com.linuxmastery.dto.response.ModuleResponse;
import com.linuxmastery.dto.response.SectionResponse;
import com.linuxmastery.service.CurriculumService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/modules")
public class ModuleController {

    private final CurriculumService curriculumService;

    public ModuleController(CurriculumService curriculumService) {
        this.curriculumService = curriculumService;
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<ModuleResponse>>> getAllModules() {
        String userId = currentUserId();
        return ResponseEntity.ok(new ApiResponse<>(true, curriculumService.getModulesWithProgress(userId), null));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ModuleResponse>> getModule(@PathVariable String id) {
        String userId = currentUserId();
        return ResponseEntity.ok(new ApiResponse<>(true, curriculumService.getModuleWithProgress(id, userId), null));
    }

    @GetMapping("/{id}/sections/{sectionId}")
    public ResponseEntity<ApiResponse<SectionResponse>> getSection(
            @PathVariable String id, @PathVariable String sectionId) {
        String userId = currentUserId();
        return ResponseEntity.ok(new ApiResponse<>(true, curriculumService.getSectionDetails(id, sectionId, userId), null));
    }

    @PostMapping("/{id}/sections/{sectionId}/complete")
    public ResponseEntity<ApiResponse<Void>> completeSection(
            @PathVariable String id, @PathVariable String sectionId) {
        String userId = currentUserId();
        curriculumService.completeSection(id, sectionId, userId);
        return ResponseEntity.ok(new ApiResponse<>(true, null, null));
    }

    private String currentUserId() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }
}
