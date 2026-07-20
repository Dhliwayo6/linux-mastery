package com.linuxmastery.entity;

import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;

@Entity
@Table(name = "quiz_questions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuizQuestion {
    @Id
    @Column(length = 36)
    @Builder.Default
    private String id = UUID.randomUUID().toString();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "section_id", nullable = false)
    private Section section;

    @Column(name = "question_text", nullable = false, columnDefinition = "TEXT")
    private String questionText;

    @Enumerated(EnumType.STRING)
    @Column(name = "question_type", nullable = false)
    private QuestionType questionType;

    @Column(name = "options_json", columnDefinition = "JSON")
    private String optionsJson;

    @Column(name = "correct_answer", nullable = false, length = 500)
    private String correctAnswer;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String explanation;

    @Column(name = "order_index", nullable = false)
    private Integer orderIndex;
}
