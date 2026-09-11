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

-- Dumping structure for table acore_characters.guild_bank_item
DROP TABLE IF EXISTS `guild_bank_item`;
CREATE TABLE IF NOT EXISTS `guild_bank_item` (
  `guildid` int unsigned NOT NULL DEFAULT '0',
  `TabId` tinyint unsigned NOT NULL DEFAULT '0',
  `SlotId` tinyint unsigned NOT NULL DEFAULT '0',
  `item_guid` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`,`TabId`,`SlotId`),
  KEY `guildid_key` (`guildid`),
  KEY `Idx_item_guid` (`item_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_characters.guild_bank_item: ~87 rows (approximately)
DELETE FROM `guild_bank_item`;
INSERT INTO `guild_bank_item` (`guildid`, `TabId`, `SlotId`, `item_guid`) VALUES
	(1, 0, 0, 111354846),
	(1, 0, 9, 112116940),
	(1, 0, 22, 112671325),
	(1, 0, 20, 112693063),
	(1, 0, 23, 112714584),
	(1, 0, 21, 112726037),
	(1, 0, 24, 113045312),
	(1, 0, 15, 115507056),
	(1, 0, 12, 117315824),
	(1, 0, 31, 120099323),
	(1, 0, 32, 120099324),
	(1, 0, 34, 120099326),
	(1, 0, 30, 120099328),
	(1, 0, 33, 120099333),
	(1, 0, 28, 120099336),
	(1, 0, 29, 120099345),
	(1, 0, 14, 120128545),
	(1, 0, 13, 120128546),
	(1, 0, 38, 120128547),
	(1, 0, 46, 120128548),
	(1, 0, 16, 120219997),
	(1, 0, 25, 120469567),
	(1, 0, 36, 120781414),
	(1, 0, 27, 120781415),
	(1, 0, 35, 120781416),
	(1, 0, 37, 120781417),
	(1, 0, 41, 121250767),
	(1, 0, 44, 121250768),
	(1, 0, 42, 121250769),
	(1, 0, 45, 121250770),
	(1, 0, 43, 121250771),
	(1, 0, 40, 121250772),
	(1, 0, 47, 121410238),
	(1, 0, 50, 121601149),
	(1, 0, 58, 121601152),
	(1, 0, 48, 121601155),
	(1, 0, 60, 121601192),
	(1, 0, 26, 121601216),
	(1, 0, 57, 121608840),
	(1, 0, 49, 121677046),
	(1, 0, 59, 121876192),
	(1, 0, 10, 122416840),
	(1, 0, 77, 122416880),
	(1, 0, 5, 123182534),
	(1, 0, 39, 123397903),
	(1, 0, 18, 123811623),
	(1, 0, 64, 123850933),
	(1, 0, 19, 123946400),
	(1, 0, 1, 124317353),
	(1, 0, 11, 124317386),
	(1, 0, 83, 124616921),
	(1, 0, 80, 124618727),
	(1, 0, 85, 124626618),
	(1, 0, 62, 125656971),
	(1, 0, 2, 125678169),
	(1, 0, 54, 125862868),
	(1, 0, 17, 127618320),
	(1, 0, 6, 127618321),
	(1, 0, 3, 127618326),
	(1, 0, 7, 127618328),
	(1, 0, 53, 127618361),
	(1, 0, 4, 127618366),
	(1, 0, 51, 127618408),
	(1, 0, 8, 127618417),
	(1, 0, 52, 127618441),
	(1, 0, 61, 127618465),
	(1, 0, 56, 127618475),
	(1, 0, 55, 127618523),
	(1, 0, 76, 127740052),
	(1, 0, 69, 127740053),
	(1, 0, 73, 127740057),
	(1, 0, 79, 127740066),
	(1, 0, 71, 127740088),
	(1, 0, 70, 127740094),
	(1, 0, 75, 127740206),
	(1, 0, 74, 127740235),
	(1, 0, 68, 127740240),
	(1, 0, 66, 127740256),
	(1, 0, 78, 127740262),
	(1, 0, 67, 127740361),
	(1, 0, 63, 127740477),
	(1, 0, 65, 128327636),
	(1, 0, 72, 128327640),
	(1, 0, 82, 128774697),
	(1, 0, 81, 129937554),
	(1, 0, 84, 129937590),
	(1, 0, 86, 129990402);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
