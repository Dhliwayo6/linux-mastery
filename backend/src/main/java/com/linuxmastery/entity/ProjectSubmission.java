package com.linuxmastery.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "project_submissions")
@Getter @Setter @NoArgsConstructor
public class ProjectSubmission {
    @Id
    @Column(length = 36)
    private String id = UUID.randomUUID().toString();

    @Column(name = "user_id", nullable = false, length = 36)
    private String userId;

    @Column(name = "project_id", nullable = false, length = 36)
    private String projectId;

    @Column(name = "script_content", nullable = false, columnDefinition = "MEDIUMTEXT")
    private String scriptContent;

    @Column(nullable = false, precision = 5, scale = 2)
    private BigDecimal score;

    @Column(name = "test_results_json", nullable = false, columnDefinition = "JSON")
    private String testResultsJson;

    @Column(name = "memo_md", nullable = false, columnDefinition = "MEDIUMTEXT")
    private String memoMd;

    @Column(name = "attempt_number", nullable = false)
    private Integer attemptNumber;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
}
