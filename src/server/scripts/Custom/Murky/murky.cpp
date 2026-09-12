#include "murky.h"

void BossDialogueManager::LoadBossDialogues() {
    bossDialogues.clear();
    QueryResult result = WorldDatabase.Query("SELECT creatureId, dialogue, `range` FROM murky_los_dialogues");
    if (!result) return;

    do {
        Field* fields = result->Fetch();
        BossDialogue dialogue = {
            fields[0].Get<uint32>(),  // creatureId
            fields[1].Get<std::string>(), // dialogue
            fields[2].Get<float>(),   // range
            false  // hasSpoken, always initialized to false
        };
        bossDialogues.push_back(dialogue);
    } while (result->NextRow());
}

npc_murky::npc_murky() : CreatureScript("npc_murky") {}

npc_murky::npc_murkyAI::npc_murkyAI(Creature* creature) : ScriptedAI(creature), GreetTimer(1000) {
    bossDialogues = BossDialogueManager::GetInstance().GetBossDialogues();
}

void npc_murky::npc_murkyAI::Reset() {
    for (auto& dialogue : bossDialogues) {
        dialogue.hasSpoken = false;
    }
    discoveredChests.clear();

    events.CancelEvent(EVENT_GIVE_GIFT1);
    events.CancelEvent(EVENT_GIVE_GIFT2);

    events.ScheduleEvent(EVENT_GIVE_GIFT1, 180000); // 3-minute event
    events.ScheduleEvent(EVENT_GIVE_GIFT2, 60000);  // 1-minute event
}


bool npc_murky::OnGossipHello(Player* player, Creature* creature) {
    uint32 npcFlags = creature->GetUInt32Value(UNIT_NPC_FLAGS);

    npcFlags &= ~(UNIT_NPC_FLAG_BANKER | UNIT_NPC_FLAG_AUCTIONEER | UNIT_NPC_FLAG_REPAIR | UNIT_NPC_FLAG_VENDOR | UNIT_NPC_FLAG_INNKEEPER);
    npcFlags |= UNIT_NPC_FLAG_GOSSIP;

    if (player->HasItemCount(852, 1)) {
        npcFlags |= UNIT_NPC_FLAG_BANKER;
    }
    if (player->HasItemCount(853, 1)) {
        npcFlags |= UNIT_NPC_FLAG_AUCTIONEER;
    }
    if (player->HasItemCount(854, 1)) {
        npcFlags |= UNIT_NPC_FLAG_REPAIR;
        npcFlags |= UNIT_NPC_FLAG_VENDOR;
    }
    if (player->HasItemCount(855, 1)) {
        npcFlags |= UNIT_NPC_FLAG_INNKEEPER;
    }

    if (npcFlags == UNIT_NPC_FLAG_GOSSIP) {
        ChatHandler(player->GetSession()).PSendSysMessage("Certain items can access more features for Murky. Maybe you should do a bit of treasure hunting!");
    }

    creature->SetUInt32Value(UNIT_NPC_FLAGS, npcFlags);
    return false; 
}

void npc_murky::npc_murkyAI::UpdateAI(uint32 diff) {
    if (GreetTimer) {
        if (GreetTimer <= diff) {
            GreetOwner();
            GreetTimer = 0;
        }
        else {
            GreetTimer -= diff;
        }
    }

    // Check for nearby bosses and chests
    CheckForBosses();
    CheckForChests();

    // Jaxon
    if (!hasGreetedJaxon) {
        if (Creature* officerJaxon = me->FindNearestCreature(14423, 15.0f, true)) {
            me->Say("Hello, Officer Jaxon!", LANG_UNIVERSAL);
            hasGreetedJaxon = true;  

            events.ScheduleEvent(EVENT_JAXON_RESPOND_TO_MURKY, 3000); 
        }
    }

    // Sylvanas
    if (!hasGreetedSylvanas) {
        if (Creature* sylvanas = me->FindNearestCreature(10181, 10.0f, true)) {
            me->Say("Mrglglgl! The dark lady Sylvanas, Murky is in awe of your might!", LANG_UNIVERSAL);
            hasGreetedSylvanas = true;

            events.ScheduleEvent(EVENT_SYLVANAS_RESPOND_TO_MURKY, 3000); 
        }
    }

    // Tirande
    if (!hasGreetedTirande) {
        if (Creature* tirande = me->FindNearestCreature(7999, 15.0f, true)) {
            me->Say("Mrglglgl! Lady Tirande, Murky honors your moonlit grace!", LANG_UNIVERSAL);
            hasGreetedTirande = true;

            events.ScheduleEvent(EVENT_TIRANDE_RESPOND_TO_MURKY, 3000);
        }
    }

    // Jaina
    if (!hasGreetedJaina) {
        if (Creature* jaina = me->FindNearestCreature(4968, 10.0f, true)) {
            me->Say("Mrglglgl! Lady Jaina, Murky admires your wisdom and strength!", LANG_UNIVERSAL);
            hasGreetedJaina = true;

            events.ScheduleEvent(EVENT_JAINA_RESPOND_TO_MURKY, 3000);
        }
    }

    for (auto itr = delayedTexts.begin(); itr != delayedTexts.end();) {
        if (itr->delay <= diff) {
            me->Say(itr->text, LANG_UNIVERSAL);
            itr = delayedTexts.erase(itr);
        }
        else {
            itr->delay -= diff;
            ++itr;
        }
    }
    events.Update(diff);

    while (uint32 eventId = events.ExecuteEvent()) {
        switch (eventId) {
        case EVENT_GIVE_GIFT1:
            if (urand(0, 35) == 0) {
                GiveGift();
            }

            events.ScheduleEvent(EVENT_GIVE_GIFT1, 180000); // Reschedule every 3 minutes 
            break;

        case EVENT_GIVE_GIFT2:
            if (urand(0, 60) == 0) {
                GiveGift();
            }
            events.ScheduleEvent(EVENT_GIVE_GIFT2, 60000); // Reschedule every 1 minute 
            break;
        // Jaxon    
        case EVENT_JAXON_RESPOND_TO_MURKY:
            if (Creature* officerJaxon = me->FindNearestCreature(14423, 30.0f, true)) {
                officerJaxon->Say("Hello, Murky! Keeping the peace as always?", LANG_UNIVERSAL);
                officerJaxon->HandleEmoteCommand(EMOTE_ONESHOT_WAVE);

                events.ScheduleEvent(EVENT_MURKY_RESPOND_TO_JAXON, 3000); 
            }
            break;

        case EVENT_MURKY_RESPOND_TO_JAXON:
            me->Say("Mrglglgl, always keeping the peace, Officer Jaxon!", LANG_UNIVERSAL);
            break;
        // Sylvanas
        case EVENT_SYLVANAS_RESPOND_TO_MURKY:
            if (Creature* sylvanas = me->FindNearestCreature(10181, 30.0f, true)) {
                sylvanas->Say("Your reverence is noted, Murloc. The Forsaken welcome you and yours.", LANG_UNIVERSAL);
                events.ScheduleEvent(EVENT_MURKY_RESPOND_TO_SYLVANAS, 3000);
            }
            break;

        case EVENT_MURKY_RESPOND_TO_SYLVANAS:
            me->Say("Thank you, noble Sylvanas! Murky is grateful!", LANG_UNIVERSAL);
            break;
        // Tirande
        case EVENT_TIRANDE_RESPOND_TO_MURKY:
            if (Creature* tirande = me->FindNearestCreature(7999, 30.0f, true)) {
                tirande->Say("The light of Elune guide you, little one. May your path be clear.", LANG_UNIVERSAL);
                tirande->HandleEmoteCommand(EMOTE_ONESHOT_BOW);

                events.ScheduleEvent(EVENT_MURKY_RESPOND_TO_TIRANDE, 3000);
            }
            break;

        case EVENT_MURKY_RESPOND_TO_TIRANDE:
            me->Say("Mrglglgl, thank you, great priestess! Murky feels the moon's power!", LANG_UNIVERSAL);
            break;
        // Jaina
        case EVENT_JAINA_RESPOND_TO_MURKY:
            if (Creature* jaina = me->FindNearestCreature(4968, 30.0f, true)) {
                jaina->Say("Thank you, Murky. Your courage in the face of darkness is commendable.", LANG_UNIVERSAL);
                jaina->HandleEmoteCommand(EMOTE_ONESHOT_BOW);

                events.ScheduleEvent(EVENT_MURKY_RESPOND_TO_JAINA, 3000);
            }
            break;

        case EVENT_MURKY_RESPOND_TO_JAINA:
            me->Say("Mrglglgl, Murky will always stand against the darkness, Lady Jaina!", LANG_UNIVERSAL);
            break;
        }
    }
}

