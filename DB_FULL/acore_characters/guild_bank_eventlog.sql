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

-- Dumping structure for table acore_characters.guild_bank_eventlog
DROP TABLE IF EXISTS `guild_bank_eventlog`;
CREATE TABLE IF NOT EXISTS `guild_bank_eventlog` (
  `guildid` int unsigned NOT NULL DEFAULT '0' COMMENT 'Guild Identificator',
  `LogGuid` int unsigned NOT NULL DEFAULT '0' COMMENT 'Log record identificator - auxiliary column',
  `TabId` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Guild bank TabId',
  `EventType` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Event type',
  `PlayerGuid` int unsigned NOT NULL DEFAULT '0',
  `ItemOrMoney` int unsigned NOT NULL DEFAULT '0',
  `ItemStackCount` smallint unsigned NOT NULL DEFAULT '0',
  `DestTabId` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'Destination Tab Id',
  `TimeStamp` int unsigned NOT NULL DEFAULT '0' COMMENT 'Event UNIX time',
  PRIMARY KEY (`guildid`,`LogGuid`,`TabId`),
  KEY `guildid_key` (`guildid`),
  KEY `Idx_PlayerGuid` (`PlayerGuid`),
  KEY `Idx_LogGuid` (`LogGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_characters.guild_bank_eventlog: ~76 rows (approximately)
DELETE FROM `guild_bank_eventlog`;
INSERT INTO `guild_bank_eventlog` (`guildid`, `LogGuid`, `TabId`, `EventType`, `PlayerGuid`, `ItemOrMoney`, `ItemStackCount`, `DestTabId`, `TimeStamp`) VALUES
	(1, 0, 0, 1, 41, 22373, 185, 0, 1720079238),
	(1, 0, 1, 1, 41, 136083, 1, 0, 1728951813),
	(1, 0, 100, 6, 41, 1, 0, 0, 1739443943),
	(1, 1, 0, 1, 41, 22376, 37, 0, 1720079238),
	(1, 1, 1, 2, 41, 136083, 1, 0, 1728951816),
	(1, 1, 100, 6, 41, 1, 0, 0, 1739444131),
	(1, 2, 0, 1, 41, 22376, 162, 0, 1720079238),
	(1, 2, 100, 4, 41, 214, 0, 0, 1730355565),
	(1, 3, 0, 1, 41, 861630, 1, 0, 1728951466),
	(1, 3, 100, 4, 41, 75, 0, 0, 1732252179),
	(1, 4, 0, 2, 41, 861630, 1, 0, 1728951470),
	(1, 4, 100, 6, 41, 595, 0, 0, 1739388778),
	(1, 5, 0, 1, 41, 20865, 2, 0, 1719120053),
	(1, 5, 100, 4, 41, 108, 0, 0, 1739429828),
	(1, 6, 0, 1, 41, 5760, 1, 0, 1719307103),
	(1, 6, 100, 4, 41, 84, 0, 0, 1739429866),
	(1, 7, 0, 1, 41, 5759, 1, 0, 1719307103),
	(1, 7, 100, 4, 41, 108, 0, 0, 1739429867),
	(1, 8, 0, 1, 41, 20869, 1, 0, 1719584180),
	(1, 8, 100, 4, 41, 73, 0, 0, 1739429868),
	(1, 9, 0, 1, 41, 20870, 2, 0, 1719584181),
	(1, 9, 100, 4, 41, 96, 0, 0, 1739429868),
	(1, 10, 0, 1, 41, 20868, 1, 0, 1719584181),
	(1, 10, 100, 4, 41, 79, 0, 0, 1739429870),
	(1, 11, 0, 1, 41, 20871, 1, 0, 1719584182),
	(1, 11, 100, 6, 41, 11100, 0, 0, 1739442937),
	(1, 12, 0, 1, 41, 20867, 3, 0, 1719584183),
	(1, 12, 100, 6, 41, 10913, 0, 0, 1739442937),
	(1, 13, 0, 1, 41, 20879, 1, 0, 1720076510),
	(1, 13, 100, 6, 41, 19040, 0, 0, 1739442937),
	(1, 14, 0, 1, 41, 20875, 1, 0, 1720076511),
	(1, 14, 100, 6, 41, 5549, 0, 0, 1739442937),
	(1, 15, 0, 1, 41, 20881, 4, 0, 1720076511),
	(1, 15, 100, 6, 41, 13541, 0, 0, 1739442937),
	(1, 16, 0, 1, 41, 20882, 5, 0, 1720076511),
	(1, 16, 100, 6, 41, 7704, 0, 0, 1739442937),
	(1, 17, 0, 1, 41, 20877, 5, 0, 1720076512),
	(1, 17, 100, 6, 41, 5772, 0, 0, 1739442937),
	(1, 18, 0, 1, 41, 20874, 3, 0, 1720076512),
	(1, 18, 100, 6, 41, 5549, 0, 0, 1739442937),
	(1, 19, 0, 1, 41, 20876, 5, 0, 1720076513),
	(1, 19, 100, 6, 41, 1, 0, 0, 1739442937),
	(1, 20, 0, 1, 41, 22374, 128, 0, 1720079235),
	(1, 20, 100, 6, 41, 5126, 0, 0, 1739442937),
	(1, 21, 0, 1, 41, 22374, 106, 0, 1720079235),
	(1, 21, 100, 6, 41, 6048, 0, 0, 1739442937),
	(1, 22, 0, 1, 41, 22373, 109, 0, 1720079236),
	(1, 22, 100, 6, 41, 17784, 0, 0, 1739442937),
	(1, 23, 0, 1, 41, 22375, 180, 0, 1720079237),
	(1, 23, 100, 6, 41, 1, 0, 0, 1739443570),
	(1, 24, 0, 1, 41, 22375, 119, 0, 1720079237),
	(1, 24, 100, 6, 41, 1, 0, 0, 1739443935),
	(2, 0, 100, 4, 171, 57, 0, 0, 1739861585),
	(2, 1, 100, 4, 171, 128, 0, 0, 1739861586),
	(2, 2, 100, 4, 171, 4622, 0, 0, 1739862213),
	(2, 3, 100, 4, 171, 900, 0, 0, 1739862328),
	(2, 4, 100, 4, 171, 900, 0, 0, 1739862365),
	(2, 5, 100, 4, 171, 200, 0, 0, 1739862399),
	(2, 6, 100, 4, 171, 875, 0, 0, 1739862505),
	(2, 7, 100, 4, 171, 38, 0, 0, 1739862670),
	(2, 8, 100, 4, 171, 51, 0, 0, 1739862883),
	(2, 9, 100, 4, 171, 4374, 0, 0, 1739863471),
	(2, 10, 100, 4, 171, 61, 0, 0, 1739863643),
	(2, 11, 100, 4, 171, 23, 0, 0, 1739863889),
	(2, 12, 100, 4, 171, 4291, 0, 0, 1739864008),
	(2, 13, 100, 4, 171, 73, 0, 0, 1739864078),
	(2, 14, 100, 4, 171, 4359, 0, 0, 1739864743),
	(2, 15, 100, 4, 171, 4719, 0, 0, 1739865496),
	(2, 16, 100, 4, 171, 4378, 0, 0, 1739866053),
	(2, 17, 100, 4, 171, 425, 0, 0, 1739867635),
	(2, 18, 100, 4, 171, 4437, 0, 0, 1739868267),
	(2, 19, 100, 4, 171, 4562, 0, 0, 1739868279),
	(2, 20, 100, 4, 171, 4330, 0, 0, 1739868428),
	(2, 21, 100, 4, 171, 425, 0, 0, 1739868540),
	(2, 22, 100, 4, 171, 425, 0, 0, 1739868824),
	(2, 23, 100, 4, 171, 4500, 0, 0, 1739868964),
	(2, 24, 100, 4, 171, 19, 0, 0, 1739861536);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
