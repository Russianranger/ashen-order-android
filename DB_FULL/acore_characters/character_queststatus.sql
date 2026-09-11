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

-- Dumping structure for table acore_characters.character_queststatus
DROP TABLE IF EXISTS `character_queststatus`;
CREATE TABLE IF NOT EXISTS `character_queststatus` (
  `guid` int unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `quest` int unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  `status` tinyint unsigned NOT NULL DEFAULT '0',
  `explored` tinyint unsigned NOT NULL DEFAULT '0',
  `timer` int unsigned NOT NULL DEFAULT '0',
  `mobcount1` smallint unsigned NOT NULL DEFAULT '0',
  `mobcount2` smallint unsigned NOT NULL DEFAULT '0',
  `mobcount3` smallint unsigned NOT NULL DEFAULT '0',
  `mobcount4` smallint unsigned NOT NULL DEFAULT '0',
  `itemcount1` smallint unsigned NOT NULL DEFAULT '0',
  `itemcount2` smallint unsigned NOT NULL DEFAULT '0',
  `itemcount3` smallint unsigned NOT NULL DEFAULT '0',
  `itemcount4` smallint unsigned NOT NULL DEFAULT '0',
  `itemcount5` smallint unsigned NOT NULL DEFAULT '0',
  `itemcount6` smallint unsigned NOT NULL DEFAULT '0',
  `playercount` smallint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`quest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Player System';

-- Dumping data for table acore_characters.character_queststatus: ~38 rows (approximately)
DELETE FROM `character_queststatus`;
INSERT INTO `character_queststatus` (`guid`, `quest`, `status`, `explored`, `timer`, `mobcount1`, `mobcount2`, `mobcount3`, `mobcount4`, `itemcount1`, `itemcount2`, `itemcount3`, `itemcount4`, `itemcount5`, `itemcount6`, `playercount`) VALUES
	(41, 969, 3, 0, 1712907394, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 4441, 3, 0, 1712071622, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 5050, 1, 0, 1714197715, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0),
	(41, 5159, 1, 0, 1713339976, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0),
	(41, 5214, 3, 0, 1713861095, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 5247, 3, 0, 1715105457, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 5527, 3, 0, 1711615350, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 6607, 3, 0, 1716593621, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 7509, 3, 0, 1719331225, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 8280, 3, 0, 1716678113, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 8284, 3, 0, 1716676077, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 8304, 3, 0, 1717654105, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 8318, 3, 0, 1716695693, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 8320, 3, 0, 1716675973, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 8361, 3, 0, 1716675973, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 8921, 3, 0, 1725557042, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0),
	(41, 9587, 1, 0, 1723935127, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0),
	(41, 10254, 1, 0, 1739391591, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(41, 881431, 3, 0, 1739438727, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
	(44, 437, 1, 1, 1723818982, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0),
	(44, 10291, 1, 0, 1723819260, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(44, 24589, 3, 0, 1719289823, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(159, 53115, 3, 0, 1708789289, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 4743, 3, 0, 1739693537, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 4788, 3, 0, 1739869698, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 4974, 3, 0, 1738998482, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 4987, 1, 0, 1739603300, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0),
	(171, 5206, 3, 0, 1739868824, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0),
	(171, 5212, 3, 0, 1739862473, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 5529, 3, 0, 1739862473, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 5781, 3, 0, 1739869392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 6024, 3, 0, 1739867158, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 6041, 3, 0, 1739862805, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 8317, 3, 0, 1739295730, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 8949, 3, 0, 1739869926, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
	(171, 9665, 3, 0, 1739865763, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0),
	(186, 7629, 1, 0, 1725392450, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
