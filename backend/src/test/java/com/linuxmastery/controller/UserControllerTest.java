package com.linuxmastery.controller;

import com.linuxmastery.dto.request.UpdateProfileRequest;
import com.linuxmastery.dto.response.ApiResponse;
import com.linuxmastery.dto.response.UserProfileResponse;
import com.linuxmastery.entity.Role;
import com.linuxmastery.entity.User;
import com.linuxmastery.repository.UserRepository;
import com.linuxmastery.exception.ResourceNotFoundException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserControllerTest {

    @Mock
    private UserRepository userRepository;

    private UserController userController;

    @BeforeEach
    void setUp() {
        userController = new UserController(userRepository);
        SecurityContextHolder.getContext().setAuthentication(
            new UsernamePasswordAuthenticationToken("user-uuid-123", null)
        );
    }

    @Test
    void getProfile_returnsUserProfileSuccessfully() {
        User mockUser = User.builder()
                .id("user-uuid-123")
                .email("student@linuxmastery.com")
                .displayName("Student Name")
                .role(Role.STUDENT)
                .build();

        when(userRepository.findById("user-uuid-123")).thenReturn(Optional.of(mockUser));

        ResponseEntity<ApiResponse<UserProfileResponse>> response = userController.getProfile();

        assertNotNull(response);
        assertEquals(200, response.getStatusCode().value());
        assertTrue(response.getBody().success());
        assertEquals("Student Name", response.getBody().data().displayName());
        assertEquals("student@linuxmastery.com", response.getBody().data().email());
    }

    @Test
    void getProfile_throwsNotFoundExceptionWhenUserMissing() {
        when(userRepository.findById("user-uuid-123")).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class, () -> userController.getProfile());
    }

    @Test
    void updateProfile_updatesProfileSuccessfully() {
        User mockUser = User.builder()
                .id("user-uuid-123")
                .email("student@linuxmastery.com")
                .displayName("Student Name")
                .role(Role.STUDENT)
                .build();

        UpdateProfileRequest req = new UpdateProfileRequest("New Student Name", "student@linuxmastery.com");

        when(userRepository.findById("user-uuid-123")).thenReturn(Optional.of(mockUser));
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        ResponseEntity<ApiResponse<UserProfileResponse>> response = userController.updateProfile(req);

        assertNotNull(response);
        assertEquals(200, response.getStatusCode().value());
        assertEquals("New Student Name", response.getBody().data().displayName());
        assertEquals("student@linuxmastery.com", response.getBody().data().email());
    }

    @Test
    void updateProfile_throwsExceptionIfEmailAlreadyTakenByAnother() {
        User mockUser = User.builder()
                .id("user-uuid-123")
                .email("student@linuxmastery.com")
                .displayName("Student Name")
                .role(Role.STUDENT)
                .build();

        User anotherUser = User.builder()
                .id("another-uuid")
                .email("taken@linuxmastery.com")
                .displayName("Taken Name")
                .role(Role.STUDENT)
                .build();

        UpdateProfileRequest req = new UpdateProfileRequest("New Name", "taken@linuxmastery.com");

        when(userRepository.findById("user-uuid-123")).thenReturn(Optional.of(mockUser));
        when(userRepository.findByEmail("taken@linuxmastery.com")).thenReturn(Optional.of(anotherUser));

        assertThrows(IllegalArgumentException.class, () -> userController.updateProfile(req));
        verify(userRepository, never()).save(any(User.class));
    }
}
