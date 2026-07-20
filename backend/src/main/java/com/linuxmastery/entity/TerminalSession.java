package com.linuxmastery.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "terminal_sessions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TerminalSession {

    @Id
    @Column(length = 36)
    @Builder.Default
    private String id = UUID.randomUUID().toString();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "container_id", nullable = false, length = 100)
    private String containerId;

    @Column(name = "session_token", nullable = false, unique = true, length = 100)
    private String sessionToken;

    @Column(name = "created_at", nullable = false)
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "last_active_at", nullable = false)
    @Builder.Default
    private LocalDateTime lastActiveAt = LocalDateTime.now();

    @Column(name = "terminated_at")
    private LocalDateTime terminatedAt;
}
