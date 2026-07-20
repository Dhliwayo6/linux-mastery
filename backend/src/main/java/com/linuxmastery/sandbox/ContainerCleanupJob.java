package com.linuxmastery.sandbox;

import com.github.dockerjava.api.DockerClient;
import com.github.dockerjava.api.model.Container;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
@Slf4j
public class ContainerCleanupJob {

    private final DockerClient dockerClient;
    private final RedisTemplate<String, String> redisTemplate;
    private final SandboxService sandboxService;

    @Scheduled(fixedDelayString = "${sandbox.cleanup-interval-ms:300000}") // Default 5 minutes
    public void cleanupIdleContainers() {
        log.info("Running idle sandbox container cleanup job...");
        try {
            List<Container> containers = dockerClient.listContainersCmd()
                .withLabelFilter(Map.of("linux-mastery.type", "sandbox"))
                .exec();

            for (Container container : containers) {
                String userId = container.getLabels().get("linux-mastery.userId");
                if (userId == null) continue;

                Boolean stillActive = redisTemplate.hasKey("terminal:" + userId);

                if (Boolean.FALSE.equals(stillActive)) {
                    log.info("Removing idle container {} for user {}", container.getId(), userId);
                    try {
                        dockerClient.removeContainerCmd(container.getId()).withForce(true).exec();
                    } catch (Exception e) {
                        log.warn("Failed to remove container {}: {}", container.getId(), e.getMessage());
                    }
                    sandboxService.markSessionTerminated(userId, container.getId());
                }
            }
        } catch (Exception e) {
            log.error("Error occurred during container cleanup job: {}", e.getMessage(), e);
        }
    }
}
