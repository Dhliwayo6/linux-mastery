CREATE TABLE projects (
    id          VARCHAR(36)  NOT NULL,
    module_id   VARCHAR(36)  NOT NULL UNIQUE,
    title       VARCHAR(255) NOT NULL,
    brief_md    MEDIUMTEXT   NOT NULL,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_projects_module FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_test_cases (
    id          VARCHAR(36)  NOT NULL,
    project_id  VARCHAR(36)  NOT NULL,
    description VARCHAR(500) NOT NULL,
    weight      INT          NOT NULL,
    test_type   ENUM('EXIT_CODE', 'STDOUT_CONTAINS', 'STDOUT_MATCHES', 'COMMAND_USED') NOT NULL,
    expected    VARCHAR(500) NOT NULL,
    order_index INT          NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_ptc_project (project_id),
    CONSTRAINT fk_ptc_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_submissions (
    id              VARCHAR(36)  NOT NULL,
    user_id         VARCHAR(36)  NOT NULL,
    project_id      VARCHAR(36)  NOT NULL,
    script_content  MEDIUMTEXT   NOT NULL,
    score           DECIMAL(5,2) NOT NULL,
    test_results_json JSON       NOT NULL,
    memo_md         MEDIUMTEXT   NOT NULL,
    attempt_number  INT          NOT NULL,
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_ps_user_project (user_id, project_id),
    CONSTRAINT fk_ps_user    FOREIGN KEY (user_id)    REFERENCES users(id)    ON DELETE CASCADE,
    CONSTRAINT fk_ps_project FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
