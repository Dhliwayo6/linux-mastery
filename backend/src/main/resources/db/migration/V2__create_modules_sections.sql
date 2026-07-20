CREATE TABLE modules (
    id          VARCHAR(36)  NOT NULL,
    slug        VARCHAR(100) NOT NULL UNIQUE,
    title       VARCHAR(255) NOT NULL,
    description TEXT         NOT NULL,
    level       VARCHAR(20)  NOT NULL,
    order_index INT          NOT NULL,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_modules_order (order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sections (
    id          VARCHAR(36)  NOT NULL,
    module_id   VARCHAR(36)  NOT NULL,
    title       VARCHAR(255) NOT NULL,
    content_md  MEDIUMTEXT   NOT NULL,
    order_index INT          NOT NULL,
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_sections_module_order (module_id, order_index),
    CONSTRAINT fk_sections_module FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
