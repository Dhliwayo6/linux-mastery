package com.linuxmastery.repository;

import com.linuxmastery.entity.AssessmentAttempt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AssessmentAttemptRepository extends JpaRepository<AssessmentAttempt, String> {
    List<AssessmentAttempt> findByUserIdAndModuleIdOrderByCreatedAtDesc(String userId, String moduleId);
    Optional<AssessmentAttempt> findTopByUserIdAndModuleIdOrderByScoreDesc(String userId, String moduleId);
}
