package com.linuxmastery.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.UUID;

@Entity
@Table(name = "assessment_questions")
@Getter 
@Setter 
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AssessmentQuestion {
    @Id
    @Column(length = 36)
    @Builder.Default
    private String id = UUID.randomUUID().toString();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "module_id", nullable = false)
    private Module module;

    @Column(name = "question_text", nullable = false, columnDefinition = "TEXT")
    private String questionText;

    @Column(name = "options_json", nullable = false, columnDefinition = "JSON")
    private String optionsJson;

    @Column(name = "correct_answer", nullable = false, length = 10)
    private String correctAnswer;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String explanation;
}
