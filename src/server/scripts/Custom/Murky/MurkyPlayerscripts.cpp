#include "Player.h"
#include "ScriptMgr.h"
#include "World.h"
#include "Creature.h"
#include <array>

class MurkyOnKillPlayerScript : public PlayerScript
{
public:
    MurkyOnKillPlayerScript() : PlayerScript("MurkyOnKillPlayerScript") {}

    void OnCreatureKill(Player* player, Creature* creature) override
    {
        if (creature->GetCreatureTemplate()->rank != CREATURE_ELITE_WORLDBOSS)
            return;

        if (Creature* murky = GetNearbyMurky(player))
        {
                static const std::array<std::string, 15> dialogues = { {
                "Mrglglglg, " + player->GetName() + "! You mrgl'd " + creature->GetName() + " good!",
                "Mrglgl! " + player->GetName() + " big hero, mrgl " + creature->GetName() + " go down!",
                "Whoa! Big win, " + player->GetName() + "! Murky sees, Murky approves, mrglmrgl!",
                "Mrgl mrgl, wow! " + player->GetName() + " and Murky, best team for fishy business!",
                "Splish splash, " + player->GetName() + " taking out trash! Murky likes, mrglgl!",
                "Murky not see such fight before! " + player->GetName() + " strong like tide, mrgl!",
                "Mrgly victory, " + player->GetName() + "! You swim in triumph like Murky in water!",
                "Glub glub, " + player->GetName() + "! You float to top, enemies sink to bottom, mrglgl!",
                "Mrgl dance time, " + player->GetName() + "! Your bravery makes waves, big splash!",
                "Wowee, " + player->GetName() + "! Murky think you more slippery than fish!",
                "Murky happy, " + player->GetName() + " happy! Enemies not so happy, mrglglgl!",
                "Like fish in barrel, " + player->GetName() + "! You catch big one this time, mrgl!",
                "Murky give fins up, " + player->GetName() + "! You reel in big win, mrglgl!",
                "Fishy friends cheer for " + player->GetName() + "! Big catch of the day, mrglgl!"
                } };

                std::string selectedDialogue = dialogues[urand(0, dialogues.size() - 1)];
                murky->Say(selectedDialogue, LANG_UNIVERSAL);
        }
    }

private:
    Creature* GetNearbyMurky(Player* player)
    {
        std::list<Creature*> murkyList;
        Acore::AllCreaturesOfEntryInRange checker(player, 15186, 25.0f);
        Acore::CreatureListSearcher<Acore::AllCreaturesOfEntryInRange> searcher(player, murkyList, checker);
        Cell::VisitAllObjects(player, searcher, 25.0f);

        if (!murkyList.empty())
            return murkyList.front(); 

        return nullptr;
    }
};

void AddSC_custom_player_murky_scripts()
{
    new MurkyOnKillPlayerScript();
}
