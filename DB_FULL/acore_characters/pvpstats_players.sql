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

-- Dumping structure for table acore_characters.pvpstats_players
DROP TABLE IF EXISTS `pvpstats_players`;
CREATE TABLE IF NOT EXISTS `pvpstats_players` (
  `battleground_id` bigint unsigned NOT NULL,
  `character_guid` int unsigned NOT NULL,
  `winner` bit(1) NOT NULL,
  `score_killing_blows` mediumint unsigned NOT NULL,
  `score_deaths` mediumint unsigned NOT NULL,
  `score_honorable_kills` mediumint unsigned NOT NULL,
  `score_bonus_honor` mediumint unsigned NOT NULL,
  `score_damage_done` mediumint unsigned NOT NULL,
  `score_healing_done` mediumint unsigned NOT NULL,
  `attr_1` mediumint unsigned NOT NULL DEFAULT '0',
  `attr_2` mediumint unsigned NOT NULL DEFAULT '0',
  `attr_3` mediumint unsigned NOT NULL DEFAULT '0',
  `attr_4` mediumint unsigned NOT NULL DEFAULT '0',
  `attr_5` mediumint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`battleground_id`,`character_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table acore_characters.pvpstats_players: ~40 rows (approximately)
DELETE FROM `pvpstats_players`;
INSERT INTO `pvpstats_players` (`battleground_id`, `character_guid`, `winner`, `score_killing_blows`, `score_deaths`, `score_honorable_kills`, `score_bonus_honor`, `score_damage_done`, `score_healing_done`, `attr_1`, `attr_2`, `attr_3`, `attr_4`, `attr_5`) VALUES
	(3, 85, b'1', 103, 1, 306, 7296, 288176, 18, 1, 0, 0, 0, 0),
	(4, 44, b'0', 11, 2, 18, 1298, 32386, 2819, 1, 0, 0, 0, 0),
	(5, 44, b'1', 13, 1, 18, 3774, 27801, 630, 1, 0, 0, 0, 0),
	(6, 44, b'1', 123, 0, 278, 7532, 478104, 0, 1, 0, 0, 0, 0),
	(7, 44, b'1', 38, 4, 73, 2306, 88285, 2200, 0, 0, 0, 0, 0),
	(8, 44, b'1', 320, 3, 587, 13854, 842613, 23893, 0, 0, 0, 0, 0),
	(9, 44, b'1', 59, 2, 84, 6673, 191816, 5290, 8, 1, 0, 0, 0),
	(10, 44, b'1', 189, 4, 313, 9194, 773016, 8032, 0, 0, 3, 0, 0),
	(11, 44, b'1', 239, 9, 455, 13245, 731194, 22997, 0, 0, 1, 0, 0),
	(12, 44, b'1', 260, 4, 582, 16038, 481972, 8738, 0, 0, 0, 0, 0),
	(13, 44, b'1', 244, 6, 552, 14751, 279650, 5177, 0, 0, 0, 0, 0),
	(14, 44, b'1', 35, 0, 50, 2101, 113789, 11630, 3, 0, 0, 0, 0),
	(15, 44, b'1', 35, 8, 66, 6045, 78505, 16051, 2, 0, 0, 0, 0),
	(16, 41, b'1', 8, 1, 14, 488, 1780, 850, 3, 0, 0, 0, 0),
	(17, 44, b'1', 36, 3, 58, 3999, 123586, 6894, 3, 1, 0, 0, 0),
	(18, 41, b'1', 0, 0, 4, 266, 31, 0, 3, 0, 0, 0, 0),
	(19, 44, b'1', 7, 1, 14, 1488, 11652, 1872, 3, 0, 0, 0, 0),
	(20, 44, b'0', 47, 1, 90, 5984, 230805, 7806, 0, 0, 0, 0, 0),
	(21, 41, b'1', 58, 12, 94, 3357, 70329, 2954, 5, 1, 0, 0, 0),
	(22, 41, b'1', 22, 8, 41, 362, 13223, 3294, 3, 0, 0, 0, 0),
	(23, 41, b'1', 37, 3, 75, 463, 63134, 17822, 3, 0, 0, 0, 0),
	(24, 41, b'1', 68, 6, 108, 664, 262301, 19248, 6, 0, 0, 0, 0),
	(25, 41, b'1', 2, 0, 7, 203, 722, 4910, 3, 0, 0, 0, 0),
	(26, 41, b'1', 0, 0, 0, 189, 6911, 7023, 3, 0, 0, 0, 0),
	(27, 41, b'1', 2, 3, 4, 217, 7770, 4501, 3, 0, 0, 0, 0),
	(28, 41, b'1', 30, 5, 44, 400, 94151, 32547, 5, 1, 0, 0, 0),
	(29, 41, b'1', 213, 2, 486, 2702, 593188, 6972, 1, 0, 1, 0, 0),
	(30, 41, b'1', 52, 0, 120, 810, 920680, 3788, 0, 0, 0, 0, 0),
	(31, 41, b'0', 1, 0, 1, 232, 7262, 0, 0, 0, 0, 0, 0),
	(32, 41, b'0', 0, 0, 0, 232, 0, 0, 0, 0, 0, 0, 0),
	(33, 41, b'1', 46, 1, 84, 1241, 220150, 9180, 2, 1, 0, 0, 0),
	(34, 41, b'1', 121, 8, 218, 1746, 607690, 36283, 2, 0, 0, 0, 0),
	(35, 41, b'1', 26, 4, 45, 1053, 209514, 10939, 1, 1, 0, 0, 0),
	(36, 41, b'1', 42, 4, 76, 880, 287074, 21895, 2, 1, 0, 0, 0),
	(37, 41, b'1', 70, 3, 116, 1068, 361867, 16980, 7, 2, 0, 0, 0),
	(38, 41, b'1', 69, 2, 136, 1816, 876406, 13955, 4, 0, 2, 0, 0),
	(39, 41, b'1', 0, 0, 0, 532, 0, 0, 5, 0, 0, 0, 0),
	(40, 41, b'1', 169, 8, 309, 2036, 922781, 59203, 1, 0, 0, 0, 0),
	(41, 41, b'1', 15, 1, 29, 4075, 53010, 5528, 3, 1, 0, 0, 0),
	(42, 41, b'1', 7, 0, 83, 2396, 17114, 0, 3, 0, 1, 0, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
