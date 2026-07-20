package com.linuxmastery.repository;

import com.linuxmastery.entity.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface ProjectRepository extends JpaRepository<Project, String> {
    Optional<Project> findByModuleId(String moduleId);
}
