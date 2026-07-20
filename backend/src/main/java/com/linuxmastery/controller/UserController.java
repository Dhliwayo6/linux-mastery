package com.linuxmastery.controller;

import com.linuxmastery.dto.request.UpdateProfileRequest;
import com.linuxmastery.dto.response.ApiResponse;
import com.linuxmastery.dto.response.UserProfileResponse;
import com.linuxmastery.entity.User;
import com.linuxmastery.repository.UserRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/users")
@RequiredArgsConstructor
public class UserController {

    private final UserRepository userRepository;

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<UserProfileResponse>> getProfile() {
        String userId = currentUserId();
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new com.linuxmastery.exception.ResourceNotFoundException("User not found"));

        UserProfileResponse res = new UserProfileResponse(
            user.getId(),
            user.getEmail(),
            user.getDisplayName(),
            user.getRole().name()
        );
        return ResponseEntity.ok(new ApiResponse<>(true, res, null));
    }

    @PutMapping("/me")
    public ResponseEntity<ApiResponse<UserProfileResponse>> updateProfile(@Valid @RequestBody UpdateProfileRequest req) {
        String userId = currentUserId();
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new com.linuxmastery.exception.ResourceNotFoundException("User not found"));

        // If email has changed, check if it's already in use by another user
        if (!user.getEmail().equalsIgnoreCase(req.email())) {
            if (userRepository.findByEmail(req.email()).isPresent()) {
                throw new IllegalArgumentException("Email address is already in use by another account");
            }
            user.setEmail(req.email());
        }

        user.setDisplayName(req.displayName());
        User savedUser = userRepository.save(user);

        UserProfileResponse res = new UserProfileResponse(
            savedUser.getId(),
            savedUser.getEmail(),
            savedUser.getDisplayName(),
            savedUser.getRole().name()
        );
        return ResponseEntity.ok(new ApiResponse<>(true, res, null));
    }

    private String currentUserId() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }
}
