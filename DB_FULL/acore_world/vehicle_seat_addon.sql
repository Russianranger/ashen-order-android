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

-- Dumping structure for table acore_world.vehicle_seat_addon
DROP TABLE IF EXISTS `vehicle_seat_addon`;
CREATE TABLE IF NOT EXISTS `vehicle_seat_addon` (
  `SeatEntry` int unsigned NOT NULL COMMENT 'VehicleSeatEntry.dbc identifier',
  `SeatOrientation` float DEFAULT '0' COMMENT 'Seat Orientation override value',
  `ExitParamX` float DEFAULT '0',
  `ExitParamY` float DEFAULT '0',
  `ExitParamZ` float DEFAULT '0',
  `ExitParamO` float DEFAULT '0',
  `ExitParamValue` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`SeatEntry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table acore_world.vehicle_seat_addon: ~29 rows (approximately)
DELETE FROM `vehicle_seat_addon`;
INSERT INTO `vehicle_seat_addon` (`SeatEntry`, `SeatOrientation`, `ExitParamX`, `ExitParamY`, `ExitParamZ`, `ExitParamO`, `ExitParamValue`) VALUES
	(861, 0, -2, 2, 0, 0, 1),
	(862, 0, -2, 3, 0, 0, 1),
	(1472, 0, 2802.18, 7054.91, -0.6, 4.67, 2),
	(1473, 0, 2802.18, 7054.91, -0.6, 4.67, 2),
	(1474, 0, 2802.18, 7054.91, -0.6, 4.67, 2),
	(1475, 0, 2802.18, 7054.91, -0.6, 4.67, 2),
	(1476, 0, 2802.18, 7054.91, -0.6, 4.67, 2),
	(1682, 0, 6708.17, 5130.74, -19.388, 4.83608, 2),
	(2097, 0, 12, 0, 4, 0, 1),
	(2172, 0, 40, 0, 0, 0, 1),
	(2178, 0, -3.3, 5, 0, 3.1326, 1),
	(2179, 0, -5.9, -4.9, 0, 3.1326, 1),
	(2180, 0, -7.9, 0.02, 0, 3.1326, 1),
	(2764, 0, -2, 2, 0, 0, 1),
	(2765, 0, -2, -2, 0, 0, 1),
	(2767, 0, -2, 2, 0, 0, 1),
	(2768, 0, -2, -2, 0, 0, 1),
	(2771, 0, -2, -2, 0, 0, 1),
	(2772, 0, -2, 2, 0, 0, 1),
	(3129, 0, 0, -2, 0, 0, 1),
	(3690, 0, 1776, -24, 448.75, 0, 2),
	(3691, 0, 1776, -24, 448.75, 0, 2),
	(3692, 0, 1776, -24, 448.75, 0, 2),
	(6446, 0, -1, 4, 3, 0, 1),
	(6447, 0, 1, 4, 3, 0, 1),
	(7326, 0, -1, 4, 3, 0, 1),
	(7327, 0, 1, 4, 3, 0, 1),
	(7328, 0, -1, 4, 3, 0, 1),
	(7329, 0, 1, 4, 3, 0, 1);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
