package com.linuxmastery.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "projects")
@Getter @Setter @NoArgsConstructor
public class Project {
    @Id
    @Column(length = 36)
    private String id = UUID.randomUUID().toString();

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "module_id", nullable = false, unique = true)
    private Module module;

    @Column(nullable = false)
    private String title;

    @Column(name = "brief_md", nullable = false, columnDefinition = "MEDIUMTEXT")
    private String briefMd;

    @OneToMany(mappedBy = "project", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("orderIndex ASC")
    private List<ProjectTestCase> testCases = new ArrayList<>();
}
