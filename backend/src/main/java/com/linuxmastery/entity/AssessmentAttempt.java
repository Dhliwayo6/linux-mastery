package com.linuxmastery.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "assessment_attempts")
@Getter 
@Setter 
@NoArgsConstructor
public class AssessmentAttempt {
    @Id
    @Column(length = 36)
    private String id = UUID.randomUUID().toString();

    @Column(name = "user_id", nullable = false, length = 36)
    private String userId;

    @Column(name = "module_id", nullable = false, length = 36)
    private String moduleId;

    @Column(name = "answers_json", nullable = false, columnDefinition = "JSON")
    private String answersJson;

    @Column(nullable = false, precision = 5, scale = 2)
    private BigDecimal score;

    @Column(nullable = false)
    private boolean passed;

    @Column(name = "duration_secs", nullable = false)
    private Integer durationSecs;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
}
