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

-- Dumping structure for table acore_world.player_xp_for_level
DROP TABLE IF EXISTS `player_xp_for_level`;
CREATE TABLE IF NOT EXISTS `player_xp_for_level` (
  `Level` tinyint unsigned NOT NULL,
  `Experience` int unsigned NOT NULL,
  PRIMARY KEY (`Level`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_world.player_xp_for_level: 79 rows
DELETE FROM `player_xp_for_level`;
/*!40000 ALTER TABLE `player_xp_for_level` DISABLE KEYS */;
INSERT INTO `player_xp_for_level` (`Level`, `Experience`) VALUES
	(1, 451),
	(2, 1014),
	(3, 1578),
	(4, 2367),
	(5, 3156),
	(6, 4057),
	(7, 5072),
	(8, 6086),
	(9, 7326),
	(10, 9250),
	(11, 10711),
	(12, 12294),
	(13, 13876),
	(14, 15701),
	(15, 17527),
	(16, 19475),
	(17, 21544),
	(18, 23613),
	(19, 25925),
	(20, 28238),
	(21, 30672),
	(22, 33228),
	(23, 35785),
	(24, 38584),
	(25, 41383),
	(26, 44305),
	(27, 47347),
	(28, 50391),
	(29, 53920),
	(30, 57694),
	(31, 61832),
	(32, 66336),
	(33, 71325),
	(34, 76438),
	(35, 81672),
	(36, 87148),
	(37, 92626),
	(38, 98347),
	(39, 104311),
	(40, 110397),
	(41, 116604),
	(42, 122933),
	(43, 129384),
	(44, 136079),
	(45, 143017),
	(46, 149954),
	(47, 157136),
	(48, 164439),
	(49, 171863),
	(50, 179532),
	(51, 187321),
	(52, 195233),
	(53, 203388),
	(54, 211664),
	(55, 220063),
	(56, 228704),
	(57, 237346),
	(58, 246231),
	(59, 255361),
	(60, 601277),
	(61, 647687),
	(62, 692429),
	(63, 732888),
	(64, 768952),
	(65, 800395),
	(66, 827331),
	(67, 849420),
	(68, 866550),
	(69, 878722),
	(70, 1717323),
	(71, 1735129),
	(72, 1753274),
	(73, 1771419),
	(74, 1789563),
	(75, 1807933),
	(76, 1826529),
	(77, 1845350),
	(78, 1863945),
	(79, 1882992);
/*!40000 ALTER TABLE `player_xp_for_level` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
