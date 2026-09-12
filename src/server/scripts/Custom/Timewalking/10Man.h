// 10Man.h
#ifndef _10MAN_H_
#define _10MAN_H_

#include "Player.h"
#include "Creature.h"

extern std::list<uint32> challengeAuras;

void DistributeChallengeRewards(Player* player, Creature* boss, uint32 baseRewardLevel, bool isDungeon);

#endif // _10MAN_H_
