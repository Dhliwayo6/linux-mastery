package com.linuxmastery.controller;

import com.linuxmastery.dto.response.ApiResponse;
import com.linuxmastery.dto.response.TerminalSessionResponse;
import com.linuxmastery.sandbox.SandboxService;
import com.linuxmastery.sandbox.TerminalSessionData;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/terminal")
@RequiredArgsConstructor
public class TerminalController {

    private final SandboxService sandboxService;

    @PostMapping("/session")
    public ResponseEntity<ApiResponse<TerminalSessionResponse>> createSession() {
        String userId = currentUserId();
        TerminalSessionData session = sandboxService.getOrCreateContainer(userId);
        return ResponseEntity.ok(new ApiResponse<>(
            true, 
            new TerminalSessionResponse(session.sessionToken()), 
            null
        ));
    }

    @DeleteMapping("/session")
    public ResponseEntity<Void> deleteSession() {
        String userId = currentUserId();
        sandboxService.terminateContainer(userId);
        return ResponseEntity.noContent().build();
    }

    private String currentUserId() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }
}
