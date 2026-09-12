// This is part of the cleanup script for dungeon challenges.

#ifndef PLAYER_MAP_CHANGE_HANDLER_H
#define PLAYER_MAP_CHANGE_HANDLER_H

#include "Player.h"
#include "ScriptMgr.h"
#include "Creature.h"
#include "Map.h"
#include "TemporarySummon.h"

#include <map>
#include <vector>

// Global map to track summoned creatures per player
extern std::map<ObjectGuid, std::vector<Creature*>> playerSummonedCreatures;

// Function to add summoned creature to the global map
void AddSummonedCreature(Player* player, Creature* creature);

// Function to remove all summoned creatures for a player
void RemoveSummonedCreatures(Player* player);

class PlayerMapChangeHandler : public PlayerScript
{
public:
    PlayerMapChangeHandler() : PlayerScript("PlayerMapChangeHandler") {}

    void OnMapChanged(Player* player) override
    {
        RemoveSummonedCreatures(player);
    }

    void OnLogout(Player* player) override
    {
        RemoveSummonedCreatures(player);
    }
};

#endif // PLAYER_MAP_CHANGE_HANDLER_H
