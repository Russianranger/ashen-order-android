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

-- Dumping structure for table acore_characters.pvpstats_battlegrounds
DROP TABLE IF EXISTS `pvpstats_battlegrounds`;
CREATE TABLE IF NOT EXISTS `pvpstats_battlegrounds` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `winner_faction` tinyint NOT NULL,
  `bracket_id` tinyint unsigned NOT NULL,
  `type` tinyint unsigned NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=latin1;

-- Dumping data for table acore_characters.pvpstats_battlegrounds: ~42 rows (approximately)
DELETE FROM `pvpstats_battlegrounds`;
INSERT INTO `pvpstats_battlegrounds` (`id`, `winner_faction`, `bracket_id`, `type`, `date`) VALUES
	(1, 0, 6, 2, '2023-05-26 12:20:51'),
	(2, 0, 6, 3, '2023-05-26 18:17:08'),
	(3, 1, 6, 1, '2023-08-17 20:30:51'),
	(4, 0, 6, 3, '2023-08-27 19:22:14'),
	(5, 1, 6, 3, '2023-08-27 20:13:28'),
	(6, 1, 6, 1, '2023-10-03 01:22:31'),
	(7, 1, 6, 1, '2023-10-03 03:46:06'),
	(8, 1, 6, 1, '2023-10-04 00:33:54'),
	(9, 1, 6, 3, '2023-10-07 06:58:23'),
	(10, 1, 6, 1, '2023-10-07 08:46:21'),
	(11, 1, 6, 1, '2023-10-17 03:31:42'),
	(12, 1, 6, 1, '2023-10-17 23:12:56'),
	(13, 1, 6, 1, '2023-10-24 00:41:17'),
	(14, 1, 6, 2, '2023-10-26 10:53:54'),
	(15, 1, 6, 2, '2023-10-29 00:49:31'),
	(16, 1, 1, 2, '2023-11-11 00:44:32'),
	(17, 1, 6, 2, '2023-11-16 03:34:17'),
	(18, 1, 1, 2, '2023-11-20 00:43:50'),
	(19, 1, 6, 2, '2023-11-30 10:11:55'),
	(20, 0, 6, 3, '2023-12-14 23:43:13'),
	(21, 1, 2, 3, '2024-01-01 16:39:56'),
	(22, 1, 3, 3, '2024-01-12 10:47:37'),
	(23, 1, 5, 2, '2024-03-11 21:53:41'),
	(24, 1, 5, 3, '2024-03-13 22:37:45'),
	(25, 1, 5, 2, '2024-03-17 23:53:08'),
	(26, 1, 5, 2, '2024-03-23 19:57:11'),
	(27, 1, 5, 2, '2024-03-29 22:33:07'),
	(28, 1, 5, 3, '2024-03-29 23:35:00'),
	(29, 1, 6, 1, '2024-04-09 02:37:10'),
	(30, 1, 6, 1, '2024-04-10 21:52:14'),
	(31, 0, 6, 1, '2024-04-10 22:30:21'),
	(32, 0, 6, 1, '2024-04-10 22:35:08'),
	(33, 1, 6, 3, '2024-05-07 23:29:49'),
	(34, 1, 6, 2, '2024-05-09 01:50:43'),
	(35, 1, 6, 3, '2024-05-09 15:24:11'),
	(36, 1, 6, 3, '2024-05-09 16:19:03'),
	(37, 1, 6, 3, '2024-05-09 16:41:42'),
	(38, 1, 6, 1, '2024-05-22 10:39:30'),
	(39, 1, 6, 3, '2024-05-22 11:28:55'),
	(40, 1, 6, 2, '2024-05-24 12:04:47'),
	(41, 1, 6, 2, '2024-05-29 11:40:02'),
	(42, 1, 6, 1, '2024-07-17 20:04:59');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