void npc_murky::npc_murkyAI::GiveGift() {
    if (!me->IsSummon() || !me->ToTempSummon()->GetSummoner() || !me->ToTempSummon()->GetSummoner()->IsPlayer()) {
        LOG_ERROR("scripts", "Note, Not an error: Murky tried to give a gift, but has no valid owner.");
        return;
    }

    Player* owner = me->GetOwner()->ToPlayer();
    if (!owner) return;

    if (me->GetDistance(owner) > 50.0f) {
        LOG_ERROR("scripts", "Note, not an error: Murky's owner is too far away to receive a gift.");
        return;
    }

    uint32 itemId = 0;
    uint32 playerLevel = owner->getLevel();

    // Determine the item based on player level
    if (playerLevel <= 15) itemId = 6643;
    else if (playerLevel <= 25) itemId = 6645;
    else if (playerLevel <= 35) itemId = 6647;
    else if (playerLevel <= 45) itemId = urand(0, 1) ? 21164 : 8366;
    else if (playerLevel <= 55) itemId = urand(0, 1) ? 21243 : 13881;
    else itemId = 13891;

    if (urand(0, 8) < 1) itemId = 4500; // 13% chance

    if (itemId == 0) return;

    const char* itemDialogues[] = {
        "Mrglglgl, look what Murky found for you, %s!",
        "Blrglmrgl, Murky has a gift for you, %s! Hope you like it!",
        "Mrglglgl, Murky went fishing and look what he caught for %s!",
        "Blrglmrgl, a special treasure just for you, %s! Murky hopes it helps!",
        "Mrglglgl, Murky braved the waters and found this just for %s!"
    };

    std::string message = itemDialogues[urand(0, sizeof(itemDialogues) / sizeof(char*) - 1)];
    size_t pos = message.find("%s");
    if (pos != std::string::npos) {
        message.replace(pos, 2, owner->GetName().c_str());
    }

    owner->AddItem(itemId, 1);
    me->Say(message.c_str(), LANG_UNIVERSAL);
}

void npc_murky::npc_murkyAI::CheckForChests() {
    std::list<GameObject*> chestList;
    me->GetGameObjectListWithEntryInGrid(chestList, 600010, 20.0f); 
    for (GameObject* chest : chestList) {
        float distance = me->GetDistance(chest);
        if (distance <= 12.0f && discoveredChests.find(chest->GetGUID()) == discoveredChests.end()) {
            const char* treasureDialogues[] = {
                "Mrglglgl! Murky's fins are twitching... Treasure might be near, %s!",
                "Blrglmrgl! Shh, %s! Murky senses hidden goodies around here!",
                "Mrglglgl! Oh, what's that? Murky feels something special nearby, %s!",
                "Blrglmrgl! Can you feel it, %s? There's something sneaky hidden here!",
                "Mrglglgl! Murky's got a nose for these things... Well, if he had a nose, that is! There's a hidden chest nearby, %s!"
            };
            std::string message = treasureDialogues[urand(0, sizeof(treasureDialogues) / sizeof(char*) - 1)];
            size_t pos = message.find("%s");
            if (pos != std::string::npos) {
                if (Unit* owner = me->GetOwner()) {
                    message.replace(pos, 2, owner->GetName());
                }
            }
            me->Say(message.c_str(), LANG_UNIVERSAL);
            me->PlayDirectSound(188058);
            // Summons invisible creature at chest's location with bubbles
            if (Creature* creature = me->SummonCreature(817262, chest->GetPositionX(), chest->GetPositionY(), chest->GetPositionZ(), 0.0f, TEMPSUMMON_TIMED_DESPAWN, 20000)) {
            }
            discoveredChests.insert(chest->GetGUID());
        }
    }

    // If the owner moves more than 25 yards away, stop dancing and follow the owner
    if (Unit* owner = me->GetOwner()) {
        float ownerDistance = me->GetDistance(owner);
        if (ownerDistance > 25.0f) {
            me->RemoveAllAuras();
            me->_RemoveAllAuraStatMods();
            me->GetMotionMaster()->MoveFollow(owner, PET_FOLLOW_DIST, PET_FOLLOW_ANGLE);
        }
    }
}

void npc_murky::npc_murkyAI::CheckForBosses() {
    for (auto& boss : bossDialogues) {
        if (!boss.hasSpoken) {
            if (Creature* creature = me->FindNearestCreature(boss.creatureId, boss.range, true)) {
                if (me->IsWithinLOSInMap(creature)) {
                    std::string message = boss.dialogue;
                    size_t pos = message.find("%s");
                    if (pos != std::string::npos) {
                        message.replace(pos, 2, me->GetOwner()->GetName());
                    }
                    me->Say(message, LANG_UNIVERSAL);
                    boss.hasSpoken = true;
                    hasBossDialogueTriggered = true;
                }
            }
        }
    }
}

