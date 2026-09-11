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

-- Dumping structure for table acore_characters.zone_difficulty_info
DROP TABLE IF EXISTS `zone_difficulty_info`;
CREATE TABLE IF NOT EXISTS `zone_difficulty_info` (
  `MapID` int NOT NULL DEFAULT '0',
  `PhaseMask` int NOT NULL DEFAULT '0',
  `HealingNerfValue` float NOT NULL DEFAULT '1',
  `AbsorbNerfValue` float NOT NULL DEFAULT '1',
  `MeleeDmgBuffValue` float NOT NULL DEFAULT '1',
  `SpellDmgBuffValue` float NOT NULL DEFAULT '1',
  `Enabled` tinyint NOT NULL DEFAULT '1',
  `Comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`MapID`,`PhaseMask`,`Enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table acore_characters.zone_difficulty_info: ~52 rows (approximately)
DELETE FROM `zone_difficulty_info`;
INSERT INTO `zone_difficulty_info` (`MapID`, `PhaseMask`, `HealingNerfValue`, `AbsorbNerfValue`, `MeleeDmgBuffValue`, `SpellDmgBuffValue`, `Enabled`, `Comment`) VALUES
	(30, 0, 0.8, 0.8, 0.7, 0.7, 1, 'AV Healing 20% / Absorb 20% / 30% physical & spell damage nerf'),
	(249, 0, 0.5, 0.5, 1.4, 1.4, 0, 'ONY Healing 50% / Absorb 50% Nerf / 40% physical & 40% spell damage buff'),
	(269, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode Black Morass Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(269, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Black Morass Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(309, 0, 0.5, 0.5, 1.5, 1.1, 0, 'ZG20 Healing 50% / Absorb 50% Nerf / 50% physical & 10% spell damage buff'),
	(409, 0, 0.5, 0.5, 1.5, 1.5, 0, 'MC Healing 50% / Absorb 50% Nerf / 50% physical & 50% spell damage buff'),
	(469, 0, 0.5, 0.5, 1.5, 1.5, 0, 'BWL Healing 50% / Absorb 50% Nerf / 50% physical & 50% spell damage buff'),
	(489, 0, 0.8, 0.8, 0.7, 0.7, 1, 'WSG Healing 20% / Absorb 20% / 30% physical & spell damage nerf'),
	(509, 0, 0.5, 0.5, 1.6, 1.3, 1, 'AQ20 Healing 50% / Absorb 50% Nerf / 60% physical & 30% spell damage buff'),
	(529, 0, 0.8, 0.8, 0.7, 0.7, 1, 'AB Healing 20% / Absorb 20% / 30% physical & spell damage nerf'),
	(531, 0, 0.5, 0.5, 1.5, 1.3, 1, 'AQ40 Healing 50% / Absorb 50% Nerf / 50% physical & 30% spell damage buff'),
	(540, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode Shattered Halls Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(540, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Shattered Halls Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(542, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode Blood Furnace Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(542, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Blood Furnace Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(543, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode Hellfire Ramparts Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(543, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Hellfire Ramparts Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(544, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Normal Mode Magtheridon Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(544, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Magtheridon Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(545, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode The Steamvault Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(545, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode The Steamvault Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(546, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode The Underbog Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(546, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode The Underbog Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(547, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode Slave Pens Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(547, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Slave Pens Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(552, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode The Arcatraz Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(552, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode The Arcatraz Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(553, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode The Botanica Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(553, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode The Botanica Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(554, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode The Mechanar Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(554, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode The Mechanar Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(555, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode Shadow Labyrinth Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(555, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Shadow Labyrinth Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(556, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode Sethekk Halls Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(556, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Sethekk Halls Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(557, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode Mana Tombs Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(557, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Mana Tombs Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(558, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode Auchenai Crypts Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(558, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Auchenai Crypts Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(559, 0, 0.8, 0.8, 0.7, 0.7, 1, 'Ring of Trials Healing 20% / Absorb 20% / 30% physical & spell damage nerf'),
	(560, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode The Escape From Durnholde Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(560, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode The Escape From Durnholde Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(562, 0, 0.8, 0.8, 0.7, 0.7, 1, 'Blades Edge Arena  Healing 20% / Absorb 20% / 30% physical & spell damage nerf'),
	(565, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Normal Mode Gruul Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(565, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Gruul Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(566, 0, 0.8, 0.8, 0.7, 0.7, 1, 'EotS Healing 20% / Absorb 20% / 30% physical & spell damage nerf'),
	(572, 0, 0.8, 0.8, 0.7, 0.7, 1, 'Ruins of Lordaeron Healing 20% / Absorb 20% / 30% physical & spell damage nerf'),
	(585, 0, 0.8, 0.8, 1.2, 1.2, 1, 'Heroic Mode Magister\'s Terrace Healing 80% / Absorb 80% Nerf / 20% physical & 20% spell damage buff'),
	(585, 0, 0.7, 0.7, 1.3, 1.3, 64, 'Mythic Mode Magister\'s Terrace Healing 70% / Absorb 70% Nerf / 30% physical & 30% spell damage buff'),
	(617, 0, 0.8, 0.8, 0.7, 0.7, 1, 'Dalaran Arena Healing 20% / Absorb 20% / 30% physical & spell damage nerf'),
	(618, 0, 0.8, 0.8, 0.7, 0.7, 1, 'Ring of Valor Healing 20% / Absorb 20% / 30% physical & spell damage nerf'),
	(2147483647, 0, 0.8, 0.8, 0.7, 0.7, 1, 'Zone 2402 Duel Healing 20% / Absorb 20% Nerf / 30% physical & spell damage nerf');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
