package com.linuxmastery.repository;

import com.linuxmastery.entity.SectionCompletion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface SectionCompletionRepository extends JpaRepository<SectionCompletion, String> {
    Optional<SectionCompletion> findByUserIdAndSectionId(String userId, String sectionId);
    long countByUserIdAndSection_Module_Id(String userId, String moduleId);
}