void npc_murky::npc_murkyAI::ReceiveEmote(Player* player, uint32 emote) {
    static std::map<uint64, int> rudeEmoteCount; // Tracks the number of rude emotes per player
    switch (emote) {
    case TEXT_EMOTE_KISS:
    {
        const char* kissResponses[] = {
            "Mrglglgl, Murky feels all fluttery inside!",
            "Blrglmrgl, that's so nice!",
            "Mrglglgl, Murky not sure what to do!"
        };
        me->Say(kissResponses[urand(0, 2)], LANG_UNIVERSAL);
    }
    break;
    case TEXT_EMOTE_GREET:
    {
        const char* greetResponses[] = {
            "Mrglglgl, hi there! Murky's always happy to see friends!",
            "Blrglmrgl, greetings! Murky waves his fins in hello!",
            "Mrglglgl, hello! Murky's excited to meet you!"
        };
        me->Say(greetResponses[urand(0, sizeof(greetResponses) / sizeof(char*) - 1)], LANG_UNIVERSAL);
    }
    break;
    case TEXT_EMOTE_WAVE:
    {
        me->HandleEmoteCommand(EMOTE_ONESHOT_WAVE);
        const char* waveResponses[] = {
            "Mrglglgl! Murky waves back with his tiny fin!",
            "Blrglmrgl! Hi there, friend! Murky's happy to see you!",
            "Mrglglgl! Murky waves excitedly! Adventure awaits!",
            "Blrglmrgl! Murky's always ready to greet a friend with a wave!",
            "Mrglglgl! Is that a wave? Murky loves making new friends!"
        };
        me->Say(waveResponses[urand(0, sizeof(waveResponses) / sizeof(char*) - 1)], LANG_UNIVERSAL);
        break;
    }
    case TEXT_EMOTE_HELLO:
    {
        const char* helloResponses[] = {
            "Mrglglgl, oh! Hello there! Murky's pleased to meet you!",
            "Blrglmrgl, hello! Murky greets you with a splash!",
            "Mrglglgl, hi! Murky's always ready for a new friend!"
        };
        me->Say(helloResponses[urand(0, sizeof(helloResponses) / sizeof(char*) - 1)], LANG_UNIVERSAL);
    }
    break;
    case TEXT_EMOTE_CRY:
    {
        const char* cryResponses[] = {
            "Mrglglgl, every stormy sea calms down, friend. Murky's here!",
            "Blrglmrgl, remember, after the rain comes the rainbow! Murky believes in you!",
            "Mrglglgl, it's okay to feel sad, but remember, Murky's always by your side!",
            "Blrglmrgl, let's find some adventure to cheer you up!",
            "Mrglglgl, sometimes life's a bit murky, but together, we'll find the sunshine!"
        };
        DelayedText cryResponse = { cryResponses[urand(0, sizeof(cryResponses) / sizeof(char*) - 1)], 1500 };
        delayedTexts.push_back(cryResponse);
        break;
    }
    case TEXT_EMOTE_FART:
    {
        const char* fartResponses[] = {
            "Mrglglgl, what's that smell? Murky thought it was just seaweed!",
            "Blrglmrgl, phew! Murky might need a bubble for fresh air!",
            "Mrglglgl, everyone bubbles sometimes, right?"
        };
        DelayedText fartResponse = { fartResponses[urand(0, sizeof(fartResponses) / sizeof(char*) - 1)], 1000 };
        delayedTexts.push_back(fartResponse);
        break;
    }
    case TEXT_EMOTE_BURP:
    {
        const char* burpResponses[] = {
            "Mrglglgl, was that a bubble or a burp?",
            "Blrglmrgl, Murky thought that was a fish talking!",
            "Mrglglgl, that's quite a bubble you made, %s!",
            "Blrglmrgl, Murky's never heard such a melodious burp!",
            "Mrglglgl, was that the call of the deep, %s?"
        };
        std::string message = burpResponses[urand(0, sizeof(burpResponses) / sizeof(char*) - 1)];
        size_t pos = message.find("%s");
        if (pos != std::string::npos) {
            message.replace(pos, 2, player->GetName().c_str());
        }
        me->Say(message.c_str(), LANG_UNIVERSAL);
    }
    break;
    case TEXT_EMOTE_DANCE:
    {
        me->HandleEmoteCommand(EMOTE_ONESHOT_DANCE);
        const char* danceResponses[] = {
            "Mrglglgl, let's groove!",
            "Blrglmrgl, Murky loves this beat!",
            "Mrglglgl, dancing is the best!",
            "Mrglglgl! Shake those fins, %s!",
            "Blrglmrgl, you've got moves, %s!",
            "Blrglmrgl, dance like no one's watching, %s!",
            "Mrglglgl, you're a dancing star, %s!",
            "Blrglmrgl, keep the rhythm, %s! Murky's loving it!"
        };
        std::string message = danceResponses[urand(0, sizeof(danceResponses) / sizeof(char*) - 1)];
        size_t pos = message.find("%s");
        if (pos != std::string::npos) {
            message.replace(pos, 2, player->GetName().c_str());
        }
        me->Say(message.c_str(), LANG_UNIVERSAL);
    }
    break;
    case TEXT_EMOTE_PET:
    {
        const char* petResponses[] = {
            "Mrglglgl, that feels nice!",
            "Blrglmrgl, Murky likes pets!",
            "Mrglglgl, more pets please!"
        };
        me->Say(petResponses[urand(0, 2)], LANG_UNIVERSAL);
    }
    break;
    case TEXT_EMOTE_RUDE: {
        uint64 playerGUID = player->GetGUID().GetCounter();
        rudeEmoteCount[playerGUID]++;

        if (rudeEmoteCount[playerGUID] >= 3) {
            if (!player->IsInCombat()) {
                me->Say("Ok, you asked for it, prepare to meet my family!", LANG_UNIVERSAL);

                for (int i = 0; i < 8; ++i) {
                    float x = player->GetPositionX() + frand(-5.0f, 5.0f); // Randomize X within a 10-unit range
                    float y = player->GetPositionY() + frand(-5.0f, 5.0f); // Randomize Y within a 10-unit range
                    if (Creature* murloc = me->SummonCreature(285, x, y, player->GetPositionZ(), 0.0f, TEMPSUMMON_TIMED_DESPAWN, 60000)) {
                        murloc->AI()->AttackStart(player);
                    }
                }
            }
            else {
                me->Say("Murky sees you're busy... Maybe he shows you something another time!", LANG_UNIVERSAL);
            }
            me->DespawnOrUnsummon(2000);
            rudeEmoteCount[playerGUID] = 0;
            return;
        }

        const char* rudeResponses[] = {
            "Mrglglgl, Murky is hurt but still likes you!",
            "Blrglmrgl, why be mean when we can be friends?",
            "Mrglglgl, Murky forgives you, everyone has bad days!"
        };
        DelayedText rudeResponse = { rudeResponses[urand(0, sizeof(rudeResponses) / sizeof(char*) - 1)], 1000 };
        delayedTexts.push_back(rudeResponse);

        break;
    }
    case TEXT_EMOTE_LICK:
    {
        const char* lickResponses[] = {
            "Mrglglgl, hey! Murky's not a lollipop!",
            "Blrglmrgl, that tickles! Murky's scales are sensitive, you know!",
            "Mrglglgl, Murky tastes like the sea... or so Murky's been told!"
        };
        DelayedText lickResponse = { lickResponses[urand(0, sizeof(lickResponses) / sizeof(char*) - 1)], 500 };
        delayedTexts.push_back(lickResponse);
        break;
    }
    case TEXT_EMOTE_JOKE: {
        const char* jokeReactions[] = {
            "Mrglglgl, that's a good one!",
            "Blrglmrgl, Murky didn't see that coming!",
            "Mrglglgl, you're funny!",
            "Glrgrlgrl, Murky loves a good laugh!",
            "Blrlgrlg, you tickle Murky's fins!"
        };

        const char* murkyJokes[] = {
            "What do you call a fish with no eyes? Fsh!",
            "Why did the seaweed blush? Because the sea weed!",
            "How does a murloc like their fish? Wet!",
            "What's a murloc's favorite game? Swallow the leader!",
            "Why don't murlocs share their treasure? Because they're shellfish!"
        };

        DelayedText reaction = { jokeReactions[urand(0, 2)], 3000 };
        DelayedText joke = { murkyJokes[urand(0, 2)], 6000 };

        delayedTexts.push_back(reaction);
        delayedTexts.push_back(joke);
        break;
    }
    case TEXT_EMOTE_ROAR:
    {
        const char* roarResponses[] = {
            "Mrglglgl, oh no! You scared Murky!",
            "Blrglmrgl, that's a loud roar! Murky's impressed but also a bit frightened!",
            "Mrglglgl, Murky can roar too! Mrglllglglgl!",
            "Blrglmrgl, wow! Are you a dragon in disguise, %s?",
            "Mrglglgl, such power! Murky wants to learn how to roar like that!"
        };

        std::string message = roarResponses[urand(0, sizeof(roarResponses) / sizeof(char*) - 1)];
        size_t pos = message.find("%s");
        if (pos != std::string::npos) {
            message.replace(pos, 2, player->GetName().c_str());
        }

        DelayedText roarResponse = { message, 1500 };
        delayedTexts.push_back(roarResponse);
        break;
    }
    
    case TEXT_EMOTE_FLIRT:
    {
        const char* flirtResponses[] = {
            "Mrglglgl, Murky's not sure what to do but feels happy!",
            "Blrglmrgl, oh, you make Murky blush!",
            "Blrglmrgl, Murky thinks you're great too!",
            "Mrglglgl, Murky feels all warm and bubbly inside!"
        };
        DelayedText flirtResponse = { flirtResponses[urand(0, 2)], 2500 };
        delayedTexts.push_back(flirtResponse);
        break;
    }
    case TEXT_EMOTE_CHEER:
    {
        const char* cheerResponses[] = {
            "Mrglglgl, Murky's all cheered up thanks to you!",
            "Blrglmrgl, yay! You're cheering for Murky?",
            "Mrglglgl, Murky can feel the positive vibes!",
            "Blrglmrgl, cheers, friend! Murky feels ready to tackle any adventure!"
        };
        DelayedText cheerResponse = { cheerResponses[urand(0, sizeof(cheerResponses) / sizeof(char*) - 1)], 1000 };
        delayedTexts.push_back(cheerResponse);
        break;
    }
    case TEXT_EMOTE_CLAP:
    {
        const char* clapResponses[] = {
            "Mrglglgl, Murky appreciates your applause!",
            "Blrglmrgl, oh, you're clapping for Murky? Thank you!",
            "Mrglglgl, your claps make Murky's heart swim in joy!",
            "Blrglmrgl, such warm applause! Murky feels like a star!"
        };
        DelayedText clapResponse = { clapResponses[urand(0, sizeof(clapResponses) / sizeof(char*) - 1)], 1500 };
        delayedTexts.push_back(clapResponse);
        break;
    }
    }
}

