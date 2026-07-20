package com.linuxmastery.sandbox;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.dockerjava.api.DockerClient;
import com.github.dockerjava.api.command.CreateContainerCmd;
import com.github.dockerjava.api.command.CreateContainerResponse;
import com.github.dockerjava.api.command.InspectContainerCmd;
import com.github.dockerjava.api.command.RemoveContainerCmd;
import com.github.dockerjava.api.command.StartContainerCmd;
import com.github.dockerjava.api.exception.NotFoundException;
import com.github.dockerjava.api.command.InspectContainerResponse;
import com.linuxmastery.entity.TerminalSession;
import com.linuxmastery.entity.User;
import com.linuxmastery.repository.TerminalSessionRepository;
import com.linuxmastery.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class SandboxServiceTest {

    @Mock
    private DockerClient dockerClient;
    @Mock
    private RedisTemplate<String, String> redisTemplate;
    @Mock
    private ValueOperations<String, String> valueOperations;
    @Mock
    private TerminalSessionRepository terminalSessionRepository;
    @Mock
    private UserRepository userRepository;

    private ObjectMapper objectMapper = new ObjectMapper();
    private SandboxService sandboxService;

    @BeforeEach
    void setUp() {
        when(redisTemplate.opsForValue()).thenReturn(valueOperations);
        sandboxService = new SandboxService(
                dockerClient,
                redisTemplate,
                terminalSessionRepository,
                userRepository
        );
        ReflectionTestUtils.setField(sandboxService, "sandboxImage", "linux-mastery-sandbox:latest");
    }

    @Test
    void getOrCreateContainer_createsNewContainerWhenNoneExists() throws Exception {
        String userId = "user-123";
        User user = User.builder().id(userId).email("user@test.com").build();

        // Mock Redis: no active session
        when(valueOperations.get("terminal:" + userId)).thenReturn(null);

        // Mock User lookup
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));

        // Mock Docker Client: createContainerCmd & startContainerCmd
        CreateContainerCmd createCmd = mock(CreateContainerCmd.class);
        when(dockerClient.createContainerCmd(anyString())).thenReturn(createCmd);
        when(createCmd.withHostConfig(any())).thenReturn(createCmd);
        when(createCmd.withNetworkDisabled(anyBoolean())).thenReturn(createCmd);
        when(createCmd.withTty(anyBoolean())).thenReturn(createCmd);
        when(createCmd.withCmd(anyString())).thenReturn(createCmd);
        when(createCmd.withLabels(any())).thenReturn(createCmd);

        CreateContainerResponse createResponse = mock(CreateContainerResponse.class);
        when(createResponse.getId()).thenReturn("container-xyz");
        when(createCmd.exec()).thenReturn(createResponse);

        StartContainerCmd startCmd = mock(StartContainerCmd.class);
        when(dockerClient.startContainerCmd("container-xyz")).thenReturn(startCmd);

        // Mock DB: any existing active session checks
        when(terminalSessionRepository.findByUserIdAndTerminatedAtIsNull(userId)).thenReturn(Optional.empty());

        // Act
        TerminalSessionData result = sandboxService.getOrCreateContainer(userId);

        // Assert
        assertNotNull(result);
        assertEquals("container-xyz", result.containerId());
        assertNotNull(result.sessionToken());

        // Verifications
        verify(valueOperations).set(eq("terminal:" + userId), anyString(), any(java.time.Duration.class));
        verify(valueOperations).set(eq("terminal:token:" + result.sessionToken()), eq(userId), any(java.time.Duration.class));
        verify(terminalSessionRepository).save(any(TerminalSession.class));
    }

    @Test
    void getOrCreateContainer_reusesExistingContainerWhenHealthy() throws Exception {
        String userId = "user-123";
        String containerId = "container-xyz";
        String token = "token-123";
        TerminalSessionData sessionData = new TerminalSessionData(containerId, token);
        String json = objectMapper.writeValueAsString(sessionData);

        // Mock Redis: returns existing session
        when(valueOperations.get("terminal:" + userId)).thenReturn(json);

        // Mock Docker Client: inspectContainerCmd succeeds
        InspectContainerCmd inspectCmd = mock(InspectContainerCmd.class);
        when(dockerClient.inspectContainerCmd(containerId)).thenReturn(inspectCmd);
        InspectContainerResponse inspectResponse = mock(InspectContainerResponse.class);
        when(inspectCmd.exec()).thenReturn(inspectResponse);

        // Act
        TerminalSessionData result = sandboxService.getOrCreateContainer(userId);

        // Assert
        assertNotNull(result);
        assertEquals(containerId, result.containerId());
        assertEquals(token, result.sessionToken());

        // Verify TTL refreshed, and no container created
        verify(redisTemplate).expire(eq("terminal:" + userId), any(java.time.Duration.class));
        verify(redisTemplate).expire(eq("terminal:token:" + token), any(java.time.Duration.class));
        verify(dockerClient, never()).createContainerCmd(anyString());
    }

    @Test
    void getOrCreateContainer_createsNewContainerWhenExistingIsStale() throws Exception {
        String userId = "user-123";
        String containerId = "container-xyz";
        String token = "token-123";
        TerminalSessionData sessionData = new TerminalSessionData(containerId, token);
        String json = objectMapper.writeValueAsString(sessionData);

        User user = User.builder().id(userId).email("user@test.com").build();

        // Mock Redis: returns existing session
        when(valueOperations.get("terminal:" + userId)).thenReturn(json);

        // Mock Docker Client: inspectContainerCmd throws NotFoundException
        InspectContainerCmd inspectCmd = mock(InspectContainerCmd.class);
        when(dockerClient.inspectContainerCmd(containerId)).thenReturn(inspectCmd);
        when(inspectCmd.exec()).thenThrow(new NotFoundException("Container not found"));

        // Mock new container creation
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        CreateContainerCmd createCmd = mock(CreateContainerCmd.class);
        when(dockerClient.createContainerCmd(anyString())).thenReturn(createCmd);
        when(createCmd.withHostConfig(any())).thenReturn(createCmd);
        when(createCmd.withNetworkDisabled(anyBoolean())).thenReturn(createCmd);
        when(createCmd.withTty(anyBoolean())).thenReturn(createCmd);
        when(createCmd.withCmd(anyString())).thenReturn(createCmd);
        when(createCmd.withLabels(any())).thenReturn(createCmd);

        CreateContainerResponse createResponse = mock(CreateContainerResponse.class);
        when(createResponse.getId()).thenReturn("container-new");
        when(createCmd.exec()).thenReturn(createResponse);

        StartContainerCmd startCmd = mock(StartContainerCmd.class);
        when(dockerClient.startContainerCmd("container-new")).thenReturn(startCmd);

        // Mock DB
        when(terminalSessionRepository.findByUserIdAndTerminatedAtIsNull(userId)).thenReturn(Optional.empty());

        // Act
        TerminalSessionData result = sandboxService.getOrCreateContainer(userId);

        // Assert
        assertNotNull(result);
        assertEquals("container-new", result.containerId());
        assertNotEquals(token, result.sessionToken());

        // Verify stale Redis entries deleted, and new one created
        verify(redisTemplate).delete("terminal:" + userId);
        verify(dockerClient).createContainerCmd(anyString());
    }

    @Test
    void terminateContainer_removesContainerAndCleansUp() throws Exception {
        String userId = "user-123";
        String containerId = "container-xyz";
        String token = "token-123";
        TerminalSessionData sessionData = new TerminalSessionData(containerId, token);
        String json = objectMapper.writeValueAsString(sessionData);

        // Mock Redis: returns existing session
        when(valueOperations.get("terminal:" + userId)).thenReturn(json);

        // Mock Docker Client: removeContainerCmd
        RemoveContainerCmd removeCmd = mock(RemoveContainerCmd.class);
        when(dockerClient.removeContainerCmd(containerId)).thenReturn(removeCmd);
        when(removeCmd.withForce(true)).thenReturn(removeCmd);

        // Mock DB: active session exists
        // Wait, builder has user relationship. Let's mock the object.
        TerminalSession mockSession = mock(TerminalSession.class);
        when(terminalSessionRepository.findByUserIdAndTerminatedAtIsNull(userId)).thenReturn(Optional.of(mockSession));

        // Act
        sandboxService.terminateContainer(userId);

        // Assert/Verify
        verify(dockerClient).removeContainerCmd(containerId);
        verify(redisTemplate).delete("terminal:" + userId);
        verify(redisTemplate).delete("terminal:token:" + token);
        verify(mockSession).setTerminatedAt(any());
        verify(terminalSessionRepository).save(mockSession);
    }
}
