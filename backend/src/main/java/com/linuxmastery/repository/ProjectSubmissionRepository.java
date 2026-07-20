package com.linuxmastery.repository;

import com.linuxmastery.entity.ProjectSubmission;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProjectSubmissionRepository extends JpaRepository<ProjectSubmission, String> {
    List<ProjectSubmission> findByUserIdAndProjectIdOrderByCreatedAtDesc(String userId, String projectId);
    long countByUserIdAndProjectId(String userId, String projectId);
}
