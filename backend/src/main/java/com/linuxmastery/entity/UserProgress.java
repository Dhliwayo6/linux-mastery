package com.linuxmastery.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "user_progress", uniqueConstraints = {
    @UniqueConstraint(name = "uq_up_user_module", columnNames = {"user_id", "module_id"})
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserProgress {
    @Id
    @Column(length = 36)
    @Builder.Default
    private String id = UUID.randomUUID().toString();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "module_id", nullable = false)
    private Module module;

    @Column(name = "sections_completed", nullable = false)
    @Builder.Default
    private Integer sectionsCompleted = 0;

    @Column(name = "total_sections", nullable = false)
    private Integer totalSections;

    @Column(name = "best_assessment_score")
    private BigDecimal bestAssessmentScore;

    @Column(name = "assessment_passed", nullable = false)
    @Builder.Default
    private Boolean assessmentPassed = false;

    @Column(name = "best_project_score")
    private BigDecimal bestProjectScore;

    @Column(name = "module_completed", nullable = false)
    @Builder.Default
    private Boolean moduleCompleted = false;

    @Column(name = "module_completed_at")
    private LocalDateTime moduleCompletedAt;

    @Column(name = "updated_at", nullable = false)
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
