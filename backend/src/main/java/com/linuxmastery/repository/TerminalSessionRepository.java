package com.linuxmastery.repository;

import com.linuxmastery.entity.TerminalSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface TerminalSessionRepository extends JpaRepository<TerminalSession, String> {
    Optional<TerminalSession> findByUserIdAndTerminatedAtIsNull(String userId);
    Optional<TerminalSession> findBySessionTokenAndTerminatedAtIsNull(String sessionToken);
}
