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

-- Dumping structure for table acore_characters.players_reports_status
DROP TABLE IF EXISTS `players_reports_status`;
CREATE TABLE IF NOT EXISTS `players_reports_status` (
  `guid` int unsigned NOT NULL DEFAULT '0',
  `creation_time` int unsigned NOT NULL DEFAULT '0',
  `average` float NOT NULL DEFAULT '0',
  `total_reports` bigint unsigned NOT NULL DEFAULT '0',
  `speed_reports` bigint unsigned NOT NULL DEFAULT '0',
  `fly_reports` bigint unsigned NOT NULL DEFAULT '0',
  `jump_reports` bigint unsigned NOT NULL DEFAULT '0',
  `waterwalk_reports` bigint unsigned NOT NULL DEFAULT '0',
  `teleportplane_reports` bigint unsigned NOT NULL DEFAULT '0',
  `climb_reports` bigint unsigned NOT NULL DEFAULT '0',
  `teleport_reports` bigint unsigned NOT NULL DEFAULT '0',
  `ignorecontrol_reports` bigint unsigned NOT NULL DEFAULT '0',
  `zaxis_reports` bigint unsigned NOT NULL DEFAULT '0',
  `antiswim_reports` bigint unsigned NOT NULL DEFAULT '0',
  `gravity_reports` bigint unsigned NOT NULL DEFAULT '0',
  `antiknockback_reports` bigint unsigned NOT NULL DEFAULT '0',
  `no_fall_damage_reports` bigint unsigned NOT NULL DEFAULT '0',
  `op_ack_hack_reports` bigint unsigned NOT NULL DEFAULT '0',
  `counter_measures_reports` bigint unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_characters.players_reports_status: ~1 rows (approximately)
DELETE FROM `players_reports_status`;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
