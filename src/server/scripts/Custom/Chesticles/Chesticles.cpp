#include "ScriptMgr.h"
#include "GameObject.h"
#include "Player.h"
#include "Log.h"
#include "Config.h"
#include "Random.h"
#include <set>
#include <cstdint>

class go_inconspicuous_chest : public GameObjectScript
{
public:
    go_inconspicuous_chest() : GameObjectScript("go_inconspicuous_chest") {}

    mutable std::set<uint64_t> lootedChests; 

    void AddGoldToChest(Player* player, GameObject* go) const
    {
        if (!player || !go)
        {
            LOG_ERROR("entities.gameobject", "go_inconspicuous_chest: Player or GameObject is null!");
            return;
        }

        uint64_t chestGUID = go->GetGUID().GetRawValue();

        // Check if the chest has already been looted for gold by any player
        if (lootedChests.find(chestGUID) != lootedChests.end())
            return; // Chest already looted for gold, do nothing

        float goldMultiplier = sConfigMgr->GetFloatDefault("InconspicuousChestGoldMultiplier", 1.0f);
        float gold = 1025.0f * goldMultiplier;

        // Gold amount calculation based on player level
        switch (player->GetLevel() / 10)
        {
        case 0: gold *= 0.105f; break;
        case 1: gold *= 0.130f; break;
        case 2: gold *= 0.185f; break;
        case 3: gold *= 0.245f; break;
        case 4: gold *= 0.350f; break;
        case 5: gold *= 0.500f; break;
        case 6: gold *= 0.650f; break;
        case 7: gold *= 0.850f; break;
        default: gold *= 1.000f; break;
        }

        // Randomize the final gold amount by a small margin (+/- 5%)
        float randomFactor = frand(0.95f, 1.05f);
        gold *= randomFactor;
        uint32 goldAmount = uint32(player->GetLevel() * gold);

        // Add gold to the existing loot
        Loot& loot = go->loot;
        loot.gold += goldAmount;

        // Mark this chest as looted for gold
        lootedChests.insert(chestGUID);
    }

    void OnLootStateChanged(GameObject* go, uint32 state, Unit* unit) override
    {
        if (state == GO_STATE_READY) // Chest is closed and ready to be looted again
        {
            // Remove the chest from the looted list
            uint64_t chestGUID = go->GetGUID().GetRawValue();
            lootedChests.erase(chestGUID);
        }
        else if (state == GO_ACTIVATED && unit && unit->IsPlayer())
        {
            AddGoldToChest(unit->ToPlayer(), go);
        }
    }
};

void AddSC_go_inconspicuous_chest()
{
    new go_inconspicuous_chest();
}
