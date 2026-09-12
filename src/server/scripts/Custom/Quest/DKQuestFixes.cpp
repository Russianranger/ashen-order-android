#include "GameObject.h"
#include <map>
#include <chrono>
#include "ScriptMgr.h"
#include "Player.h"
#include "QuestDef.h"
#include "Timer.h"

//by leewheel
// DK quest line fix
class DKQuestBugFix : public PlayerScript
{
public:
    DKQuestBugFix() : PlayerScript("DKQuestBugFix") {}

    void OnLogin(Player* player) override
    {
        if (!player->IsClass(CLASS_DEATH_KNIGHT))
        {
            return;
        }

        if ((player->HasQuest(aurfangs_blessing_Quest) || player->HasQuest(where_kings_walk)) && player->GetAreaId() != ScarletEnclave)
        {
            player->SetPhaseMask(1, true);
            if (player->GetTeamId() == TEAM_ALLIANCE)
            {
                player->AddAura(Back_To_StromWind, player);
            }
            if (player->GetTeamId() == TEAM_HORDE)
            {
                player->AddAura(Back_To_Orgrimmar, player);
            }
        }

        if (player->GetQuestStatus(Taking_Back_Acherus) == QUEST_STATUS_REWARDED &&
            player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) != QUEST_STATUS_COMPLETE &&
            player->GetAreaId() == ScarletEnclave)
        {
            player->SetPhaseMask(448, true);
            if (player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) == QUEST_STATUS_INCOMPLETE &&
                player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) != QUEST_STATUS_NONE)
            {
                player->AddAura(The_Might_of_Mograine, player);
            }
        }
    }

    // DK Last Quest
    void OnUpdateArea(Player* player, uint32 oldArea, uint32 newArea) override
    {
        if (!player->IsClass(CLASS_DEATH_KNIGHT))
        {
            return;
        }

        if ((player->HasQuest(aurfangs_blessing_Quest) || player->HasQuest(where_kings_walk)) && player->GetAreaId() != ScarletEnclave)
        {
            player->SetPhaseMask(1, true);
            if (player->GetTeamId() == TEAM_ALLIANCE)
            {
                player->AddAura(Back_To_StromWind, player);
            }
            return; // Early return to avoid unnecessary checks
        }

        if ((player->HasQuest(aurfangs_blessing_Quest) || player->HasQuest(where_kings_walk) || player->HasQuest(Taking_Back_Acherus)) && player->GetAreaId() == ScarletEnclave)
        {
            player->SetPhaseMask(448, true);
        }
    }

    void OnUpdate(Player* player, uint32 diff) override
    {
        if (!player->IsClass(CLASS_DEATH_KNIGHT))
        {
            return;
        }

        // Check if the player has not completed the quest 12593
        if (player->GetQuestStatus(12593) != QUEST_STATUS_REWARDED)
        {
            return;
        }

        // Check if the player has completed the aurfangs_blessing_Quest or where_kings_walk quests or The_Battle_For_The_Ebon_Hold
        if ((player->GetQuestStatus(aurfangs_blessing_Quest) == QUEST_STATUS_REWARDED ||
            player->GetQuestStatus(where_kings_walk) == QUEST_STATUS_REWARDED) && player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) == QUEST_STATUS_REWARDED)
        {
            return;
        }

        // Timer logic
        static uint32 timer = 0;
        timer += diff;

        // Execute every 3.5 seconds
        if (timer < 3500)
        {
            return;
        }

        if (player->GetQuestStatus(Taking_Back_Acherus) == 6 &&
            player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) != 1
            && (player->GetQuestStatus(where_kings_walk) == 3) || player->GetQuestStatus(aurfangs_blessing_Quest) == 3)
        {
            if (player->GetAreaId() == ScarletEnclave)
            {
                player->SetPhaseMask(448, true);
            }
            if (player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) == 3 &&
                player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) != 0)
            {
                player->AddAura(The_Might_of_Mograine, player);
            }
        }

        if (player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) == QUEST_STATUS_INCOMPLETE)
        {
            if (!player->HasAura(The_Might_of_Mograine))
            {
                player->AddAura(The_Might_of_Mograine, player);
            }
        }

        if (player->GetTeamId() == TEAM_HORDE &&
            player->GetQuestStatus(aurfangs_blessing_Quest) == 1 &&
            player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) == 6)
        {
            if (player->GetAreaId() != ScarletEnclave)
            {
                player->SetPhaseMask(1, true);
            }
            player->AddAura(Back_To_Orgrimmar, player);
        }

        if (player->GetZoneId() == 1637 || player->GetZoneId() == 14)
        {
            if (player->GetQuestStatus(aurfangs_blessing_Quest) == 1 &&
                player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) == 6)
            {
                player->AddAura(Back_To_Orgrimmar, player);
            }
        }

        // Check Player has buff 58551
        if (player->HasAura(Back_To_Orgrimmar))
        {
            // List cast apple banana spell creature
            std::list<Creature*> creaturesInRange;
            player->GetCreatureListWithEntryInGrid(creaturesInRange, 3296, 30.0f);
            player->GetCreatureListWithEntryInGrid(creaturesInRange, 31416, 30.0f);
            player->GetCreatureListWithEntryInGrid(creaturesInRange, 18950, 30.0f);
            player->GetCreatureListWithEntryInGrid(creaturesInRange, 14304, 30.0f);
            player->GetCreatureListWithEntryInGrid(creaturesInRange, 3344, 30.0f);
            player->GetCreatureListWithEntryInGrid(creaturesInRange, 3403, 30.0f);
            player->GetCreatureListWithEntryInGrid(creaturesInRange, 4047, 30.0f);
            player->GetCreatureListWithEntryInGrid(creaturesInRange, 3367, 30.0f);


            // overy creature ran spell 
            for (Creature* creature : creaturesInRange)
            {
                if (creature)
                {
                    uint32 spellId = urand(0, 1) ? Rotten_Apple_Toss : Rotten_Banana_Toss;
                    creature->CastSpell(player, spellId, false);
                }
            }
        }

        if (player->GetTeamId() == TEAM_ALLIANCE)
        {
            if (player->GetQuestStatus(where_kings_walk) == 1 &&
                player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) == 6)
            {
                if (player->GetAreaId() != ScarletEnclave)
                {
                    player->SetPhaseMask(1, true);
                }

                player->AddAura(Back_To_StromWind, player);
            }
        }

        if (player->GetZoneId() == 1519 || player->GetZoneId() == 12)
        {
            if (player->GetQuestStatus(where_kings_walk) == 1 &&
                player->GetQuestStatus(The_Battle_For_The_Ebon_Hold) == 6)
            {
                player->AddAura(Back_To_StromWind, player);
            }
        }


        if (player->HasAura(Back_To_StromWind))
        {
            // Royal Guard 
            std::list<Creature*> creaturesInRange;
            player->GetCreatureListWithEntryInGrid(creaturesInRange, 1756, 30.0f);
            for (Creature* creature : creaturesInRange)
            {
                if (creature)
                {
                    uint32 spellId = urand(0, 1) ? Rotten_Apple_Toss : Rotten_Banana_Toss;
                    creature->CastSpell(player, spellId, false);
                }
            }
        }

        // Reset timer
        timer = 0;
    }

    // The Battle For The Ebon Hold
    void OnPlayerCompleteQuest(Player* player, Quest const* quest) override
    {
        if (quest->GetQuestId() == The_Battle_For_The_Ebon_Hold && player->GetAura(The_Might_of_Mograine))
        {
            player->RemoveAura(The_Might_of_Mograine);
        }
    }

private:
    uint32 Taking_Back_Acherus = 13165;
    uint32 The_Battle_For_The_Ebon_Hold = 13166;
    uint32 The_Light_of_Dawn = 12801;
    uint32 aurfangs_blessing_Quest = 13189;
    uint32 where_kings_walk = 13188;
    uint32 Kalimdor_zone_orgrimmar = 1637;
    uint32 EasternKingdoms_zone_stormwind_city_Gate = 7486;
    uint32 ScarletEnclave = 4544;
    uint32 Back_To_StromWind = 58530;
    uint32 Back_To_StromWind_Spell = 58533;
    uint32 Back_To_Orgrimmar = 58551;
    uint32 Back_To_Orgrimmar_Spell = 58552;
    uint32 The_Might_of_Mograine = 58361;
    uint32 Rotten_Apple_Toss = 58509;
    uint32 Rotten_Banana_Toss = 58513;

};



void AddSC_DKQuestBugFix()
{
    new DKQuestBugFix();
}
