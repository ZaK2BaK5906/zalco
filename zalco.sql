-- ============================================
-- TABLE ZALCO - STATISTIQUES DE CONTREBANDE
-- ============================================

CREATE TABLE IF NOT EXISTS `alcohol_stats` (
    `identifier` VARCHAR(60) PRIMARY KEY,
    `experience` INT DEFAULT 0,
    `level` INT DEFAULT 0,
    `total_farmed` INT DEFAULT 0,
    `total_processed` INT DEFAULT 0,
    `total_sold` INT DEFAULT 0,
    `money_earned` INT DEFAULT 0,
    `farmed_items` TEXT DEFAULT '{}',
    `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_level` (`level`),
    INDEX `idx_experience` (`experience`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