void npc_murky::npc_murkyAI::GreetOwner() {
    if (hasBossDialogueTriggered) return;
    
    Unit* owner = me->GetOwner();
    if (!owner || owner->GetTypeId() != TYPEID_PLAYER)
        return;

    std::string playerName = owner->GetName();
    std::vector<std::string> dialogues;

    uint32 zoneId = me->GetZoneId();
    switch (zoneId)
    {
    case 1519: // Stormwind
        dialogues = {
            "Mrglglgl! Murky loves the canals of Stormwind, " + playerName + "!",
            "Mrrrglgl! So many humans, so much hustle and bustle, " + playerName + "!",
            "Mrglglgl! The King's statue is so big, " + playerName + "! Murky feels tiny.",
            "Mrrrglgl! All these flags and lions, " + playerName + "! Murky's getting dizzy."
        };
        break;
    case 1637: // Orgrimmar
        dialogues = {
            "Mrglglgl! Orgrimmar is so dusty, " + playerName + "! Murky misses the water.",
            "Mrrrglgl! All these orcs, " + playerName + "! Murky feels a bit out of place.",
            "Mrglglgl! The Valley of Strength is bustling, " + playerName + "! So lively!",
            "Mrrrglgl! Murky's scales are getting dry, " + playerName + "! Need water!"
        };
        break;
    case 33: // Stranglethorn Vale
        dialogues = {
            "Mrglglgl! The jungle of Stranglethorn is vast and wild, " + playerName + "! Adventure awaits at every turn!",
            "Blrglmrgl! Watch out for tigers and raptors, " + playerName + "! Murky's not on the menu today!",
            "Mrglglgl! The sound of the waterfalls and the chirping of the jungle birds, it's music to Murky's gills!",
            "Mrglglgl! Welcome to Stranglethorn Vietnam, " + playerName + "! Keep your fins low and your spirits high!",
            "Mrglglgl! They say 'Good morning, Stranglethorn!' but Murky says 'Good luck, " + playerName + "! You're gonna need it!'",
            "Mrglglgl! Keep an eye out for ambushes, " + playerName + "! STV is full of surprises... and not all of them have loot!"
        };
        break;
    case 1638: // Thunder Bluff
        dialogues = {
            "Mrglglgl! Murky feels so high up in Thunder Bluff, " + playerName + "!",
            "Blrglmrgl! The wind up here is strong! Murky's fins are fluttering!",
            "Mrglglgl! So peaceful here, " + playerName + "! Murky can hear the drums!",
            "Mrrrglgl! Look at all the totems, " + playerName + "! Murky wonders if he could climb one!"
        };
        break;
    case 1497: // Undercity
        dialogues = {
            "Mrglglgl! It's so dark and spooky in Undercity, " + playerName + "!",
            "Blrglmrgl! Murky's gills feel tingly... is this place haunted?",
            "Mrglglgl! Murky's not sure if he likes the smell here, " + playerName + "!",
            "Mrrrglgl! So many twists and turns, " + playerName + "! Murky could get lost!"
        };
        break;
    case 1657: // Darnassus
        dialogues = {
            "Mrglglgl! Darnassus is so beautiful and full of trees, " + playerName + "!",
            "Blrglmrgl! Murky feels like he's in a forest dreamland!",
            "Mrglglgl! The moonwell water looks so refreshing, " + playerName + "!",
            "Mrrrglgl! Murky wonders if the Night Elves like murlocs!"
        };
        break;
    case 1537: // Ironforge
        dialogues = {
            "Mrglglgl! It's so warm and cozy in Ironforge, " + playerName + "!",
            "Blrglmrgl! Listen to the sound of hammers and anvils, " + playerName + "!",
            "Mrglglgl! Murky wonders if there's a place to swim around here...",
            "Mrrrglgl! All these dwarves, " + playerName + "! Murky feels a bit short!"
        };
        break;
    case 3557: // Exodar
        dialogues = {
            "Mrglglgl! So many crystals in Exodar, " + playerName + "! Murky's eyes are dazzled!",
            "Blrglmrgl! The draenei are so tall, " + playerName + "! Murky feels like a tadpole!",
            "Mrglglgl! This place feels so alien, yet so peaceful, " + playerName + "!",
            "Mrrrglgl! Murky wonders if he can find a space-fish here, " + playerName + "!"
        };
        break;
    case 3487: // Silvermoon City
        dialogues = {
            "Mrglglgl! Silvermoon is so grand and shiny, " + playerName + "! Murky loves the colors!",
            "Blrglmrgl! These blood elves have such style, " + playerName + "! Murky wants a fancy cloak too!",
            "Mrglglgl! The magic here is so powerful, " + playerName + "! Murky can feel it tingling his fins!",
            "Mrrrglgl! So many tall spires, " + playerName + "! Murky wonders how they keep them so shiny!"
        };
        break;

    case 47: // Hinterlands
        dialogues = {
            "Mrglglgl! The Hinterlands are so lush, " + playerName + "! Murky loves the waterfalls!",
            "Blrglmrgl! So many wild animals, " + playerName + "! Murky's on the lookout!",
            "Mrglglgl! The tall trees make Murky feel like a tiny fish in a big pond, " + playerName + "!",
            "Mrrrglgl! Murky heard about the trolls here, " + playerName + "! They're not as friendly as Murky!"
        };
        break;
    case 46: // Burning Steppes
        dialogues = {
            "Mrglglgl! It's so hot in the Burning Steppes, " + playerName + "! Murky needs water!",
            "Blrglmrgl! Murky sees fire everywhere, " + playerName + "! Be careful!",
            "Mrglglgl! The dragons here are scary, " + playerName + "! Murky's hiding!",
            "Mrrrglgl! This place reminds Murky of a big, fiery ocean... without the water!"
        };
        break;
    case 3: // Badlands
        dialogues = {
            "Mrglglgl! The Badlands are so dry, " + playerName + "! Murky misses the sea!",
            "Blrglmrgl! Murky sees lots of dust and rocks, " + playerName + "! Not much water!",
            "Mrglglgl! Watch out for the earth elementals, " + playerName + "! They're tough!",
            "Mrrrglgl! Murky found some fossils! But... Murky prefers fish bones!"
        };
        break;
    case 14: // Durotar
        dialogues = {
            "Mrglglgl! Durotar is so rugged, " + playerName + "! Murky feels adventurous!",
            "Blrglmrgl! Murky sees lots of orcs here, " + playerName + "! They seem strong!",
            "Mrglglgl! The river is nice, but Murky misses the ocean's vastness, " + playerName + "!",
            "Mrrrglgl! It's a bit dry for Murky's taste, " + playerName + "! Murky needs to stay hydrated!"
        };
        break;
    case 16: // Azshara
        dialogues = {
            "Mrglglgl! Azshara's views are breathtaking, " + playerName + "!",
            "Blrglmrgl! So many mysteries hidden in these ancient ruins, " + playerName + "!",
            "Mrglglgl! Murky could get used to the magical vibes here, " + playerName + "!",
            "Mrrrglgl! Watch your fins, " + playerName + "! Naga around every corner!"
        };
        break;
    case 17: // The Barrens
        dialogues = {
            "Mrglglgl! It's so hot and vast in the Barrens, " + playerName + "!",
            "Blrglmrgl! Murky can hear the echoes of the great Kodo beasts, " + playerName + "!",
            "Mrglglgl! Keep an eye out for those centaurs, " + playerName + "!",
            "Mrrrglgl! Murky wonders if he'll see any of those famous Barrens chat, " + playerName + "!"
        };
        break;
    case 12: // Elwynn Forest
        dialogues = {
            "Mrglglgl! Elwynn Forest is so lush and green, " + playerName + "!",
            "Blrglmrgl! Murky loves the sound of the babbling brooks here, " + playerName + "!",
            "Mrglglgl! So peaceful... until a murloc shows up, right, " + playerName + "?",
            "Mrrrglgl! Murky could spend hours just frolicking in the meadows, " + playerName + "!"
        };
        break;
    case 8: // Swamp of Sorrows
        dialogues = {
            "Mrglglgl! This place feels like home, but gloomier, " + playerName + "!",
            "Blrglmrgl! Watch out for the crocolisks, " + playerName + "! Murky doesn't want to be lunch!",
            "Mrglglgl! The mist gives Murky the chills, " + playerName + "!",
            "Mrrrglgl! So many lost spirits... Murky wonders what their stories are, " + playerName + "!"
        };
        break;
    case 15: // Dustwallow Marsh
        dialogues = {
            "Mrglglgl! Murky loves the swampy waters of Dustwallow, " + playerName + "!",
            "Blrglmrgl! So many crocolisks around, " + playerName + "! Murky's on guard!",
            "Mrglglgl! The marsh is bubbling, just like Murky's home waters!",
            "Mrrrglgl! Theramore's so close, " + playerName + "! Murky wonders if Jaina likes murlocs."
        };
        break;
    case 11: // Wetlands
        dialogues = {
            "Mrglglgl! Wetlands are so... wet! Murky feels right at home, " + playerName + "!",
            "Blrglmrgl! Watch out for those giant crocolisks, " + playerName + "!",
            "Mrglglgl! Murky can see Menethil Harbor from here! So many boats!",
            "Mrrrglgl! So much mud, " + playerName + "! Murky's getting his fins dirty!"
        };
        break;
    case 139: // Eastern Plaguelands
        dialogues = {
            "Mrglglgl! So much blight, it's tough on Murky's gills here in " + playerName + "'s Eastern Plaguelands!",
            "Blrglmrgl! Murky can feel the sorrow of the land, " + playerName + ", but together we bring hope!",
            "Mrglglgl! Look at all these ruins, " + playerName + "! Murky wonders about the stories they hold.",
            "Mrrrglgl! So many scourge, " + playerName + "! Murky's ready to help you cleanse the land!"
        };
        break;
    case 28: // Western Plaguelands
        dialogues = {
            "Mrglglgl! The fields of Western Plaguelands are slowly healing, " + playerName + "!",
            "Blrglmrgl! Murky loves the resilience of nature here, right, " + playerName + "?",
            "Mrglglgl! So many brave souls fighting for the land, " + playerName + "! Murky's inspired!",
            "Mrrrglgl! Caer Darrow, Scholomance... spooky places, " + playerName + "! Murky stays close to you!"
        };
        break;
    case 141: // Teldrassil
        dialogues = {
            "Mrglglgl! Teldrassil is so tall, " + playerName + "! Murky feels tiny!",
            "Blrglmrgl! So many wisps and ancient spirits, " + playerName + "! Murky's in awe!",
            "Mrglglgl! The air is so fresh here in Teldrassil, " + playerName + "! Murky can breathe easy!",
            "Mrrrglgl! Murky loves the tranquility here, " + playerName + "! It's like a big, leafy hug!"
        };
        break;
    case 1377: // Silithus
        dialogues = {
            "Mrglglgl! Silithus feels so ancient and mysterious, " + playerName + "!",
            "Blrglmrgl! The sand, the wind... it's like a giant sandbox, " + playerName + "! But with more danger.",
            "Mrglglgl! Look at the big bug hives, " + playerName + "! Murky's not sure he wants to get closer...",
            "Mrrrglgl! The whispers of the Old Gods... can you hear them, " + playerName + "? Murky's a bit scared!"
        };
        break;
    case 440: // Tanaris
        dialogues = {
            "Mrglglgl! It's so hot and sandy in Tanaris, " + playerName + "!",
            "Blrglmrgl! Murky needs a shade! Even the cactus looks thirsty!",
            "Mrglglgl! The sand keeps getting in Murky's gills, " + playerName + "!",
            "Mrrrglgl! Watch out for sandstorms, " + playerName + "!"
        };
        break;
    case 490: // Un'goro Crater
        dialogues = {
            "Mrglglgl! Un'goro Crater is like a big, wild garden, " + playerName + "!",
            "Blrglmrgl! Murky feels like he's on an adventure in the prehistoric times!",
            "Mrglglgl! So many strange and wondrous creatures here, " + playerName + "!",
            "Mrrrglgl! Look at the size of those dinosaurs, " + playerName + "!"
        };
        break;
    case 357: // Feralas
        dialogues = {
            "Mrglglgl! The trees in Feralas are so tall, " + playerName + ", Murky feels tiny!",
            "Blrglmrgl! The mystery of the ancient ruins is calling, " + playerName + "!",
            "Mrglglgl! Murky wonders what secrets the elves have hidden here, " + playerName + "!",
            "Mrrrglgl! The dense forests are both beautiful and scary, " + playerName + "!"
        };
        break;
    case 400: // Thousand Needles 
        dialogues = {
            "Mrglglgl! So many towering mesas and deep canyons here, " + playerName + "!",
            "Blrglmrgl! The sun is so bright and hot, Murky needs a little shade!",
            "Mrglglgl! Look at those tall needle-like formations, " + playerName + "! Murky wonders if they touch the sky!",
            "Mrrrglgl! It's so dry, Murky misses the water. Not even a puddle to splash in, " + playerName + "!"
        };
        break;
    case 405: // Desolace
        dialogues = {
            "Mrglglgl! Desolace is so... desolate, " + playerName + "!",
            "Blrglmrgl! Murky misses the water, it's so dry here!",
            "Mrglglgl! So many bones, " + playerName + "! This place gives Murky the creeps!",
            "Mrrrglgl! But look, " + playerName + "! Centaurs! Murky wonders if they're friendly?"
        };
        break;
    case 406: // Stonetalon Mountains
        dialogues = {
            "Mrglglgl! These mountains are so tall, " + playerName + "!",
            "Blrglmrgl! Murky can see the whole world from up here!",
            "Mrglglgl! Watch your step, " + playerName + ", it's a long way down!",
            "Mrrrglgl! The winds are strong, " + playerName + "! Murky hopes he doesn't get blown away!"
        };
        break;
    case 361: // Felwood
        dialogues = {
            "Mrglglgl! The trees here are sick, " + playerName + "! Murky feels sad for them.",
            "Blrglmrgl! Murky smells something icky... Is it the ooze?",
            "Mrglglgl! So much corruption, " + playerName + "! Murky wants to help cleanse the land!",
            "Mrrrglgl! Beware of the furbolgs, " + playerName + "! They don't seem very happy..."
        };
        break;
    case 618: // Winterspring
        dialogues = {
            "Mrglglgl! Brrr! Winterspring is so cold, " + playerName + "!",
            "Blrglmrgl! Murky's fins are freezing! Murky needs a little murloc sweater!",
            "Mrglglgl! Look at all the snow, " + playerName + "! Murky wants to make snow-locs!",
            "Mrrrglgl! The frostsabers are so majestic, " + playerName + "! Murky wonders if they give rides..."
        };
        break;
    case 148: // Darkshore
        dialogues = {
            "Mrglglgl! Darkshore's shores are so mysterious, " + playerName + "!",
            "Blrglmrgl! Murky can hear the whispers of the ancients here, " + playerName + "!",
            "Mrglglgl! The ruins here are so ancient, " + playerName + "! Murky wonders what secrets they hold.",
            "Mrrrglgl! The sea here is dark and deep, " + playerName + "! Perfect for a murloc like Murky!"
        };
        break;
    case 331: // Ashenvale
        dialogues = {
            "Mrglglgl! Ashenvale is so lush and green, " + playerName + "!",
            "Blrglmrgl! The forest here is full of life... and danger, " + playerName + "!",
            "Mrglglgl! Murky loves the shade of the tall trees, " + playerName + "!",
            "Mrrrglgl! The sounds of the forest are like music to Murky's gills, " + playerName + "!"
        };
        break;
    case 3524: // Azuremyst Isle
        dialogues = {
            "Mrglglgl! The crystals on Azuremyst Isle shimmer so brightly, " + playerName + "!",
            "Blrglmrgl! Murky feels a strange energy from the Exodar, " + playerName + "!",
            "Mrglglgl! So many draenei around, " + playerName + "! They seem friendly.",
            "Mrrrglgl! The waters around here are so clear, " + playerName + "! Murky could spend all day swimming."
        };
        break;
    case 3525: // Bloodmyst Isle
        dialogues = {
            "Mrglglgl! Bloodmyst Isle feels a bit eerie, " + playerName + "!",
            "Blrglmrgl! The red crystals here are unlike anything Murky's seen before, " + playerName + "!",
            "Mrglglgl! This place feels tainted, " + playerName + "! Murky hopes it can be healed.",
            "Mrrrglgl! Despite the corruption, life finds a way here, " + playerName + "! Murky admires that."
        };
        break;
    case 3430: // Eversong Woods
        dialogues = {
            "Mrglglgl! The sun shines so bright in Eversong Woods, " + playerName + "!",
            "Blrglmrgl! Murky loves the melodies of the singing birds here!",
            "Mrglglgl! So many magical energies around, " + playerName + "! Murky feels tingly!",
            "Mrrrglgl! The trees and flowers are so pretty! Murky could stay forever!"
        };
        break;
    case 3433: // Ghostlands
        dialogues = {
            "Mrglglgl! Ghostlands feel a bit spooky, " + playerName + "...",
            "Blrglmrgl! Murky can sense the spirits lingering... it's eerie!",
            "Mrglglgl! It's so quiet here, " + playerName + ". Murky misses the lively waters!",
            "Mrrrglgl! The ruins are fascinating, but Murky hopes we don't meet any ghosts!"
        };
        break;
    case 45: // Arathi Highlands
        dialogues = {
            "Mrglglgl! Arathi Highlands are so vast and open, " + playerName + "!",
            "Blrglmrgl! Look at all the battles that must have happened here!",
            "Mrglglgl! Murky wonders if there's any hidden treasure around...",
            "Mrrrglgl! The wind is strong! Murky hopes he doesn't get blown away!"
        };
        break;
    case 493: // Moonglade
        dialogues = {
            "Mrglglgl! Moonglade is so peaceful and serene, " + playerName + "!",
            "Blrglmrgl! Murky feels so calm here... it's like a dream!",
            "Mrglglgl! The moonlight here is so bright and beautiful!",
            "Mrrrglgl! Murky wonders if he can meet the druids and learn their secrets!"
        };
        break;
    case 130: // Silverpine Forest
        dialogues = {
            "Mrglglgl! The eerie woods of Silverpine make Murky's scales shiver, " + playerName + "!",
            "Blrglmrgl! Murky can hear the howling from here! Spooky, " + playerName + "!",
            "Mrglglgl! So many worgen around, " + playerName + "! Murky's a bit scared!",
            "Mrrrglgl! The mist hanging over the water is like a ghostly blanket, " + playerName + "!"
        };
        break;
    case 4714: // Gilneas
        dialogues = {
            "Mrglglgl! Gilneas looks so grand, even with all the cobwebs, " + playerName + "!",
            "Blrglmrgl! These streets are so empty... Murky wonders where everyone went, " + playerName + "!",
            "Mrglglgl! The architecture here is fascinating! Murky feels like he's in a storybook, " + playerName + "!",
            "Mrrrglgl! The rain here never seems to stop, but it makes the cobblestones shine, " + playerName + "!"
        };
        break;
    case 85: // Tirisfal Glades
        dialogues = {
            "Mrglglgl! Tirisfal feels so gloomy... Murky needs a light, " + playerName + "!",
            "Blrglmrgl! The bats and spiders make Murky want to hide in his shell, " + playerName + "!",
            "Mrglglgl! Murky hears whispers in the wind here... Or is it just him, " + playerName + "?",
            "Mrrrglgl! The eerie glow from the mushrooms is Murky's only comfort here, " + playerName + "!"
        };
        break;
    case 267: // South Shore
        dialogues = {
            "Mrglglgl! The waters here are so clear, " + playerName + "! Murky could go for a swim!",
            "Blrglmrgl! South Shore seems peaceful... but Murky keeps an eye out for trouble, " + playerName + "!",
            "Mrglglgl! Murky loves the smell of the sea air here, " + playerName + "! It's like home!",
            "Mrrrglgl! The sound of the waves is like a lullaby for Murky, " + playerName + "!"
        };
        break;
    case 1: // Dun Morogh
        dialogues = {
            "Mrglglgl! Brrr... Dun Morogh is too cold for Murky's liking, " + playerName + "!",
            "Blrglmrgl! All this snow makes Murky want to build a snowmurloc, " + playerName + "!",
            "Mrglglgl! The mountain air is so fresh! But Murky misses the water, " + playerName + "!",
            "Mrrrglgl! Murky wonders if he could learn to ski... or maybe just slide on his belly, " + playerName + "!"
        };
        break;
    case 38: // Loch Modan
        dialogues = {
            "Mrglglgl! The Thelsamar ale is strong, but Murky can handle it, " + playerName + "!",
            "Blrglmrgl! Such serene waters in the loch, " + playerName + "! Murky could swim for days.",
            "Mrglglgl! These mountains are majestic, " + playerName + "! Murky feels so small.",
            "Mrrrglgl! Watch out for troggs, " + playerName + "! They're not as friendly as Murky."
        };
        break;
    case 40: // Westfall
        dialogues = {
            "Mrglglgl! The fields of Westfall are vast, " + playerName + "! So much open space!",
            "Blrglmrgl! Murky heard about the Defias Brotherhood, " + playerName + "! Should we be careful?",
            "Mrglglgl! The lighthouse is a beacon of hope, " + playerName + ", even for a murloc!",
            "Mrrrglgl! Murky misses the ocean, but the shore here is nice too, " + playerName + "!"
        };
        break;
    case 10: // Duskwood
        dialogues = {
            "Mrglglgl! It's spooky here in Duskwood, " + playerName + "! Murky could use a nightlight.",
            "Blrglmrgl! Did you hear that, " + playerName + "? Murky hopes it's not the worgen!",
            "Mrglglgl! The Stitches are terrifying, " + playerName + "! Let's stay away.",
            "Mrrrglgl! Murky thinks we should stick together, " + playerName + ". It's scary here!"
        };
        break;
    case 4: // Blasted Lands
        dialogues = {
            "Mrglglgl! The ground is so scorched in Blasted Lands, " + playerName + ", Murky needs water!",
            "Blrglmrgl! The Dark Portal is intimidating, " + playerName + "! Murky's not sure about this.",
            "Mrglglgl! Everything is so red and angry-looking here, " + playerName + "!",
            "Mrrrglgl! Murky wonders what happened to make this place so... blasted, " + playerName + "!"
        };
        break;
    case 41: // Deadwind Pass
        dialogues = {
            "Mrglglgl! Deadwind Pass gives Murky the creeps, " + playerName + "! Let's not linger.",
            "Blrglmrgl! The winds whisper sad tales, " + playerName + ". Can you hear them?",
            "Mrglglgl! Karazhan looms ominously, " + playerName + ". Murky's fins are trembling!",
            "Mrrrglgl! Murky feels like we're being watched, " + playerName + ". Let's move quickly!"
        };
        break;
    case 51: // Searing Gorge
        dialogues = {
            "Mrglglgl! It's so hot in Searing Gorge, " + playerName + "! Murky needs water!",
            "Blrglmrgl! All this lava makes Murky nervous...",
            "Mrglglgl! Murky can see why they call it 'Searing'! It's like an oven here, " + playerName + "!",
            "Mrrrglgl! So many fiery creatures, " + playerName + "! Murky's fins are sweating!"
        };
        break;
    case 44: // Redridge Mountains
        dialogues = {
            "Mrglglgl! Redridge is so peaceful, " + playerName + "! Murky could take a nap...",
            "Blrglmrgl! Look at the lake, " + playerName + "! Murky wonders if there are fish to catch.",
            "Mrglglgl! All these hills are making Murky's fins tired, " + playerName + "!",
            "Mrrrglgl! Murky likes the view from up here, " + playerName + "! Everything looks so small!"
        };
        break;
    case 36: // Alterac Mountains
        dialogues = {
            "Mrglglgl! Brrr, it's chilly in Alterac Mountains, " + playerName + "! Murky needs a scarf...",
            "Blrglmrgl! Murky can see his breath here, " + playerName + "! It's so cold!",
            "Mrglglgl! All the snow makes Murky want to build a snow-murloc, " + playerName + "!",
            "Mrrrglgl! Murky wonders if there's any hot springs around here, " + playerName + "! He could use a warm-up!"
        };
        break;
    default:
        // No zone-specific dialogue found, check map ID for custom dialogues
        switch (me->GetMapId())
        {
        case 36: // Deadmines
            dialogues = {
                "Arrrgh! Murky doesn't like these dark caves, " + playerName + "!",
                "Mrrglglgl! So many rats here, " + playerName + "! Murky could use a tiny pirate hat!",
                "Shiver me timbers, " + playerName + "! Murky's ready to plunder the Deadmines!",
                "Mrglglgl! These mines are scary, but Murky's braver with you around, " + playerName + "!",
                "Mrrrglgl! Murky's ready to swab the decks and find some treasure, " + playerName + "!"
            };
            break;
        case 189: // Scarlet Monastery
            dialogues = {
                "Mrglglgl! So many ghosts and ghouls, " + playerName + "! Murky's spooked!",
                "Mrrrglgl! These halls echo with the past, " + playerName + ". Murky's on edge!",
                "Mrglglgl! Murky's ready to face the Scarlet Crusade with you, " + playerName + "!",
                "Mrrrglgl! These crimson halls are chilling, " + playerName + "...",
                "Mrglglglgl! Together we'll uncover the monastery's secrets, " + playerName + "!"
            };
            break;
        case 30: // Alterac Valley
            dialogues = {
                "Mrglglgl! So cold and snowy here, " + playerName + "! Murky wants a warm cave!",
                "Mrrrglgl! Murky can see his breath, " + playerName + "! It's freezing!",
                "Mrglglgl! A vast battlefield, " + playerName + "! Murky's ready to charge!",
                "Mrrrglgl! Let's win this battle for the Horde, " + playerName + "!",
                "Mrglglglgl! Murky's ready to face our enemies in the snow, " + playerName + "!"
            };
            break;
        case 249: // Onyxia's Lair
            dialogues = {
                "Mrglglgl! Murky feels the heat, " + playerName + "! Is it just me, or is it getting hotter?",
                "Mrrrglgl! Murky's not ready to be dragon snacks, " + playerName + "!",
                "Mrglglgl! Big dragon, big adventure, right, " + playerName + "?",
                "Mrrrglgl! Watch out for the fire, " + playerName + "! Murky's not flame-resistant!",
                "Mrglglgl! Murky's ready to face the dragon queen with you, " + playerName + "!"
            };
            break;
        case 309: // Zul'Gurub
            dialogues = {
                "Mrglglgl! Murky doesn't do well with voodoo, " + playerName + "!",
                "Mrrrglgl! So many trolls, so little time, " + playerName + "!",
                "Mrglglgl! Murky wonders if trolls taste like chicken, " + playerName + "?",
                "Mrrrglgl! Beware the curses, " + playerName + "! Murky doesn't want to be a frog!",
                "Mrglglgl! Murky's ready to take on the Blood God with you, " + playerName + "!"
            };
            break;
        case 409: // Molten Core
            dialogues = {
                "Mrglglgl! It's like a big, fiery bath in here, " + playerName + "!",
                "Mrrrglgl! Murky hopes these flames are fireproof, " + playerName + "!",
                "Mrglglgl! Murky's ready to dive into the lava... Just kidding, " + playerName + "!",
                "Mrrrglgl! Murky says, keep your fins cool, " + playerName + "!",
                "Mrglglgl! Let's turn up the heat on Ragnaros, " + playerName + "!"
            };
            break;
        case 531: // Ahn'Qiraj Temple
            dialogues = {
                "Mrglglgl! So many bugs, " + playerName + "! Murky's getting itchy!",
                "Mrrrglgl! Murky's not a fan of Old Gods, " + playerName + "!",
                "Mrglglgl! Murky wonders if bugs have kings, " + playerName + "?",
                "Mrrrglgl! These ancient halls are spooky, " + playerName + "!",
                "Mrglglgl! Murky's ready to squash some bugs with you, " + playerName + "!"
            };
            break;
        case 533: // Naxxramas
            dialogues = {
                "Mrglglgl! This place gives Murky the chills, " + playerName + "!",
                "Mrrrglgl! Murky's not ready to be a skeleton, " + playerName + "!",
                "Mrglglgl! Murky doesn't want to be undead, " + playerName + "!",
                "Mrrrglgl! So spooky, " + playerName + "! Murky might just hide in his egg!",
                "Mrglglgl! Together we can defeat the Lich King's minions, " + playerName + "!"
            };
            break;
        case 469: // Blackwing Lair
            dialogues = {
                "Mrglglgl! More dragons, " + playerName + "? Murky's going to need a bigger shield!",
                "Mrrrglgl! Murky's not sure about this, " + playerName + "...",
                "Mrglglgl! Murky wonders if dragons are ticklish, " + playerName + "?",
                "Mrrrglgl! So many scales and claws, " + playerName + "!",
                "Mrglglgl! Murky's ready to dodge some dragonfire, " + playerName + "!"
            };
            break;
        case 509: // Ahn'Qiraj Ruins
            dialogues = {
                "Mrglglgl! Even more bugs, " + playerName + "! Murky's going to need bug spray!",
                "Mrrrglgl! Murky doesn't like this place, " + playerName + "!",
                "Mrglglgl! Can bugs be friendly, " + playerName + "? Murky hopes so!",
                "Mrrrglgl! So sandy and buggy, " + playerName + "! Murky misses the water!",
                "Mrglglgl! Let's make these ruins a bit less... ruin-y, " + playerName + "!"
            };
            break;
        case 48: // Blackfathom Deeps
            dialogues = {
                "Mrglglgl! So dark and mysterious down here in Blackfathom Deeps, " + playerName + "!",
                "Blrglmrgl! Murky can feel the ancient magic swirling around!",
                "Mrglglgl! Watch out for the naga, " + playerName + "! They're slippery!",
                "Mrrrglgl! These underwater caverns are full of secrets, " + playerName + "!"
            };
            break;
        case 70: // Uldaman
            dialogues = {
                "Mrglglgl! Uldaman is full of ancient wonders, " + playerName + "!",
                "Blrglmrgl! So many relics and golems... Murky's getting dizzy!",
                "Mrglglgl! Murky wonders if there's any hidden treasure around here, " + playerName + "!",
                "Mrrrglgl! These ancient halls tell a story, " + playerName + "! Murky's all ears... or gills!"
            };
            break;
        case 90: // Gnomeregan
            dialogues = {
                "Mrglglgl! Gnomeregan is so twisty and turny, " + playerName + "!",
                "Blrglmrgl! All these gadgets and gizmos, Murky's head is spinning!",
                "Mrglglgl! Watch out for the leper gnomes, " + playerName + "! They're not very friendly!",
                "Mrrrglgl! Murky's never seen so many machines, " + playerName + "!"
            };
            break;
        case 129: // Razorfen Downs
            dialogues = {
                "Mrglglgl! Razorfen Downs is so prickly and dark, " + playerName + "!",
                "Blrglmrgl! Beware the thorns, " + playerName + "! Murky almost got stuck!",
                "Mrglglgl! So many quillboars around here, " + playerName + "! Stay close to Murky!",
                "Mrrrglgl! Murky wonders what secrets the quillboars are hiding, " + playerName + "!"
            };
            break;
        case 209: // Zul'Farrak
            dialogues = {
                "Mrglglgl! Zul'Farrak's sands stretch far and wide, " + playerName + "!",
                "Blrglmrgl! Murky feels like a fish out of water in this desert!",
                "Mrglglgl! The trolls here are fierce, " + playerName + "! Murky's on guard!",
                "Mrrrglgl! Murky's heard tales of a great treasure here, " + playerName + "! Let's find it!"
            };
            break;
        case 389: // Ragefire Chasm
            dialogues = {
                "Mrglglgl! It's so hot in Ragefire Chasm, " + playerName + "! Murky could boil!",
                "Blrglmrgl! All this lava, " + playerName + "! Murky's getting dizzy from the heat!",
                "Mrglglgl! Murky wonders if there's a cool pond around here...",
                "Mrrrglgl! These fiery creatures are scary, " + playerName + "!"
            };
            break;
        case 349: // Maraudon
            dialogues = {
                "Mrglglgl! Maraudon's caves are so mysterious, " + playerName + "!",
                "Blrglmrgl! Such strange plants and creatures here, " + playerName + "!",
                "Mrglglgl! Murky can hear the echo of waterfalls, " + playerName + "!",
                "Mrrrglgl! It feels like an ancient place, " + playerName + "! Murky's fins are tingling!"
            };
            break;
        case 369: // Deeprun Tram
            dialogues = {
                "Mrglglgl! The Deeprun Tram is so fast, " + playerName + "! Murky's getting woozy!",
                "Blrglmrgl! So many people rushing around, " + playerName + "!",
                "Mrglglgl! Murky wonders how it all works...",
                "Mrrrglgl! It's like being in a giant fish that swims through the ground, " + playerName + "!"
            };
            break;
        case 429: // Dire Maul
            dialogues = {
                "Mrglglgl! Dire Maul's ruins are so big, " + playerName + "! Murky feels tiny...",
                "Blrglmrgl! So many books, " + playerName + "! Does anyone read them?",
                "Mrglglgl! The ogres here don't look friendly, " + playerName + "!",
                "Mrrrglgl! Murky's lost, " + playerName + "! Everything looks the same!"
            };
            break;
        case 289: // Scholomance
            dialogues = {
                "Mrglglgl! Scholomance is spooky, " + playerName + "! Murky's scales are shivering!",
                "Blrglmrgl! All these dark magics, " + playerName + "! Murky doesn't like it...",
                "Mrglglgl! Murky hears whispers, " + playerName + "! Is it the wind?",
                "Mrrrglgl! This place is a maze, " + playerName + "! Murky wishes for clear waters..."
            };
            break;
        case 230: // Blackrock Depths
            dialogues = {
                "Mrglglgl! It's hot and smoky in Blackrock Depths, " + playerName + "!",
                "Blrglmrgl! All these forges and anvils, " + playerName + ", it's like a giant workshop!",
                "Mrglglgl! Watch your step, " + playerName + ", Murky doesn't want to fall into lava!",
                "Mrrrglgl! So many Dark Iron dwarves, " + playerName + "! They don't look friendly!"
            };
            break;
        case 229: // Blackrock Spire
            dialogues = {
                "Mrglglgl! Blackrock Spire is so tall, " + playerName + "! Murky can see everything from up here!",
                "Blrglmrgl! All these orcs and dragons, " + playerName + ", it's a bit scary!",
                "Mrglglgl! Murky wonders what's at the top, " + playerName + "! Maybe a big treasure?",
                "Mrrrglgl! This place feels like a maze, " + playerName + "! Murky hopes we don't get lost!"
            };
            break;
        case 33: // Shadowfang Keep
            dialogues = {
                "Mrglglgl! Shadowfang Keep is so gloomy, " + playerName + "! Murky feels a shiver!",
                "Blrglmrgl! All these worgen and ghosts, " + playerName + ", it's like a haunted house!",
                "Mrglglgl! Murky hopes we find some shiny loot, " + playerName + "! But no curses, please!",
                "Mrrrglgl! Be careful, " + playerName + "! Murky heard there are traps around!"
            };
            break;
        case 43: // Wailing Caverns
            dialogues = {
                "Mrglglgl! Wailing Caverns is so twisty and full of beasts, " + playerName + "!",
                "Blrglmrgl! Murky hears strange echoes, " + playerName + "! Is it the wind or something else?",
                "Mrglglgl! Watch out for the druids, " + playerName + "! They're not very friendly here!",
                "Mrrrglgl! So many caves, Murky wonders what's hidden inside!"
            };
            break;
        case 329: // Stratholme
            dialogues = {
                "Mrglglgl! So much history in Stratholme, " + playerName + ", but it feels eerie!",
                "Blrglmrgl! Can you feel the echoes of the past, " + playerName + "? Murky sure can!",
                "Mrglglgl! Murky wonders if there are any fish in the plagued waters... Probably best not to try!",
                "Mrrrglgl! Keep your fins close, " + playerName + "! This place is full of dangers!"
            };
            break;
        case 169: // Emerald Dream
            dialogues = {
                "Mrglglgl! Everything's so vibrant and alive in the Emerald Dream, " + playerName + "!",
                "Blrglmrgl! Murky feels like he's swimming in a sea of green!",
                "Mrglglgl! It's a dream come true, " + playerName + "! Or is it just a dream?",
                "Mrrrglgl! Look at all these colors, " + playerName + "! Murky's never seen anything like it!"
            };
            break;
        case 47: // Razorfen Kraul
            dialogues = {
                "Mrglglgl! So many thorns in Razorfen Kraul, " + playerName + "! Murky needs to watch his fins!",
                "Blrglmrgl! It's like a maze here, " + playerName + "! Murky could get lost!",
                "Mrglglgl! Watch out for the quilboars, " + playerName + "! They don't seem very friendly.",
                "Mrrrglgl! Murky wonders if there's any hidden treasure around here..."
            };
            break;
        case 34: // Stormwind Stockade
            dialogues = {
                "Mrglglgl! It's so cramped and gloomy in the Stockade, " + playerName + "!",
                "Blrglmrgl! Murky doesn't like it here... It smells funny.",
                "Mrglglgl! Listen to the echoes, " + playerName + "! Every sound bounces off the walls.",
                "Mrrrglgl! Murky's ready to help you take on the prisoners, " + playerName + "! Let's bring justice!"
            };
            break;
        default: // General dialogues if neither zone nor map stuff is found
            dialogues = {
                "Mrglglglgl! Murky here, reporting for duty!",
                "Mrrrrrrrglglglgl! Murky happy to serve you, " + playerName + "!",
                "Mrglgl! Murloc Murky at your service! Let's conquer Azeroth together!",
                "Mrrrglglgl! Murky ready to take on any challenge with you, " + playerName + "!",
                "Mrglglglglgl! Reporting for duty! Let's make some waves, " + playerName + "!",
                "Mrrglglgl! Murky is excited to join your team, " + playerName + "! Let's show everyone what we're made of!",
                "Mrglglgl! Murloc warrior Murky at your command, " + playerName + "! Let's make our enemies quake with fear!",
                "Mrrrglglgl! Murky is eager to prove his worth to you, " + playerName + "! Let's take on the world together!",
                "Mrglglglgl! This Murloc is ready to make some noise with you, " + playerName + "! Let's show them who's boss!",
                "Mrrrglgl! Murky honored to be your loyal companion, " + playerName + "! Let's take on any challenge that comes our way!",
                "Greetings, adventurer! The one and only Murky has arrived to join you on your quest!",
                "Mrglgl! Murky is here to lend a fin and help you conquer the land, " + playerName + "!",
                "Mrrglgl! Murky is thrilled to serve such a worthy leader as yourself, " + playerName + "!",
                "Mrglglglgl! Murky reporting for duty! Let's make some mischief and have some fun, " + playerName + "!",
                "Mrrglgl! Murky is honored to be fighting by your side, " + playerName + "! Let's take on our foes with all we've got!",
                "Mrglglgl! Murky is eager to explore the land and see what adventures await us, " + playerName + "!",
                "Mrrrglglgl! Murky is always up for a challenge, " + playerName + "! Let's go forth and conquer!",
                "Mrglglglgl! Murky is ready to make some waves and take on the world, " + playerName + "! Let's do this!",
                "Mrrrglgl! Murky will be your trusty sidekick on this journey, " + playerName + "! Let's make some memories!",
                "Mrglglglgl! Murky is thrilled to be part of your team, " + playerName + "! Let's show them what we're made of and come out on top!"
            };
        }
    }
    int dialogueIndex = urand(0, dialogues.size() - 1);
    me->Say(dialogues[dialogueIndex], LANG_UNIVERSAL);
}

