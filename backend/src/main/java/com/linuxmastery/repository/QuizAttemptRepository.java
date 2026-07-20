package com.linuxmastery.repository;

import com.linuxmastery.entity.QuizAttempt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizAttemptRepository extends JpaRepository<QuizAttempt, String> {
    List<QuizAttempt> findByUserIdAndSectionIdOrderByCreatedAtDesc(String userId, String sectionId);
}
