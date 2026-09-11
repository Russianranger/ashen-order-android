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

-- Dumping structure for table acore_world.murky_los_dialogues
DROP TABLE IF EXISTS `murky_los_dialogues`;
CREATE TABLE IF NOT EXISTS `murky_los_dialogues` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `creatureId` int unsigned NOT NULL,
  `dialogue` text NOT NULL,
  `range` float NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_creatureId` (`creatureId`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table acore_world.murky_los_dialogues: ~41 rows (approximately)
DELETE FROM `murky_los_dialogues`;
INSERT INTO `murky_los_dialogues` (`id`, `creatureId`, `dialogue`, `range`) VALUES
	(1, 14887, 'Mrglglgl! Once upon a tide, Ysondre roamed the Dream, now a nightmare!', 50),
	(2, 14888, 'Mrglgl! In the darkest shadows, Lethon whispers. Murky scared but brave for %s!', 50),
	(3, 14889, 'Glrglglr! Emeriss, the corruptor! Murky\'s fins tremble but stand strong for %s!', 50),
	(4, 14890, 'Mrglglgl! Taerar\'s illusions can\'t trick Murky\'s fishy eyes. Together with %s, we face him!', 50),
	(5, 639, 'Mrrglglg! VanCleef, the Defias Kingpin, rages on. Murky and %s ready for swashbuckling!', 20),
	(6, 265, 'Mrglglgl! Darkshire\'s gloomy shadows loom, %s! Murky feels brave with you by his side!', 50),
	(7, 240, 'Goldshire is bustling, %s! Murky wonders if there\'s a fish market nearby!', 50),
	(8, 100139, 'Mrglglgl! Wow, those are impressive! Murky is speechless!', 5),
	(9, 301000, 'Mrglglgl! Look at the size of those wings, and those teeth! Murky thinks you\'ll be needing more dots...', 55),
	(10, 1747, 'Mrglglgl! King Anduin, Murky admires your leadership and shiny armor!', 5),
	(12, 4949, 'Mrglglgl! Thrall, Warchief of the Horde, Murky feels strong near you!', 5),
	(13, 351019, 'Mrglglgl! Brrr, it\'s chilly! Kel\'Thuzad, can you turn down the frost? Murky\'s getting icicles on his fins!', 30),
	(14, 15589, 'Blrglmrgl, that eye... huge! C\'Thun, Murky promises he\'s not tasty, too fishy for your liking!', 40),
	(15, 14834, 'Mrglglgl, Hakkar the Soulflayer! Murky\'s soul is... umm, too soggy? Maybe try someone else!', 30),
	(16, 37674, 'Oh look %s! It\'s that time of the month again--err I mean time of year again! Love is in the Air!', 25),
	(17, 14822, 'Mrglglgl! Step right up, %s! The Darkmoon Faire\'s wonders await us, full of games and shiny prizes!', 25),
	(18, 14508, 'Mrglglgl! The Arena calls, %s! Will Murky become the champion of the Gurubashi? Only time will tell!', 80),
	(19, 4624, 'Blrglmrgl! Booty Bay, %s! Pirates and treasures, oh my! Murky\'s ready to dive for some booty!', 60),
	(20, 19175, 'Mrglglgl! Look, %s! Noblegarden eggs everywhere! Murky wonders if any of them contain a tiny fishy friend!', 30),
	(21, 18927, 'Blrglmrgl! Such pretty colors, %s! Murky\'s ready to hop into the fun of Noblegarden. Let\'s find those eggs before they... hatch?', 30),
	(22, 3977, 'Mrglglgl! Oh no, %s! Murky\'s seen this in a fishy nightmare. When Whitemane prays, be ready for a surprise rise!', 25),
	(23, 4542, 'Blrglmrgl! Shh, %s, Murky found a secret! High Inquisitor Fairbanks is hiding! Maybe he has hidden fish snacks too?', 8),
	(24, 3497, 'Mrglglgl! Ratchet\'s docks are bustling, %s! Watch your pockets, Murky hears this place is swarming with sneaky pirates!', 50),
	(25, 400117, 'Oh look, it\'s Runok Wildmane! I hear he gives the most tasty buffs!', 5),
	(26, 2784, 'Mrglglgl! King Bronzebeard, your forge burns as bright as your spirit! Murky feels the warmth, even in his wet fins!', 25),
	(27, 1356, 'Mrglglgl! Look at all these explorers with their maps and relics, always ready for the next big discovery!', 45),
	(28, 7937, 'So many gadgets and gizmos around here, High Tinker Mekkatorque must be a genius inventor!', 25),
	(29, 100156, 'Murky thinks Elraveth Firetouched is very pretty indeed! He feels bad for her people though...', 15),
	(30, 100157, 'Poor Eldreth Spellshard...  Murky knows what it is like to lose a good friend. Mrglglgl...', 5),
	(31, 900003, 'Blrglmrgl! Wow! That is one big scary monster, %s! Better watch your step or you yourself may be getting stepped on!', 50),
	(32, 582, 'Mrglglgl! Westfall is so pretty this time of year! %s, we should go to the coast and visit my cousins if we get a chance. They\'re very nice people!', 50),
	(33, 126, 'MRGLGLGL!!! Don\'t be mean to %s! Stupid Coastrunner, you\'re one of the bad cousins...', 4),
	(34, 6491, 'Murky thinks it is sad that people die sometimes... But then he thinks about Murloc Heaven and isn\'t sad anymore!', 18),
	(35, 464, 'Mrglglgl! This looks like a cozy place to stay. Murky wonders if it is new? He\'s pretty sure this wasn\'t here before...', 45),
	(36, 1284, 'Mrglglgl... There\'s someone unsettling about this place... Murky thinks Archbishop Benedictus is up to no good...', 35),
	(37, 400125, 'Mrglglgl! Be careful %s! There\'s someone suspicious looking up ahead. He seems like he could be trouble...', 35),
	(38, 8929, 'Mrglglgl! Oh look %s! It\'s Princess Moira Bronzebeard! She looks so happy! Murky wonders if her father knows her secret.', 55),
	(39, 709, 'Mrglglgl! These big ogres make Murky feel small!', 30),
	(40, 731, 'Rlrllglrl! Murky sees you, stripey foe, ready for a dance, mrgl?', 25),
	(41, 750, 'Glrglmrgl, Inkspewer, your ink clouds not just water, but kinship too.', 15),
	(42, 886500, 'Blrglmrgl! Kraz\'jalah! What big teeth you have!', 25);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
