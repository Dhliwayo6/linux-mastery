package com.linuxmastery.repository;

import com.linuxmastery.entity.AssessmentQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AssessmentQuestionRepository extends JpaRepository<AssessmentQuestion, String> {
    List<AssessmentQuestion> findByModuleId(String moduleId);
}
