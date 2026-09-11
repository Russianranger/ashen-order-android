-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.4.2 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.10.0.7013
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Dumping structure for table acore_characters.characters_npcbot_settings
DROP TABLE IF EXISTS `characters_npcbot_settings`;
CREATE TABLE IF NOT EXISTS `characters_npcbot_settings` (
  `owner` int unsigned NOT NULL,
  `dist_follow` tinyint unsigned NOT NULL DEFAULT '30',
  `dist_attack` tinyint unsigned NOT NULL DEFAULT '0',
  `attack_range_mode` tinyint unsigned NOT NULL DEFAULT '1',
  `attack_angle_mode` tinyint unsigned NOT NULL DEFAULT '1',
  `engage_delay_dps` int unsigned NOT NULL DEFAULT '0',
  `engage_delay_heal` int unsigned NOT NULL DEFAULT '0',
  `flags` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table acore_characters.characters_npcbot_settings: ~8 rows (approximately)
DELETE FROM `characters_npcbot_settings`;
INSERT INTO `characters_npcbot_settings` (`owner`, `dist_follow`, `dist_attack`, `attack_range_mode`, `attack_angle_mode`, `engage_delay_dps`, `engage_delay_heal`, `flags`) VALUES
	(41, 35, 0, 1, 1, 0, 0, 0),
	(139, 35, 0, 1, 1, 0, 0, 0),
	(171, 50, 40, 3, 1, 0, 0, 0),
	(186, 35, 0, 1, 1, 0, 0, 0),
	(187, 35, 0, 1, 1, 0, 0, 0),
	(189, 35, 0, 1, 1, 0, 0, 0),
	(191, 35, 0, 1, 1, 0, 0, 0),
	(199, 35, 0, 1, 1, 0, 0, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
