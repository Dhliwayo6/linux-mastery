package com.linuxmastery.websocket;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.dockerjava.api.DockerClient;
import com.github.dockerjava.api.async.ResultCallback;
import com.github.dockerjava.api.command.ExecCreateCmdResponse;
import com.github.dockerjava.api.model.Frame;
import com.linuxmastery.sandbox.TerminalSessionData;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.io.PipedInputStream;
import java.io.PipedOutputStream;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

@Component
@RequiredArgsConstructor
public class TerminalWebSocketHandler extends TextWebSocketHandler {

    private final DockerClient dockerClient;
    private final RedisTemplate<String, String> redisTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        String token = extractToken(session);
        if (token == null) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("Token is missing"));
            return;
        }

        String userId = redisTemplate.opsForValue().get("terminal:token:" + token);
        if (userId == null) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("Unauthorized"));
            return;
        }

        String sessionJson = redisTemplate.opsForValue().get("terminal:" + userId);
        if (sessionJson == null) {
            session.close(CloseStatus.SERVER_ERROR.withReason("No active session"));
            return;
        }

        TerminalSessionData terminalSession = objectMapper.readValue(sessionJson, TerminalSessionData.class);

        PipedOutputStream pos = new PipedOutputStream();
        PipedInputStream pis = new PipedInputStream(pos);

        session.getAttributes().put("pos", pos);
        session.getAttributes().put("pis", pis);
        session.getAttributes().put("userId", userId);
        session.getAttributes().put("token", token);

        ExecCreateCmdResponse exec = dockerClient.execCreateCmd(terminalSession.containerId())
            .withAttachStdin(true)
            .withAttachStdout(true)
            .withAttachStderr(true)
            .withTty(true)
            .withCmd("/bin/bash")
            .exec();

        ResultCallback.Adapter<Frame> adapter = new ResultCallback.Adapter<Frame>() {
            @Override
            public void onNext(Frame frame) {
                try {
                    synchronized (session) {
                        if (session.isOpen()) {
                            session.sendMessage(new TextMessage(frame.getPayload()));
                        }
                    }
                } catch (IOException ignored) {}
            }
        };

        session.getAttributes().put("adapter", adapter);

        dockerClient.execStartCmd(exec.getId())
            .withStdIn(pis)
            .withTty(true)
            .exec(adapter);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) {
        String userId = (String) session.getAttributes().get("userId");
        String token = (String) session.getAttributes().get("token");

        if (userId != null && token != null) {
            redisTemplate.expire("terminal:" + userId, Duration.ofMinutes(30));
            redisTemplate.expire("terminal:token:" + token, Duration.ofMinutes(30));
        }

        PipedOutputStream pos = (PipedOutputStream) session.getAttributes().get("pos");
        if (pos != null) {
            try {
                pos.write(message.getPayload().getBytes(StandardCharsets.UTF_8));
                pos.flush();
            } catch (IOException ignored) {}
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        PipedOutputStream pos = (PipedOutputStream) session.getAttributes().get("pos");
        if (pos != null) {
            try {
                pos.close();
            } catch (IOException ignored) {}
        }
        PipedInputStream pis = (PipedInputStream) session.getAttributes().get("pis");
        if (pis != null) {
            try {
                pis.close();
            } catch (IOException ignored) {}
        }

        @SuppressWarnings("unchecked")
        ResultCallback.Adapter<Frame> adapter = (ResultCallback.Adapter<Frame>) session.getAttributes().get("adapter");
        if (adapter != null) {
            try {
                adapter.close();
            } catch (IOException ignored) {}
        }
    }

    private String extractToken(WebSocketSession session) {
        String query = session.getUri() != null ? session.getUri().getQuery() : null;
        if (query == null) return null;
        for (String param : query.split("&")) {
            String[] pair = param.split("=");
            if (pair.length == 2 && pair[0].equals("token")) {
                return pair[1];
            }
        }
        return null;
    }
}
