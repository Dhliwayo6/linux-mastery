package com.linuxmastery.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "section_completions", uniqueConstraints = {
    @UniqueConstraint(name = "uq_sc_user_section", columnNames = {"user_id", "section_id"})
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SectionCompletion {
    @Id
    @Column(length = 36)
    @Builder.Default
    private String id = UUID.randomUUID().toString();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "section_id", nullable = false)
    private Section section;

    @Column(name = "completed_at", nullable = false, updatable = false)
    @Builder.Default
    private LocalDateTime completedAt = LocalDateTime.now();
}