CreatureAI* npc_murky::GetAI(Creature* creature) const {
    return new npc_murkyAI(creature);
}

class player_quest_complete_murky : public PlayerScript
{
public:
    player_quest_complete_murky() : PlayerScript("player_quest_complete_murky") {}

    void OnPlayerCompleteQuest(Player* player, Quest const* quest) override
    {
        const uint32 MURKY_NPC_ID = 15186;

        std::list<Creature*> creatureList;
        player->GetCreatureListWithEntryInGrid(creatureList, MURKY_NPC_ID, 8.0f);

        if (creatureList.empty()) return;

        for (Creature* creature : creatureList)
        {
            if (creature->GetEntry() == MURKY_NPC_ID)
            {
                std::vector<std::string> messages = {
                    "Mrglglglg! Well done, " + player->GetName() + ", for such an outstanding achievement, mrgl!",
                    "Glrglmrgl! Great, " + player->GetName() + ", your efforts shine brighter than the glistening waters, mrglgl!",
                    "Mrrglglgy! Keep it up, " + player->GetName() + ", your journey is sprinkled with impressive feats, mrgl!",
                    "Mglrmglmglmgl! Another quest down, " + player->GetName() + ", your adventures are truly inspiring, mrgl!",
                    "Mrglmrglm! " + player->GetName() + ", you're a true mrgladventurer, leading the way with valor, mrgl!",
                    "Grglgrgl mrglgrgl! Splendid job, " + player->GetName() + ", your deeds ripple through the waters, mrgl!",
                    "Blrglmrgl! Fantastic, " + player->GetName() + ", your accomplishments are as vast as the sea, mrglglgl!",
                    "Mrglglbrgl mrglmrgl! You did it, " + player->GetName() + ", a true testament to your strength, mrgl!",
                    "Mrgl! Mrgl! On to the next, " + player->GetName() + ", your saga continues to unfold, mrgl!",
                    "Glrglmrgl! Exceptional, " + player->GetName() + ", your feats are as legendary as the tides, mrgl!",
                    "Mrglmrglgl! You're making waves, " + player->GetName() + ", steering through challenges with ease, mrgl!",
                    "Rglmrglmrgl! Astounding, " + player->GetName() + ", your journey is marked with remarkable milestones, mrgl!",
                    "Brlgrlgrlgl! What a triumph, " + player->GetName() + ", your victories are sung by the murlocs far and wide, mrgl!"
                };

                int randomIndex = urand(0, messages.size() - 1);
                std::string message = messages[randomIndex];

                creature->Say(message.c_str(), LANG_UNIVERSAL, player);

                break;
            }
        }
    }
};

