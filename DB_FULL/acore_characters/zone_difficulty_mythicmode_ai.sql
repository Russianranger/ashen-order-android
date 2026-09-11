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

-- Dumping structure for table acore_characters.zone_difficulty_mythicmode_ai
DROP TABLE IF EXISTS `zone_difficulty_mythicmode_ai`;
CREATE TABLE IF NOT EXISTS `zone_difficulty_mythicmode_ai` (
  `CreatureEntry` int NOT NULL DEFAULT '0',
  `Chance` tinyint NOT NULL DEFAULT '100',
  `Spell` int NOT NULL,
  `Spellbp0` int NOT NULL DEFAULT '0',
  `Spellbp1` int NOT NULL DEFAULT '0',
  `Spellbp2` int NOT NULL DEFAULT '0',
  `Target` tinyint NOT NULL DEFAULT '1',
  `TargetArg` int NOT NULL DEFAULT '0',
  `TargetArg2` int NOT NULL DEFAULT '0',
  `Delay` int NOT NULL DEFAULT '1',
  `Cooldown` int NOT NULL DEFAULT '1',
  `Repetitions` tinyint NOT NULL DEFAULT '0',
  `Enabled` tinyint DEFAULT '1',
  `TriggeredCast` tinyint DEFAULT '1',
  `Comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table acore_characters.zone_difficulty_mythicmode_ai: ~12 rows (approximately)
DELETE FROM `zone_difficulty_mythicmode_ai`;
INSERT INTO `zone_difficulty_mythicmode_ai` (`CreatureEntry`, `Chance`, `Spell`, `Spellbp0`, `Spellbp1`, `Spellbp2`, `Target`, `TargetArg`, `TargetArg2`, `Delay`, `Cooldown`, `Repetitions`, `Enabled`, `TriggeredCast`, `Comment`) VALUES
	(18831, 100, 19784, 0, 0, 0, 5, 0, 0, 30000, 5000, 0, 1, 1, 'Maulgar, Gruul\'s Lair. Dark Iron Bomb on a random player after 30s every 5s.'),
	(18832, 100, 6726, 0, 0, 0, 18, 0, 50, 28000, 30000, 0, 1, 1, 'Krosh Firehand, Gruul\'s Lair. 5sec Silence on all players in 50m after 28s every 30s.'),
	(18834, 100, 69969, 0, 0, 0, 18, 0, 50, 58000, 60000, 0, 1, 1, 'Olm the Summoner, Gruul\'s Lair. Curse of Doom (12s) on all players in 50m after 58s every 60s.'),
	(19044, 100, 39965, 500, 0, 0, 18, 0, 10, 33000, 30000, 0, 1, 1, 'Gruul, Gruul\'s Lair. Frost Grenade on all players in 10m after 33s every 30s.'),
	(19044, 100, 51758, 0, 0, 0, 1, 0, 0, 25000, 120000, 0, 1, 1, 'Gruul, Gruul\'s Lair. Fire Reflection on self after 25s every 120s.'),
	(19044, 100, 51763, 0, 0, 0, 1, 0, 0, 55000, 120000, 0, 1, 1, 'Gruul, Gruul\'s Lair. Frost Reflection on self after 55s every 120s.'),
	(19044, 100, 51764, 0, 0, 0, 1, 0, 0, 85000, 120000, 0, 1, 1, 'Gruul, Gruul\'s Lair. Shadow Reflection on self after 85s every 120s.'),
	(19044, 100, 51766, 0, 0, 0, 1, 0, 0, 115000, 120000, 0, 1, 1, 'Gruul, Gruul\'s Lair. Arcane Reflection on self after 115s every 120s.'),
	(19389, 30, 20508, 0, 0, 0, 6, 0, 0, 5000, 12000, 0, 1, 1, 'Lair Brute, Gruul\'s Lair. Charge with AE knockback on a random player except the MT after 5s every 12s.'),
	(21350, 30, 851, 0, 0, 0, 6, 0, 0, 5000, 2000, 0, 1, 1, 'Gronn-Priest, Gruul\'s Lair. Sheep on a random player except the MT after 5s every 2s.'),
	(17257, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 'Magtheridon, Magtheridon\'s Lair.'),
	(21350, 100, 38019, 0, 0, 0, 1, 0, 0, 5000, 10000, 0, 1, 1, 'Gronn-Priest, Gruul\'s Lair. Summon Water Elemental after 5s every 10s.');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
