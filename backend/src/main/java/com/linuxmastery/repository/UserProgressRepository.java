package com.linuxmastery.repository;

import com.linuxmastery.entity.UserProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserProgressRepository extends JpaRepository<UserProgress, String> {
    Optional<UserProgress> findByUserIdAndModuleId(String userId, String moduleId);
    List<UserProgress> findByUserId(String userId);
}
