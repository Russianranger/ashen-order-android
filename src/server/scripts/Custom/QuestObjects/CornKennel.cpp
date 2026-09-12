#include "ScriptMgr.h"
#include "GameObject.h"
#include "Player.h"
#include <map>
#include <chrono>

class gobject_corn_kennels : public GameObjectScript
{
public:
    gobject_corn_kennels() : GameObjectScript("gobject_corn_kennels") {}

    std::map<std::pair<uint64, uint64>, time_t> interactionCooldowns;

    bool OnGossipHello(Player* player, GameObject* go) override
    {
        uint64 playerGuid = player->GetGUID().GetCounter();
        uint64 gameObjectGuid = go->GetGUID().GetCounter();

        std::pair<uint64, uint64> playerGameObjectPair = std::make_pair(playerGuid, gameObjectGuid);
        auto search = interactionCooldowns.find(playerGameObjectPair);

        time_t currentTime = time(nullptr);

        if (search != interactionCooldowns.end())
        {
            time_t lastInteractionTime = search->second;
            if (difftime(currentTime, lastInteractionTime) < 10)
            {
                return true; 
            }
        }

        interactionCooldowns[playerGameObjectPair] = currentTime;

        go->DespawnOrUnsummon(std::chrono::milliseconds(3000));

        return false; 
    }
};

void AddSC_gobject_corn_kennels()
{
    new gobject_corn_kennels();
}
