-- =============================================================================
-- ZALCO INTERIM - DATABASE SCHEMA
-- Execute ce script dans ta base de donnees MySQL
-- =============================================================================

CREATE TABLE IF NOT EXISTS `interim_stats` (
    `identifier` VARCHAR(60) NOT NULL,
    `job_stats` LONGTEXT DEFAULT '{}' COMMENT 'JSON avec stats par job',
    `total_earnings` INT DEFAULT 0 COMMENT 'Total argent gagne',
    `total_shifts` INT DEFAULT 0 COMMENT 'Nombre total de shifts',
    `total_tasks` INT DEFAULT 0 COMMENT 'Nombre total de taches',
    `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Index pour performances
CREATE INDEX idx_interim_stats_updated ON interim_stats(last_updated);

-- =============================================================================
-- STRUCTURE job_stats JSON
-- =============================================================================
-- {
--     "mineur": {
--         "xp": 150,
--         "level": 2,
--         "shifts": 10,
--         "tasks": 85,
--         "earnings": 12500
--     },
--     "bucheron": {
--         "xp": 50,
--         "level": 1,
--         "shifts": 5,
--         "tasks": 42,
--         "earnings": 6200
--     }
-- }
