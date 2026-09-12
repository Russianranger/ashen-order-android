#include "PlayerMapChangeHandler.h"
#include "Chat.h"

std::map<ObjectGuid, std::vector<Creature*>> playerSummonedCreatures;

void AddSummonedCreature(Player* player, Creature* creature)
{
    if (!player || !creature)
        return;

    playerSummonedCreatures[player->GetGUID()].push_back(creature);
}

void RemoveSummonedCreatures(Player* player)
{
    if (!player)
        return;

    auto itr = playerSummonedCreatures.find(player->GetGUID());
    if (itr != playerSummonedCreatures.end())
    {
        for (Creature* creature : itr->second)
        {
            if (creature != nullptr && creature->IsAlive())
            {
                // Ensure the creature is still valid and on a valid map
                if (Map* map = creature->GetMap())
                {
                    if (map->IsDungeon() || map->IsRaid() || map->IsBattlegroundOrArena())
                    {
                        creature->DespawnOrUnsummon();
                    }
                }
            }
        }
        playerSummonedCreatures.erase(itr);

        if (player->GetSession())
        {
            ChatHandler(player->GetSession()).SendSysMessage("You have left your instance challenge. Challenges have been reset.");
        }
    }
}

void AddSC_custom_player_map_change_handler()
{
    new PlayerMapChangeHandler();
}
