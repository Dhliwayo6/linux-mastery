package com.linuxmastery.sandbox;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.dockerjava.api.DockerClient;
import com.github.dockerjava.api.command.CreateContainerResponse;
import com.github.dockerjava.api.model.Capability;
import com.github.dockerjava.api.model.HostConfig;
import com.linuxmastery.entity.TerminalSession;
import com.linuxmastery.entity.User;
import com.linuxmastery.repository.TerminalSessionRepository;
import com.linuxmastery.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HexFormat;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SandboxService {

    private final DockerClient dockerClient;
    private final RedisTemplate<String, String> redisTemplate;
    private final TerminalSessionRepository terminalSessionRepository;
    private final UserRepository userRepository;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${sandbox.image}")
    private String sandboxImage;

    @Transactional
    public TerminalSessionData getOrCreateContainer(String userId) {
        String existingJson = redisTemplate.opsForValue().get("terminal:" + userId);

        if (existingJson != null) {
            try {
                TerminalSessionData session = objectMapper.readValue(existingJson, TerminalSessionData.class);
                dockerClient.inspectContainerCmd(session.containerId()).exec(); // throws if missing
                
                redisTemplate.expire("terminal:" + userId, Duration.ofMinutes(30));
                redisTemplate.expire("terminal:token:" + session.sessionToken(), Duration.ofMinutes(30));
                
                // Update database activity log
                terminalSessionRepository.findByUserIdAndTerminatedAtIsNull(userId).ifPresent(ts -> {
                    ts.setLastActiveAt(LocalDateTime.now());
                    terminalSessionRepository.save(ts);
                });
                
                return session;
            } catch (Exception e) {
                // Remove stale info
                redisTemplate.delete("terminal:" + userId);
                // fall through to create a new container
            }
        }

        // HostConfig and container limits as per SECURITY.md
        HostConfig hostConfig = buildHardenedHostConfig();

        CreateContainerResponse container = dockerClient.createContainerCmd(sandboxImage)
            .withHostConfig(hostConfig)
            .withNetworkDisabled(true)
            .withTty(true)
            .withCmd("/bin/bash")
            .withLabels(Map.of(
                "linux-mastery.type", "sandbox",
                "linux-mastery.userId", userId
            ))
            .exec();

        dockerClient.startContainerCmd(container.getId()).exec();

        String sessionToken = generateSecureToken();
        TerminalSessionData session = new TerminalSessionData(container.getId(), sessionToken);

        try {
            String json = objectMapper.writeValueAsString(session);
            redisTemplate.opsForValue().set("terminal:" + userId, json, Duration.ofMinutes(30));
            redisTemplate.opsForValue().set("terminal:token:" + sessionToken, userId, Duration.ofMinutes(30));
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to serialize session", e);
        }

        persistSessionAudit(userId, container.getId(), sessionToken);

        return session;
    }

    @Transactional
    public void terminateContainer(String userId) {
        String existingJson = redisTemplate.opsForValue().get("terminal:" + userId);
        if (existingJson != null) {
            try {
                TerminalSessionData session = objectMapper.readValue(existingJson, TerminalSessionData.class);
                dockerClient.removeContainerCmd(session.containerId()).withForce(true).exec();
                redisTemplate.delete("terminal:token:" + session.sessionToken());
            } catch (Exception ignored) {
                // Container may already be gone
            }
        }

        redisTemplate.delete("terminal:" + userId);
        markSessionTerminated(userId);
    }

    private HostConfig buildHardenedHostConfig() {
        return HostConfig.newHostConfig()
            .withMemory(256 * 1024 * 1024L)
            .withMemorySwap(256 * 1024 * 1024L)
            .withCpuPeriod(100000L)
            .withCpuQuota(50000L)
            .withPidsLimit(50L)
            .withCapDrop(Capability.ALL)
            .withSecurityOpts(List.of("no-new-privileges"))
            .withNetworkMode("none")
            .withReadonlyRootfs(true)
            .withTmpFs(Map.of("/tmp", "rw,noexec,nosuid,size=50m"))
            .withAutoRemove(true);
    }

    private void persistSessionAudit(String userId, String containerId, String sessionToken) {
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new IllegalArgumentException("User not found: " + userId));

        // Terminate any existing non-terminated sessions in database first
        terminalSessionRepository.findByUserIdAndTerminatedAtIsNull(userId).ifPresent(ts -> {
            ts.setTerminatedAt(LocalDateTime.now());
            terminalSessionRepository.save(ts);
        });

        TerminalSession terminalSession = TerminalSession.builder()
            .user(user)
            .containerId(containerId)
            .sessionToken(sessionToken)
            .build();

        terminalSessionRepository.save(terminalSession);
    }

    private void markSessionTerminated(String userId) {
        terminalSessionRepository.findByUserIdAndTerminatedAtIsNull(userId).ifPresent(ts -> {
            ts.setTerminatedAt(LocalDateTime.now());
            terminalSessionRepository.save(ts);
        });
    }

    @Transactional
    public void markSessionTerminated(String userId, String containerId) {
        terminalSessionRepository.findByUserIdAndTerminatedAtIsNull(userId).ifPresent(ts -> {
            if (ts.getContainerId().equals(containerId)) {
                ts.setTerminatedAt(LocalDateTime.now());
                terminalSessionRepository.save(ts);
            }
        });
    }

    private String generateSecureToken() {
        byte[] bytes = new byte[32];
        new SecureRandom().nextBytes(bytes);
        return HexFormat.of().formatHex(bytes);
    }
}
