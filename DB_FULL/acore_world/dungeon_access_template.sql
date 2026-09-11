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

-- Dumping structure for table acore_world.dungeon_access_template
DROP TABLE IF EXISTS `dungeon_access_template`;
CREATE TABLE IF NOT EXISTS `dungeon_access_template` (
  `id` tinyint unsigned NOT NULL AUTO_INCREMENT COMMENT 'The dungeon template ID',
  `map_id` mediumint unsigned NOT NULL COMMENT 'Map ID from instance_template',
  `difficulty` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '5 man: 0 = normal, 1 = heroic, 2 = epic (not implemented) | 10 man: 0 = normal, 2 = heroic | 25 man: 1 = normal, 3 = heroic',
  `min_level` tinyint unsigned DEFAULT NULL,
  `max_level` tinyint unsigned DEFAULT NULL,
  `min_avg_item_level` smallint unsigned DEFAULT NULL COMMENT 'Min average ilvl required to enter',
  `comment` varchar(255) DEFAULT NULL COMMENT 'Dungeon Name 5/10/25/40 man - Normal/Heroic',
  PRIMARY KEY (`id`),
  KEY `FK_dungeon_access_template__instance_template` (`map_id`)
) ENGINE=MyISAM AUTO_INCREMENT=230 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='Dungeon/raid access template and single requirements';

