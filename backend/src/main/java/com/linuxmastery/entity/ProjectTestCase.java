package com.linuxmastery.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;

@Entity
@Table(name = "project_test_cases")
@Getter @Setter @NoArgsConstructor
public class ProjectTestCase {
    @Id
    @Column(length = 36)
    private String id = UUID.randomUUID().toString();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id", nullable = false)
    private Project project;

    @Column(nullable = false, length = 500)
    private String description;

    @Column(nullable = false)
    private Integer weight;

    @Enumerated(EnumType.STRING)
    @Column(name = "test_type", nullable = false)
    private TestCaseType testType;

    @Column(nullable = false, length = 500)
    private String expected;

    @Column(name = "order_index", nullable = false)
    private Integer orderIndex;
}
