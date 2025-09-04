-- Town Storage (HHRP) — per-character, per-town slot tracking
CREATE TABLE IF NOT EXISTS `biggies_storage` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `charidentifier` VARCHAR(60) NOT NULL,
  `town_key` VARCHAR(64) NOT NULL,
  `slots` INT NOT NULL DEFAULT 200,
  UNIQUE KEY `uniq_char_town` (`charidentifier`, `town_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
