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

-- Dumping structure for table store.store_categories
DROP TABLE IF EXISTS `store_categories`;
CREATE TABLE IF NOT EXISTS `store_categories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(765) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `icon` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `requiredRank` int DEFAULT NULL,
  `flags` int unsigned NOT NULL DEFAULT '0' COMMENT '1 = "Sales" category. Automatically populate all items that are on sale.  2 = "New" category.',
  `enabled` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table store.store_categories: ~10 rows (approximately)
DELETE FROM `store_categories`;
INSERT INTO `store_categories` (`id`, `name`, `icon`, `requiredRank`, `flags`, `enabled`) VALUES
	(1, 'Featured', 'inv_helmet_96', 0, 2, 0),
	(2, 'Bargain Outlet', 'inv_misc_toy_07', 0, 1, 0),
	(3, 'Titles', 'inv_scroll_11', 0, 0, 0),
	(4, 'Items', 'ability_warrior_challange', 0, 0, 1),
	(5, 'Mounts & Pets', 'inv_box_petcarrier_01', 0, 0, 1),
	(6, 'Level Boosts', 'spell_holy_surgeoflight', 0, 0, 0),
	(7, 'Transmogs', 'inv_shirt_blue_01', 0, 0, 1),
	(8, 'Buff/Resistance', 'spell_holy_holynova', 0, 0, 0),
	(9, 'Services', 'vas_charactertransfer', 0, 0, 1),
	(11, 'Currencies', 'inv_misc_coin_02', 0, 0, 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
