CREATE TABLE quiz_questions (
    id              VARCHAR(36)  NOT NULL,
    section_id      VARCHAR(36)  NOT NULL,
    question_text   TEXT         NOT NULL,
    question_type   ENUM('MULTIPLE_CHOICE', 'TRUE_FALSE', 'FILL_IN_BLANK') NOT NULL,
    options_json    JSON,
    correct_answer  VARCHAR(500) NOT NULL,
    explanation     TEXT         NOT NULL,
    order_index     INT          NOT NULL,
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_qq_section (section_id),
    CONSTRAINT fk_qq_section FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE quiz_attempts (
    id          VARCHAR(36)  NOT NULL,
    user_id     VARCHAR(36)  NOT NULL,
    section_id  VARCHAR(36)  NOT NULL,
    answers_json JSON        NOT NULL,
    score       DECIMAL(5,2) NOT NULL,
    passed      BOOLEAN      NOT NULL,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_qa_user_section (user_id, section_id),
    CONSTRAINT fk_qa_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE section_completions (
    id              VARCHAR(36) NOT NULL,
    user_id         VARCHAR(36) NOT NULL,
    section_id      VARCHAR(36) NOT NULL,
    completed_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_sc_user_section (user_id, section_id),
    CONSTRAINT fk_sc_user    FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
    CONSTRAINT fk_sc_section FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
