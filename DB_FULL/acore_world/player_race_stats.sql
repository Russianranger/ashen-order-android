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

-- Dumping structure for table acore_world.player_race_stats
DROP TABLE IF EXISTS `player_race_stats`;
CREATE TABLE IF NOT EXISTS `player_race_stats` (
  `Race` tinyint unsigned NOT NULL,
  `Strength` int NOT NULL DEFAULT '0',
  `Agility` int NOT NULL DEFAULT '0',
  `Stamina` int NOT NULL DEFAULT '0',
  `Intellect` int NOT NULL DEFAULT '0',
  `Spirit` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`Race`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci PACK_KEYS=0 COMMENT='Stores race stats.';

-- Dumping data for table acore_world.player_race_stats: 21 rows
DELETE FROM `player_race_stats`;
/*!40000 ALTER TABLE `player_race_stats` DISABLE KEYS */;
INSERT INTO `player_race_stats` (`Race`, `Strength`, `Agility`, `Stamina`, `Intellect`, `Spirit`) VALUES
	(11, 4, 2, 3, 3, 5),
	(10, 2, 5, 3, 5, 1),
	(8, 4, 5, 3, -1, 4),
	(7, -2, 5, 3, 6, 3),
	(6, 7, -1, 4, -1, 7),
	(5, 2, 1, 3, 1, 8),
	(4, -1, 7, 3, 3, 3),
	(3, 8, -1, 4, 2, 2),
	(2, 6, 0, 4, 0, 5),
	(1, 3, 3, 3, 3, 3),
	(9, -2, 5, 3, 2, 3),
	(12, 0, 5, 3, 2, 1),
	(13, -2, 5, 7, 2, 3),
	(14, -1, 3, 3, 5, 3),
	(15, 6, 2, 4, 2, 5),
	(16, 3, 3, 3, 2, 3),
	(17, 3, 3, 3, 2, 3),
	(18, 3, 3, 5, 3, 3),
	(19, 4, 2, 3, 2, 5),
	(20, -1, 7, 3, 2, 3),
	(21, 2, 5, 3, 2, 1);
/*!40000 ALTER TABLE `player_race_stats` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
