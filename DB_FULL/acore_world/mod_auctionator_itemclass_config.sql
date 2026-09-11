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

-- Dumping structure for table acore_world.mod_auctionator_itemclass_config
DROP TABLE IF EXISTS `mod_auctionator_itemclass_config`;
CREATE TABLE IF NOT EXISTS `mod_auctionator_itemclass_config` (
  `class` int NOT NULL COMMENT 'item class',
  `subclass` int NOT NULL COMMENT 'item subclass',
  `bonding` int NOT NULL COMMENT 'bonding level that is the minimum for this class. 2 means greens (for gear), 1 means whites (for bags).',
  `max_count` int NOT NULL DEFAULT '1' COMMENT 'The maximum number of unique versions of these items to add to the house. Low numbers keep items like weapons from having lots of dups. High nubmers are useful for crafting mats.',
  `stack_count` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`class`,`subclass`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table acore_world.mod_auctionator_itemclass_config: ~101 rows (approximately)
DELETE FROM `mod_auctionator_itemclass_config`;
INSERT INTO `mod_auctionator_itemclass_config` (`class`, `subclass`, `bonding`, `max_count`, `stack_count`) VALUES
	(0, 0, 0, 2, 5),
	(0, 1, 0, 2, 10),
	(0, 2, 0, 2, 5),
	(0, 3, 0, 2, 5),
	(0, 4, 0, 2, 1),
	(0, 5, 0, 3, 20),
	(0, 6, 0, 2, 1),
	(0, 7, 0, 2, 20),
	(1, 0, 0, 3, 1),
	(1, 1, 0, 2, 1),
	(1, 2, 0, 2, 1),
	(1, 3, 0, 2, 1),
	(1, 4, 0, 2, 1),
	(1, 5, 0, 2, 1),
	(1, 6, 0, 2, 1),
	(1, 7, 0, 2, 1),
	(1, 8, 0, 2, 1),
	(2, 0, 1, 1, 1),
	(2, 1, 1, 1, 1),
	(2, 2, 1, 1, 1),
	(2, 3, 1, 1, 1),
	(2, 4, 1, 1, 1),
	(2, 5, 1, 1, 1),
	(2, 6, 1, 1, 1),
	(2, 7, 1, 1, 1),
	(2, 8, 1, 1, 1),
	(2, 9, 1, 1, 1),
	(2, 10, 1, 1, 1),
	(2, 11, 1, 1, 1),
	(2, 12, 1, 1, 1),
	(2, 13, 1, 1, 1),
	(2, 14, 1, 1, 1),
	(2, 15, 1, 1, 1),
	(2, 16, 1, 1, 1),
	(2, 17, 1, 1, 1),
	(2, 18, 1, 1, 1),
	(2, 19, 1, 1, 1),
	(2, 20, 1, 1, 1),
	(3, 0, 0, 1, 1),
	(3, 1, 0, 1, 1),
	(3, 2, 0, 1, 1),
	(3, 3, 0, 1, 1),
	(3, 4, 0, 1, 1),
	(3, 5, 0, 1, 1),
	(3, 6, 0, 1, 1),
	(3, 7, 0, 1, 1),
	(3, 8, 0, 1, 1),
	(4, 0, 1, 1, 1),
	(4, 1, 1, 1, 1),
	(4, 2, 1, 1, 1),
	(4, 3, 1, 1, 1),
	(4, 4, 1, 1, 1),
	(4, 5, 1, 1, 1),
	(4, 6, 1, 1, 1),
	(4, 7, 1, 1, 1),
	(4, 8, 1, 1, 1),
	(4, 9, 1, 1, 1),
	(4, 10, 1, 1, 1),
	(5, 0, 0, 1, 5),
	(6, 0, 1, 1, 1),
	(6, 1, 1, 1, 1),
	(6, 2, 1, 1, 1),
	(6, 3, 1, 1, 1),
	(6, 4, 1, 1, 1),
	(7, 0, 0, 3, 20),
	(7, 1, 0, 3, 20),
	(7, 2, 0, 3, 20),
	(7, 4, 0, 3, 20),
	(7, 5, 0, 3, 20),
	(7, 6, 0, 3, 20),
	(7, 7, 0, 3, 20),
	(7, 8, 0, 3, 20),
	(7, 9, 0, 3, 20),
	(7, 10, 0, 3, 20),
	(7, 11, 0, 3, 20),
	(7, 12, 0, 3, 20),
	(7, 13, 0, 3, 20),
	(7, 14, 0, 3, 5),
	(7, 15, 0, 3, 5),
	(9, 0, 0, 1, 1),
	(9, 1, 0, 1, 1),
	(9, 2, 0, 1, 1),
	(9, 3, 0, 1, 1),
	(9, 4, 0, 1, 1),
	(9, 5, 0, 1, 1),
	(9, 6, 0, 1, 1),
	(9, 7, 0, 1, 1),
	(9, 8, 0, 1, 1),
	(9, 9, 0, 1, 1),
	(9, 10, 0, 1, 1),
	(12, 0, 0, 1, 1),
	(16, 1, 0, 2, 1),
	(16, 2, 0, 2, 1),
	(16, 3, 0, 2, 1),
	(16, 4, 0, 2, 1),
	(16, 5, 0, 2, 1),
	(16, 6, 0, 2, 1),
	(16, 7, 0, 2, 1),
	(16, 8, 0, 2, 1),
	(16, 9, 0, 2, 1),
	(16, 11, 0, 2, 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
