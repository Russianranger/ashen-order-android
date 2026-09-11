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

-- Dumping structure for table acore_world.playercreateinfo_spell_custom
DROP TABLE IF EXISTS `playercreateinfo_spell_custom`;
CREATE TABLE IF NOT EXISTS `playercreateinfo_spell_custom` (
  `racemask` int unsigned NOT NULL DEFAULT '0',
  `classmask` int unsigned NOT NULL DEFAULT '0',
  `Spell` mediumint unsigned NOT NULL DEFAULT '0',
  `Note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`racemask`,`classmask`,`Spell`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_world.playercreateinfo_spell_custom: 95 rows
DELETE FROM `playercreateinfo_spell_custom`;
/*!40000 ALTER TABLE `playercreateinfo_spell_custom` DISABLE KEYS */;
INSERT INTO `playercreateinfo_spell_custom` (`racemask`, `classmask`, `Spell`, `Note`) VALUES
	(0, 64, 67228, 'T9'),
	(0, 64, 64928, 'T8'),
	(0, 128, 811080, 'Fire Blast Crit Passive'),
	(0, 64, 100110, 'Shamanistic Focus'),
	(0, 64, 100112, 'Gust of Wind'),
	(4, 2, 100108, 'Holy Leap'),
	(4, 2, 35395, 'Crusader Strike'),
	(0, 0, 100210, 'Skyburst Rank 1'),
	(0, 0, 100211, 'Up, Up and Away! Rank 1'),
	(0, 4, 100188, 'Barrage'),
	(830541, 1535, 668, 'Language: common'),
	(1135538, 1535, 669, 'Language: Orcish'),
	(328704, 1535, 29932, 'Language: Draenei'),
	(0, 1, 100114, 'Warrior Heroic Leap'),
	(0, 16, 10001003, 'Priest Void Torrent'),
	(8192, 128, 260364, 'Racial-Mage-HE'),
	(1, 2, 24939, 'Murky'),
	(0, 64, 100119, 'Elemental Attunement'),
	(4096, 0, 100222, 'Disengage'),
	(0, 32, 48707, 'AMS'),
	(0, 0, 24939, 'Murky'),
	(512, 2, 100108, 'Holy Leap'),
	(512, 2, 35395, 'Crusader Strike'),
	(1024, 2, 24939, 'Murky'),
	(1024, 2, 100108, 'Holy Leap'),
	(1024, 2, 35395, 'Crusader Strike'),
	(4, 2, 24939, 'Murky'),
	(1, 2, 35395, 'Crusader Strike'),
	(1, 2, 100108, 'Holy Leap'),
	(8192, 4, 819454, 'Imp Arcane Shot'),
	(262144, 0, 197, 'LF 2h Swords'),
	(262144, 0, 201, 'LF Swords'),
	(2095185, 4, 201, 'Swords'),
	(2095185, 8, 201, 'Swords'),
	(2095185, 4, 202, '2h Swords'),
	(0, 4, 200, 'Polearm'),
	(0, 1, 200, 'Polearm'),
	(0, 1, 199, 'two-handed maces'),
	(2095185, 1, 202, '2h Sword'),
	(0, 1, 197, '2h Sword'),
	(0, 4, 197, '2h Axe'),
	(0, 4, 196, 'Axe'),
	(0, 1, 196, 'Axe'),
	(0, 1, 1180, 'Daggers'),
	(0, 4, 1180, 'Daggers'),
	(0, 256, 1180, 'Daggers'),
	(0, 32, 48265, 'Unholy Presence'),
	(0, 32, 48792, 'Icebound fort'),
	(0, 32, 3714, 'Unholy Presence'),
	(0, 2, 35395, 'Crusader Strike'),
	(0, 2, 100108, 'Holy Leap'),
	(2095185, 2, 202, '2h Swords'),
	(8192, 16, 80093, 'Racial-PriestHE'),
	(1059328, 0, 813, 'Language Thalassian'),
	(8192, 8, 80098, 'Racial-Rogue-HE'),
	(8192, 2, 80095, 'Racial-Pally-HE'),
	(8192, 1, 80096, 'Racial-War-HE'),
	(8192, 1024, 800002, 'HE dudu racial'),
	(1638400, 1535, 815, 'Language: Demon Tongue'),
	(4128, 1535, 670, 'Language: Tauren'),
	(0, 109, 674, 'Dual Wield'),
	(8704, 2, 674, 'Dual Wield E PAL'),
	(2095185, 64, 201, 'Swords'),
	(2095185, 2, 201, 'Swords'),
	(0, 256, 845417, 'Burning Rush'),
	(0, 128, 116, 'Frostbolt'),
	(2095185, 1, 201, 'Swords'),
	(2095185, 495, 201, 'Swords'),
	(2048, 16, 888080, 'Void Elf Priest Racial'),
	(0, 8, 100192, 'Grappling Hook'),
	(0, 4, 5011, 'Crossbows'),
	(0, 64, 3127, 'Shaman Parry'),
	(0, 64, 197, 'Shaman - Two-handed Axes'),
	(0, 64, 196, 'axes'),
	(8, 47, 810797, 'Starshards - Physical'),
	(0, 128, 1953, 'Blink'),
	(0, 0, 30262, 'Smoke Flare'),
	(0, 32, 80104, 'Grim Advance'),
	(0, 1, 202, '2h Sword'),
	(0, 2, 202, '2h Sword'),
	(0, 64, 201, 'Swords'),
	(2095185, 64, 196, 'axes'),
	(0, 1, 201, 'Swords'),
	(2095185, 1, 227, 'Staves'),
	(0, 1, 227, 'Staves'),
	(0, 0, 203, 'Unarmed'),
	(2095185, 0, 203, 'Unarmed'),
	(0, 4, 202, '2h Sword'),
	(0, 32, 53428, 'Runeforging'),
	(2095185, 32, 53428, 'Runeforging'),
	(2095185, 128, 811080, 'Fire Blast Crit Passive'),
	(0, 64, 849410, 'Forceful Deflection'),
	(2095185, 64, 849410, 'Forceful Deflection'),
	(0, 0, 88098, 'Leave Combat'),
	(0, 0, 88710, 'Unbanish');
/*!40000 ALTER TABLE `playercreateinfo_spell_custom` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