class murky_commandscript : public CommandScript
{
public:
    murky_commandscript() : CommandScript("murky_commandscript") { }

    std::vector<ChatCommand> GetCommands() const override
    {
        static std::vector<ChatCommand> murkyCommandTable =
        {
            { "adddialogue", SEC_ADMINISTRATOR, false, &HandleAddMurkyDialogue, "Adds a new dialogue for Murky's Line of Sight." }
        };

        return murkyCommandTable;
    }

    static bool HandleAddMurkyDialogue(ChatHandler* handler, const char* args)
    {
        if (!*args)
            return false;

        auto params = strtok((char*)args, ";");
        if (!params)
            return false;

        uint32 creatureId = atoi(params);
        params = strtok(nullptr, ";");
        if (!params)
            return false;

        std::string dialogue = params;
        params = strtok(nullptr, ";");
        if (!params)
            return false;

        float range = atof(params);

        if (creatureId == 0 || dialogue.empty() || range <= 0)
        {
            handler->PSendSysMessage("Invalid parameters for creatureId, dialogue, or range.");
            return false;
        }

        char query[1024];
        snprintf(query, sizeof(query), "INSERT INTO murky_los_dialogues (creatureId, dialogue, `range`) VALUES (%u, '%s', %f)", creatureId, dialogue.c_str(), range);

        try {
            WorldDatabase.Execute(query);
            handler->PSendSysMessage("Successfully added new dialogue for Murky: %s", dialogue.c_str());
        }
        catch (std::exception& e) {
            handler->PSendSysMessage("Failed to add new dialogue for Murky. Error: %s", e.what());
            return false;
        }

        return true;
    }
};

void AddSC_npc_murky() {
    new player_quest_complete_murky();
    new npc_murky();
    new murky_commandscript();
}

