CREATE TABLE assessment_questions (
    id              VARCHAR(36)  NOT NULL,
    module_id       VARCHAR(36)  NOT NULL,
    question_text   TEXT         NOT NULL,
    options_json    JSON         NOT NULL,
    correct_answer  VARCHAR(10)  NOT NULL,
    explanation     TEXT         NOT NULL,
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_aq_module (module_id),
    CONSTRAINT fk_aq_module FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE assessment_attempts (
    id              VARCHAR(36)  NOT NULL,
    user_id         VARCHAR(36)  NOT NULL,
    module_id       VARCHAR(36)  NOT NULL,
    answers_json    JSON         NOT NULL,
    score           DECIMAL(5,2) NOT NULL,
    passed          BOOLEAN      NOT NULL,
    duration_secs   INT          NOT NULL,
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_aa_user_module (user_id, module_id),
    CONSTRAINT fk_aa_user   FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
    CONSTRAINT fk_aa_module FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
