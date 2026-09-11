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

-- Dumping structure for table acore_characters.characters_npcbot_group_member
DROP TABLE IF EXISTS `characters_npcbot_group_member`;
CREATE TABLE IF NOT EXISTS `characters_npcbot_group_member` (
  `guid` int unsigned NOT NULL,
  `entry` int unsigned NOT NULL,
  `memberFlags` tinyint unsigned NOT NULL DEFAULT '0',
  `subgroup` tinyint unsigned NOT NULL DEFAULT '0',
  `roles` tinyint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- Dumping data for table acore_characters.characters_npcbot_group_member: ~28 rows (approximately)
DELETE FROM `characters_npcbot_group_member`;
INSERT INTO `characters_npcbot_group_member` (`guid`, `entry`, `memberFlags`, `subgroup`, `roles`) VALUES
	(4, 70072, 0, 0, 0),
	(1, 70211, 0, 1, 0),
	(1, 70251, 0, 3, 0),
	(1, 70377, 0, 0, 0),
	(1, 70572, 0, 3, 0),
	(1, 70823, 0, 4, 0),
	(1, 70847, 0, 4, 0),
	(1, 70897, 0, 1, 0),
	(1, 80265, 0, 0, 0),
	(1, 81351, 0, 0, 0),
	(1, 81523, 0, 2, 0),
	(1, 81524, 0, 3, 0),
	(4, 84050, 0, 0, 0),
	(1, 84060, 0, 4, 0),
	(4, 84113, 0, 0, 0),
	(1, 84128, 0, 3, 0),
	(1, 84136, 0, 3, 0),
	(1, 84163, 0, 2, 0),
	(1, 84171, 0, 2, 0),
	(1, 84179, 0, 2, 0),
	(1, 84213, 0, 2, 0),
	(1, 84238, 0, 1, 0),
	(1, 84248, 0, 1, 0),
	(1, 84251, 0, 4, 0),
	(1, 87052, 0, 0, 0),
	(1, 88138, 0, 4, 0),
	(4, 88372, 0, 0, 0),
	(1, 88461, 0, 1, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
