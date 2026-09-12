#ifndef MURKY_H
#define MURKY_H

#include "ScriptMgr.h"
#include "Creature.h"
#include "CreatureAI.h"
#include "GameObject.h"
#include "DatabaseEnv.h"
#include "Player.h"
#include "Pet.h"
#include "Log.h"
#include <vector>
#include <string>

enum MurkyEvents {
    EVENT_GIVE_GIFT1 = 1, // 3 minute scheduler with 5% chance
    EVENT_GIVE_GIFT2,     // 1 minute scheduler with 1.67% chance
    EVENT_JAXON_RESPOND_TO_MURKY, // Event for Officer Jaxon to respond to Murky
    EVENT_MURKY_RESPOND_TO_JAXON,
    EVENT_SYLVANAS_RESPOND_TO_MURKY,
    EVENT_MURKY_RESPOND_TO_SYLVANAS,
    EVENT_TIRANDE_RESPOND_TO_MURKY,
    EVENT_MURKY_RESPOND_TO_TIRANDE,
    EVENT_JAINA_RESPOND_TO_MURKY,
    EVENT_MURKY_RESPOND_TO_JAINA,
};

struct BossDialogue {
    uint32 creatureId;
    std::string dialogue;
    float range;
    bool hasSpoken;
};

struct DelayedText {
    std::string text;
    uint32 delay;
};

// Singleton class to manage boss dialogues
class BossDialogueManager {
public:
    static BossDialogueManager& GetInstance() {
        static BossDialogueManager instance;
        return instance;
    }

    const std::vector<BossDialogue>& GetBossDialogues() const {
        return bossDialogues;
    }

private:
    std::vector<BossDialogue> bossDialogues;

    BossDialogueManager() {
        LoadBossDialogues(); // Load dialogues when the singleton is first accessed
    }

    void LoadBossDialogues(); // Declare the function to load dialogues from the database
};

class npc_murky : public CreatureScript {
public:
    npc_murky();
    
    struct npc_murkyAI : public ScriptedAI {
        npc_murkyAI(Creature* creature);

        void Reset() override;
        void UpdateAI(uint32 diff) override;
        void GiveGift();
        void CheckForChests();
        void CheckForBosses();

        void ReceiveEmote(Player* player, uint32 emote) override;
        void GreetOwner();

    private:
        uint32 GreetTimer;
        std::vector<BossDialogue> bossDialogues;
        std::set<ObjectGuid> discoveredChests;
        std::list<DelayedText> delayedTexts;
        bool hasGreetedJaxon = false;
        bool hasGreetedSylvanas = false;
        bool hasGreetedTirande = false;
        bool hasGreetedJaina = false;
        bool hasBossDialogueTriggered = false;
    };

    CreatureAI* GetAI(Creature* creature) const override;
    bool OnGossipHello(Player* player, Creature* creature) override;
};

void AddSC_npc_murky();

#endif // MURKY_H
