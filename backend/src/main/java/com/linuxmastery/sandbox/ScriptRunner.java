package com.linuxmastery.sandbox;

import com.github.dockerjava.api.DockerClient;
import com.github.dockerjava.api.async.ResultCallback;
import com.github.dockerjava.api.command.CreateContainerResponse;
import com.github.dockerjava.api.command.ExecCreateCmdResponse;
import com.github.dockerjava.api.command.InspectExecResponse;
import com.github.dockerjava.api.model.Capability;
import com.github.dockerjava.api.model.Frame;
import com.github.dockerjava.api.model.HostConfig;
import com.github.dockerjava.api.model.StreamType;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

@Component
@RequiredArgsConstructor
public class ScriptRunner {

    private final DockerClient dockerClient;

    @Value("${sandbox.image}")
    private String sandboxImage;

    private static final String SAFETY_HEADER = """
        #!/usr/bin/env bash
        set -euo pipefail
        ulimit -t 10
        ulimit -v 262144
        ulimit -f 1024
        """;

    private static final int EXEC_TIMEOUT_SECONDS = 12;

    public RunResult run(String scriptContent) {
        String fullScript = SAFETY_HEADER + "\n" + scriptContent;

        // 1. Create a container running a safe sleeping command
        CreateContainerResponse container = dockerClient.createContainerCmd(sandboxImage)
            .withHostConfig(buildHardenedHostConfig())
            .withCmd("sleep", "30")
            .exec();

        dockerClient.startContainerCmd(container.getId()).exec();

        // 2. Write the script content to /tmp/submission.sh via exec tee
        ExecCreateCmdResponse execWrite = dockerClient.execCreateCmd(container.getId())
            .withAttachStdin(true)
            .withCmd("tee", "/tmp/submission.sh")
            .exec();

        java.io.ByteArrayInputStream scriptStream = new java.io.ByteArrayInputStream(fullScript.getBytes(StandardCharsets.UTF_8));
        try {
            dockerClient.execStartCmd(execWrite.getId())
                .withStdIn(scriptStream)
                .exec(new ResultCallback.Adapter<Frame>())
                .awaitCompletion(5, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // 3. Execute the script using timeout
        ExecCreateCmdResponse execRun = dockerClient.execCreateCmd(container.getId())
            .withAttachStdout(true)
            .withAttachStderr(true)
            .withCmd("timeout", "10", "/bin/bash", "/tmp/submission.sh")
            .exec();

        StringBuilder stdout = new StringBuilder();
        StringBuilder stderr = new StringBuilder();

        try {
            dockerClient.execStartCmd(execRun.getId())
                .exec(new ResultCallback.Adapter<Frame>() {
                    @Override
                    public void onNext(Frame frame) {
                        String text = new String(frame.getPayload(), StandardCharsets.UTF_8);
                        if (frame.getStreamType() == StreamType.STDOUT) {
                            stdout.append(text);
                        } else {
                            stderr.append(text);
                        }
                    }
                })
                .awaitCompletion(EXEC_TIMEOUT_SECONDS, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // 4. Retrieve execution exit status
        Integer exitCodeInt = null;
        try {
            InspectExecResponse inspect = dockerClient.inspectExecCmd(execRun.getId()).exec();
            exitCodeInt = inspect.getExitCode();
        } catch (Exception ignored) {}

        int exitCode = exitCodeInt != null ? exitCodeInt.intValue() : -1;

        // 5. Clean up container immediately (auto-remove handles deletion once stopped)
        try {
            dockerClient.stopContainerCmd(container.getId()).exec();
        } catch (Exception ignored) {}

        return new RunResult(
            stdout.toString(),
            stderr.toString(),
            exitCode,
            exitCode == 124
        );
    }

    private HostConfig buildHardenedHostConfig() {
        return HostConfig.newHostConfig()
            .withMemory(256 * 1024 * 1024L)
            .withMemorySwap(256 * 1024 * 1024L)
            .withCpuPeriod(100000L).withCpuQuota(50000L)
            .withPidsLimit(50L)
            .withCapDrop(Capability.ALL)
            .withSecurityOpts(List.of("no-new-privileges"))
            .withNetworkMode("none")
            .withReadonlyRootfs(true)
            .withTmpFs(Map.of("/tmp", "rw,noexec,nosuid,size=50m"))
            .withAutoRemove(true);
    }
}
