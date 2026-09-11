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

-- Dumping structure for table acore_characters.custom_transmogrification
DROP TABLE IF EXISTS `custom_transmogrification`;
CREATE TABLE IF NOT EXISTS `custom_transmogrification` (
  `GUID` int unsigned NOT NULL COMMENT 'Item guidLow',
  `FakeEntry` int unsigned NOT NULL COMMENT 'Item entry',
  `Owner` int unsigned NOT NULL COMMENT 'Player guidLow',
  PRIMARY KEY (`GUID`),
  KEY `Owner` (`Owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='6_2';

-- Dumping data for table acore_characters.custom_transmogrification: ~37 rows (approximately)
DELETE FROM `custom_transmogrification`;
INSERT INTO `custom_transmogrification` (`GUID`, `FakeEntry`, `Owner`) VALUES
	(41741308, 1, 44),
	(58256232, 1, 44),
	(69629781, 152094, 44),
	(88523070, 1, 44),
	(110244940, 1, 41),
	(110244943, 1, 41),
	(110244953, 172652, 41),
	(112422216, 1, 41),
	(112467951, 133615, 44),
	(115130400, 16955, 41),
	(115242114, 16956, 41),
	(115464243, 16958, 41),
	(116537373, 820619, 41),
	(117823871, 21606, 41),
	(118977959, 33257, 41),
	(120483035, 16958, 41),
	(121010318, 16954, 41),
	(122194406, 1, 41),
	(128881919, 113808, 41),
	(137770097, 19143, 41),
	(141421264, 33257, 41),
	(141465084, 816858, 41),
	(141465086, 916856, 41),
	(141465089, 916860, 41),
	(141486991, 916854, 41),
	(141486994, 816853, 41),
	(156932396, 148548, 171),
	(157793283, 276561, 171),
	(158759401, 28612, 171),
	(159772014, 22818, 171),
	(160133811, 78805, 171),
	(160339701, 1, 171),
	(160606867, 1, 171),
	(161289860, 28612, 171),
	(162946330, 1, 171),
	(163123198, 11735, 171);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
