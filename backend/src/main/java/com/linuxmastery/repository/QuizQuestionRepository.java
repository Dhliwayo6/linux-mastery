package com.linuxmastery.repository;

import com.linuxmastery.entity.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface QuizQuestionRepository extends JpaRepository<QuizQuestion, String> {
    List<QuizQuestion> findBySectionIdOrderByOrderIndexAsc(String sectionId);
}