-- Dumping data for table acore_world.dungeon_access_template: 133 rows
DELETE FROM `dungeon_access_template`;
/*!40000 ALTER TABLE `dungeon_access_template` DISABLE KEYS */;
INSERT INTO `dungeon_access_template` (`id`, `map_id`, `difficulty`, `min_level`, `max_level`, `min_avg_item_level`, `comment`) VALUES
	(55, 555, 1, 70, 0, 0, 'Shadow Labyrinth'),
	(57, 556, 1, 70, 0, 0, 'Sethekk Halls'),
	(58, 557, 0, 55, 0, 0, 'Mana Tombs'),
	(56, 556, 0, 55, 0, 0, 'Sethekk Halls'),
	(59, 557, 1, 70, 0, 0, 'Mana Tombs'),
	(60, 558, 0, 55, 0, 0, 'Auchenai Crypts'),
	(61, 558, 1, 70, 0, 0, 'Auchenai Crypts'),
	(62, 560, 0, 64, 0, 0, 'Caverns Of Time: Old Hillsbrad Foothills/Escape from Durnholde - Normal'),
	(63, 560, 1, 70, 0, 0, 'Caverns Of Time: Old Hillsbrad Foothills/Escape from Durnholde - Heroic'),
	(64, 564, 0, 70, 0, 0, 'Black Temple'),
	(65, 565, 0, 70, 0, 0, 'Gruul\'s Lair'),
	(66, 568, 0, 70, 0, 0, 'Zul\'Aman'),
	(67, 574, 0, 65, 0, 0, 'Utgarde Keep'),
	(69, 575, 0, 75, 0, 0, 'Utgarde Pinnacle'),
	(68, 574, 1, 80, 0, 180, 'Utgarde Keep'),
	(70, 575, 1, 80, 0, 180, 'Utgarde Pinnacle'),
	(71, 576, 0, 66, 0, 0, 'The Nexus'),
	(72, 576, 1, 80, 0, 180, 'The Nexus'),
	(73, 578, 0, 75, 0, 0, 'The Oculus'),
	(75, 580, 0, 70, 0, 0, 'Sunwell Plateau'),
	(74, 578, 1, 80, 0, 180, 'The Oculus'),
	(76, 585, 0, 65, 0, 0, 'Magisters\' Terrace - Normal'),
	(78, 595, 0, 75, 0, 0, 'Culling of Stratholme'),
	(77, 585, 1, 70, 0, 0, 'Magisters\' Terrace - Heroic'),
	(80, 599, 0, 72, 0, 0, 'Ulduar,Halls of Stone'),
	(79, 595, 1, 80, 0, 180, 'Culling of Stratholme'),
	(81, 599, 1, 80, 0, 180, 'Ulduar,Halls of Stone'),
	(85, 601, 1, 80, 0, 180, 'Azjol-Nerub'),
	(83, 600, 1, 80, 0, 180, 'Drak\'Tharon Keep'),
	(82, 600, 0, 69, 0, 0, 'Drak\'Tharon Keep'),
	(84, 601, 0, 67, 0, 0, 'Azjol-Nerub'),
	(86, 602, 0, 75, 0, 0, 'Ulduar,Halls of Lightning'),
	(87, 602, 1, 80, 0, 180, 'Ulduar,Halls of Lightning'),
	(89, 603, 1, 80, 0, 0, 'Ulduar'),
	(88, 603, 0, 80, 0, 0, 'Ulduar - 10man'),
	(94, 615, 0, 80, 0, 0, 'The Obsidian Sanctum - 10man'),
	(92, 608, 0, 70, 0, 0, 'Violet Hold'),
	(91, 604, 1, 80, 0, 180, 'Gundrak (North entrance)'),
	(90, 604, 0, 71, 0, 0, 'Gundrak (North entrance)'),
	(95, 615, 1, 80, 0, 0, 'Chamber of Aspects,Obsidian Sanctum'),
	(93, 608, 1, 80, 0, 180, 'Violet Hold'),
	(96, 616, 0, 80, 0, 0, 'The Eye of Eternity (Malygos) - 10man'),
	(98, 619, 0, 68, 0, 0, 'Ahn\'Kahet'),
	(99, 619, 1, 80, 0, 180, 'Ahn\'Kahet'),
	(97, 616, 1, 80, 0, 0, 'The Eye of Eternity'),
	(100, 624, 0, 80, 0, 0, 'Vault of Archavon - 10man'),
	(101, 624, 1, 80, 0, 0, 'Vault of Archavon'),
	(102, 631, 0, 80, 0, 0, 'Icecrown Citadel - 10man Normal'),
	(103, 631, 1, 80, 0, 0, 'IceCrown Citadel'),
	(104, 631, 2, 80, 0, 0, 'IceCrown Citadel'),
	(105, 631, 3, 80, 0, 0, 'IceCrown Citadel'),
	(113, 650, 1, 80, 0, 200, 'Trial of the Champion'),
	(106, 632, 0, 75, 0, 180, 'Forge of Souls'),
	(115, 658, 1, 80, 0, 200, 'Pit of Saron'),
	(114, 658, 0, 78, 0, 180, 'Pit of Saron'),
	(116, 668, 0, 78, 0, 180, 'Halls of Reflection'),
	(117, 668, 1, 80, 0, 219, 'Halls of Reflection'),
	(120, 724, 2, 80, 0, 0, 'The Ruby Sanctum'),
	(118, 724, 0, 80, 0, 0, 'The Ruby Sanctum - 10man Normal'),
	(119, 724, 1, 80, 0, 0, 'The Ruby Sanctum'),
	(122, 533, 2, 60, 0, 0, 'Naxxramas - 40man'),
	(123, 249, 2, 50, 0, 0, 'Onyxia\'s Lair - 40man'),
	(121, 724, 3, 80, 0, 0, 'The Ruby Sanctum'),
	(34, 540, 1, 70, 0, 0, 'The Shattered Halls'),
	(30, 533, 0, 80, 0, 0, 'Naxxramas - 10man'),
	(31, 533, 1, 80, 0, 0, 'Naxxramas'),
	(29, 532, 0, 58, 0, 0, 'Karazhan - 10man'),
	(28, 531, 0, 50, 0, 0, 'Ahn\'Qiraj Temple (AQ40) - 40man'),
	(27, 509, 0, 50, 0, 0, 'Ahn\'Qiraj Ruins (AQ20) - 20man'),
	(25, 429, 0, 45, 0, 0, 'Dire Maul - All wings'),
	(26, 469, 0, 60, 0, 0, 'Blackwing Lair (BWL) - 40man'),
	(24, 409, 0, 50, 0, 0, 'Molten Core - 40man'),
	(23, 389, 0, 8, 0, 0, 'Ragefire Chasm (RF)'),
	(21, 329, 0, 45, 0, 0, 'Stratholme'),
	(22, 349, 0, 30, 0, 0, 'Maraudon - All wings'),
	(20, 309, 0, 50, 0, 0, 'Zul\'Gurub (ZG) - 20man'),
	(18, 269, 1, 70, 0, 0, 'Caverns Of Time: Black Morass/Opening the Dark Portal - Heroic'),
	(19, 289, 0, 45, 0, 0, 'Scholomance'),
	(17, 269, 0, 66, 0, 0, 'Caverns Of Time: Black Morass/Opening the Dark Portal - Normal'),
	(15, 249, 0, 80, 0, 0, 'Onyxia\'s Lair - 10man'),
	(16, 249, 1, 80, 0, 0, 'Onyxia\'s Lair - 25man'),
	(14, 230, 0, 40, 0, 0, 'Blackrock Depths (BRD)'),
	(13, 229, 0, 45, 0, 0, 'Blackrock Spire - Both Lower (LBRS) & Upper (UBRS) - 5/10man'),
	(12, 209, 0, 35, 0, 0, 'Zul\'Farrak (ZF)'),
	(10, 129, 0, 25, 0, 0, 'Razorfen Downs'),
	(53, 554, 1, 70, 0, 0, 'The Mechanar'),
	(54, 555, 0, 65, 0, 0, 'Shadow Labyrinth'),
	(52, 554, 0, 67, 0, 0, 'The Mechanar'),
	(50, 553, 0, 67, 0, 0, 'The Botanica'),
	(51, 553, 1, 70, 0, 0, 'The Botanica'),
	(48, 552, 0, 68, 0, 0, 'The Arcatraz'),
	(49, 552, 1, 70, 0, 0, 'The Arcatraz'),
	(47, 550, 0, 70, 0, 0, 'The Eye'),
	(46, 548, 0, 68, 0, 0, 'Coilfang Reservoir: Serpentshrine Cavern - 25man'),
	(44, 547, 0, 55, 0, 0, 'The Slave Pens'),
	(45, 547, 1, 70, 0, 0, 'The Slave Pens'),
	(41, 545, 1, 70, 0, 0, 'The Steamvault'),
	(43, 546, 1, 70, 0, 0, 'The Underbog'),
	(42, 546, 0, 55, 0, 0, 'The Underbog'),
	(38, 543, 1, 70, 0, 0, 'Hellfire Ramparts'),
	(39, 544, 0, 65, 0, 0, 'Hellfire Citadel: Magtheridon\'s Lair - 25man'),
	(40, 545, 0, 55, 0, 0, 'The Steamvault'),
	(36, 542, 1, 70, 0, 0, 'The Blood Furnace'),
	(37, 543, 0, 55, 0, 0, 'Hellfire Ramparts'),
	(35, 542, 0, 55, 0, 0, 'The Blood Furnace'),
	(32, 534, 0, 70, 0, 0, 'Battle Of Mount Hyjal,Alliance Base'),
	(33, 540, 0, 55, 0, 0, 'The Shattered Halls'),
	(11, 189, 0, 20, 0, 0, 'Scarlet Monastery (SM) - All wings'),
	(8, 90, 0, 15, 0, 0, 'Gnomeregan'),
	(9, 109, 0, 35, 0, 0, 'Sunken Temple (of Atal\'Hakkar)'),
	(7, 70, 0, 30, 0, 0, 'Uldaman'),
	(6, 48, 0, 19, 0, 0, 'Blackfathom Deeps'),
	(5, 47, 0, 17, 0, 0, 'Razorfen Kraul'),
	(4, 43, 0, 10, 0, 0, 'Wailing Caverns (WC)'),
	(2, 34, 0, 15, 0, 0, 'Stormwind Stockades'),
	(3, 36, 0, 10, 0, 0, 'Deadmines (DM)'),
	(107, 632, 1, 80, 0, 200, 'Forge of Souls'),
	(1, 33, 0, 14, 0, 0, 'Shadowfang Keep'),
	(108, 649, 0, 80, 0, 0, 'Trial of the Crusader - 10man Normal'),
	(109, 649, 1, 80, 0, 0, 'Trial of the Crusader'),
	(110, 649, 2, 80, 0, 0, 'Trial of the Crusader'),
	(111, 649, 3, 80, 0, 0, 'Trial of the Crusader'),
	(112, 650, 0, 75, 0, 180, 'Trial of the Champion'),
	(124, 37, 1, 0, 0, 0, 'Onyxia\'s Lair - 40man'),
	(125, 671, 0, 60, 0, 0, 'Bastion of Twilight'),
	(126, 670, 0, 60, 0, 0, 'Grim Batol'),
	(127, 669, 0, 60, 0, 0, 'Blackwing Descent'),
	(128, 169, 0, 60, 0, 0, 'Emerald Dream'),
	(129, 734, 0, 60, 0, 0, 'Lost City of the Tol\'vir'),
	(130, 757, 0, 60, 0, 0, 'Baradin Hold'),
	(131, 2454, 0, 60, 0, 0, 'Ursa\'s Lair'),
	(132, 33, 1, 60, 0, 0, 'Shadowfang'),
	(133, 2461, 1, 70, 0, 0, 'Burning of Andorhal');
/*!40000 ALTER TABLE `dungeon_access_template` ENABLE KEYS */;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
