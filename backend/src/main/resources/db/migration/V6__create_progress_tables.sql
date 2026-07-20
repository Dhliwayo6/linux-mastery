CREATE TABLE user_progress (
    id                      VARCHAR(36)  NOT NULL,
    user_id                 VARCHAR(36)  NOT NULL,
    module_id               VARCHAR(36)  NOT NULL,
    sections_completed      INT          NOT NULL DEFAULT 0,
    total_sections          INT          NOT NULL,
    best_assessment_score   DECIMAL(5,2),
    assessment_passed       BOOLEAN      NOT NULL DEFAULT FALSE,
    best_project_score      DECIMAL(5,2),
    module_completed        BOOLEAN      NOT NULL DEFAULT FALSE,
    module_completed_at     DATETIME,
    updated_at              DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_up_user_module (user_id, module_id),
    CONSTRAINT fk_up_user   FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
    CONSTRAINT fk_up_module FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE terminal_sessions (
    id              VARCHAR(36)  NOT NULL,
    user_id         VARCHAR(36)  NOT NULL UNIQUE,
    container_id    VARCHAR(100) NOT NULL,
    session_token   VARCHAR(100) NOT NULL UNIQUE,
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_active_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    terminated_at   DATETIME,
    PRIMARY KEY (id),
    INDEX idx_ts_token (session_token),
    CONSTRAINT fk_ts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
