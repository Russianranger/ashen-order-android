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

-- Dumping structure for table acore_world.spell_cooldown_overrides
DROP TABLE IF EXISTS `spell_cooldown_overrides`;
CREATE TABLE IF NOT EXISTS `spell_cooldown_overrides` (
  `Id` int unsigned NOT NULL,
  `RecoveryTime` int unsigned NOT NULL DEFAULT '0',
  `CategoryRecoveryTime` int unsigned NOT NULL DEFAULT '0',
  `StartRecoveryTime` int unsigned NOT NULL DEFAULT '0',
  `StartRecoveryCategory` int unsigned NOT NULL DEFAULT '0',
  `Comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table acore_world.spell_cooldown_overrides: ~34 rows (approximately)
DELETE FROM `spell_cooldown_overrides`;
INSERT INTO `spell_cooldown_overrides` (`Id`, `RecoveryTime`, `CategoryRecoveryTime`, `StartRecoveryTime`, `StartRecoveryCategory`, `Comment`) VALUES
	(11479, 86400000, 86400000, 0, 0, 'Transmute: Iron to Gold - 1 day'),
	(11480, 172800000, 172800000, 0, 0, 'Transmute: Mithril to Truesilver - 2 days'),
	(17187, 172800000, 172800000, 0, 0, 'Transmute: Arcanite - 2 days'),
	(17559, 86400000, 86400000, 0, 0, 'Transmute: Air to Fire - 1 day'),
	(17560, 86400000, 86400000, 0, 0, 'Transmute: Fire to Earth - 1 day'),
	(17561, 86400000, 86400000, 0, 0, 'Transmute: Earth to Water - 1 day'),
	(17562, 86400000, 86400000, 0, 0, 'Transmute: Water to Air - 1 day'),
	(17563, 86400000, 86400000, 0, 0, 'Transmute: Undeath to Water - 1 day'),
	(17564, 86400000, 86400000, 0, 0, 'Transmute: Water to Undeath - 1 day'),
	(17565, 86400000, 86400000, 0, 0, 'Transmute: Life to Earth - 1 day'),
	(17566, 86400000, 86400000, 0, 0, 'Transmute: Earth to Life - 1 day'),
	(18560, 345600000, 345600000, 0, 0, 'Mooncloth - 4 days'),
	(25146, 600000, 600000, 0, 0, 'Transmute: Elemental Fire - 10 minutes'),
	(26751, 331200000, 331200000, 0, 0, 'Primal Mooncloth - 3 days 20 hours'),
	(28566, 72000000, 72000000, 0, 0, 'Transmute: Primal Air to Fire - 20 hours'),
	(28567, 72000000, 72000000, 0, 0, 'Transmute: Primal Earth to Water - 20 hours'),
	(28568, 72000000, 72000000, 0, 0, 'Transmute: Primal Fire to Earth - 20 hours'),
	(28569, 72000000, 72000000, 0, 0, 'Transmute: Primal Water to Air - 20 hours'),
	(29688, 72000000, 72000000, 0, 0, 'Transmute: Primal Might - 20 hours'),
	(31373, 331200000, 331200000, 0, 0, 'Spellcloth - 3 days 20 hours'),
	(31626, 5000, 5000, 0, 0, 'Shadowy Necromancer - Unholy Frenzy'),
	(32765, 72000000, 72000000, 0, 0, 'Transmute: Earthstorm Diamond - 20 hours'),
	(32766, 72000000, 72000000, 0, 0, 'Transmute: Skyfire Diamond - 20 hours'),
	(34019, 60000, 60000, 0, 0, 'Bleeding Hollow Necrolyte - Raise Dead'),
	(36686, 331200000, 331200000, 0, 0, 'Shadowcloth - 3 days 20 hours'),
	(37118, 8000, 8000, 0, 0, 'Tempest-Smith - Shell Shock'),
	(37455, 20000, 20000, 0, 0, NULL),
	(37456, 20000, 20000, 0, 0, NULL),
	(37471, 15000, 15000, 0, 0, 'Karazhan Chest - Heroism'),
	(37472, 15000, 15000, 0, 0, 'Karazhan Chest - Bloodlust'),
	(37920, 30000, 30000, 0, 0, 'Fel Reaver Sentinel - Turbo Boost'),
	(38006, 10000, 10000, 0, 0, 'Fel Reaver Sentinel - World Breaker'),
	(38052, 15000, 15000, 0, 0, 'Fel Reaver Sentinel - Sonic Boom'),
	(38055, 10000, 10000, 0, 0, 'Fel Reaver Sentinel - Destroy Deathforged Infernal');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
