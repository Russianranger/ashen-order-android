#include "CreatureScript.h"
#include "InstanceScript.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "ScriptedCreature.h"
#include <vector>
#include "bot_ai.h"
#include "../scripts/Custom/Timewalking/10Man.h"


enum SpellIds
{
    SPELL_ID_EXPLOSION = 1232132,
    SPELL_ID_FIXATE = 40414,
    SPELL_ID_SELF_STUN = 828159,
    SPELL_TRAMPLE = 5568,
    SPELL_KNOCKOUT = 17307,
    SPELL_SUNDER_ARMOR = 858461,
    SPELL_THROW_SLIME = 870852
};

enum Events {
    EVENT_TRAMPLE = 1,
    EVENT_KNOCKOUT,
    EVENT_SUNDER_ARMOR,
    EVENT_SUMMON_OOZE,
    EVENT_DELAYED_OOZE_SPAWN,
    EVENT_CAST_HELLFIRE
};

enum NpcIds
{
    NPC_BOSS_RAMSTEIN = 10439,
    NPC_GREEN_OOZE = 882656
};

enum GameObjectIds {
    GO_DOOR_RAMSTEIN = 175405
};

const std::vector<Position> oozeSpawnLocations = {
    {4009.406f, -3434.739f, 120.902f, 0.014f},
    {3994.785f, -3424.016f, 120.771f, 2.424f},
    {3999.265f, -3403.875f, 117.540f, 1.364f},
    {4011.897f, -3401.656f, 116.141f, 0.052f},
    {4024.320f, -3424.342f, 117.455f, 5.424f},
    {4040.240f, -3442.792f, 119.612f, 0.572f},
    {4052.620f, -3432.725f, 118.523f, 0.922f},
    {4054.634f, -3412.916f, 116.071f, 1.433f},
    {4072.640f, -3400.756f, 115.653f, 0.450f},
    {4096.757f, -3399.520f, 115.964f, 0.206f},
    {4083.614f, -3379.747f, 116.298f, 2.526f},
    {4090.069f, -3432.704f, 117.030f, 4.679f},
    {4068.065f, -3425.920f, 117.304f, 3.024f},
    {4040.445f, -3422.596f, 116.632f, 3.094f},
    {4024.540f, -3443.842f, 119.741f, 4.090f},
    {4035.673f, -3458.287f, 120.968f, 5.365f},
    {4003.018f, -3416.840f, 118.127f, 2.135f},
    {3983.204f, -3409.106f, 119.193f, 2.654f},
    {3982.658f, -3393.842f, 118.789f, 1.505f},
    {3985.258f, -3370.327f, 119.210f, 1.295f},
    {4035.622f, -3410.780f, 115.740f, 5.801f},
    {4098.078f, -3415.274f, 116.291f, 0.179f},
    {4096.839f, -3383.359f, 116.558f, 1.671f},
    {4085.470f, -3357.442f, 117.637f, 2.029f},
    {4074.706f, -3353.362f, 117.597f, 2.029f},
    {4097.739f, -3433.108f, 117.041f, 4.322f},
    {4069.686f, -3445.438f, 120.181f, 3.587f},
    {4042.728f, -3462.640f, 121.498f, 3.670f},
    {4023.867f, -3461.795f, 121.697f, 2.950f},
    {4004.943f, -3447.689f, 122.376f, 2.170f},
    {3987.021f, -3430.030f, 121.496f, 2.509f},
    {3973.919f, -3414.656f, 120.767f, 2.144f},
    {3967.454f, -3393.874f, 119.199f, 2.333f},
    {3986.252f, -3360.022f, 119.270f, 1.307f},
    {3990.625f, -3348.760f, 118.855f, 1.307f}
};

class boss_ramstein_the_gorger : public CreatureScript {
public:
    boss_ramstein_the_gorger() : CreatureScript("boss_ramstein_the_gorger") {}

    struct boss_ramstein_the_gorgerAI : public ScriptedAI {
        boss_ramstein_the_gorgerAI(Creature* creature) : ScriptedAI(creature) {
            Initialize();
        }

        Position delayedOozePosition;

        void Initialize() {
            if (firstSpawn) {
                OpenDoor();
                firstSpawn = false;
            }
            yellDone = false;
            doorCloseDone = false;
            pulledAt70 = false;
            pulledAt30 = false;
        }

        void Reset() override {
            ScriptedAI::Reset();
            events.Reset(); // Clear all pending events
            DespawnOozes();
            me->GetMotionMaster()->MovePoint(0, 4032.63f, -3399.67f, 115.58f);
            me->SetHomePosition(4032.63f, -3399.67f, 115.58f, 4.67f);

            // Reset timers for out-of-combat actions
            yellTimer = 2000;
            doorCloseTimer = 4000;
            yellDone = false;
            doorCloseDone = false;
            pulledAt70 = false;
            pulledAt30 = false;

        }

        void JustEngagedWith(Unit* /*who*/) override {
            events.ScheduleEvent(EVENT_TRAMPLE, 3000);
            events.ScheduleEvent(EVENT_KNOCKOUT, 12000);
            events.ScheduleEvent(EVENT_SUNDER_ARMOR, 7000);
            events.ScheduleEvent(EVENT_SUMMON_OOZE, 13000);
        }

        void JustDied(Unit* /*killer*/) override {
            me->Yell("Only...wanted...food...", LANG_UNIVERSAL);
            me->PlayDirectSound(188055);
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            if (!players.IsEmpty())
            {
                uint32 baseRewardLevel = 1;
                bool isDungeon = me->GetMap()->IsDungeon();

                for (auto const& playerPair : players)
                {
                    if (Player* player = playerPair.GetSource())
                    {
                        DistributeChallengeRewards(player, me, baseRewardLevel, isDungeon);
                    }
                }
            }
            DespawnOozes();
        }

        void DamageTaken(Unit* attacker, uint32& damage, DamageEffectType dmgType, SpellSchoolMask dmgMask) override {
            if (me->GetHealthPct() <= 70.0 && !pulledAt70) {
                pulledAt70 = true;  // Ensure that the pull event only triggers once at 70%
                PullAllToCenter();
                events.ScheduleEvent(EVENT_CAST_HELLFIRE, 1000);
            }
            else if (me->GetHealthPct() <= 30.0 && !pulledAt30) {
                pulledAt30 = true;  // Ensure that the pull event only triggers once at 30%
                PullAllToCenter();
                events.ScheduleEvent(EVENT_CAST_HELLFIRE, 1000);
            }
        }

        void PullAllToCenter() {
            me->Yell("Ramstein catch fast food! Get in belly!", LANG_UNIVERSAL);
            me->PlayDirectSound(188054);
            std::list<Unit*> targets;
            float range = 150.0f;  

            // Set up the check to find all units within range, including friendly and unfriendly
            Acore::AnyUnitInObjectRangeCheck check(me, range);
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
            Cell::VisitAllObjects(me, searcher, range);

            Creature* patchwerk = me->FindNearestCreature(NPC_BOSS_RAMSTEIN, range);  

            for (Unit* target : targets) {
                if (target == me || !target->IsAlive()) continue;  

                //  handling for oozes
                if (target->GetEntry() == NPC_GREEN_OOZE) {
                    if (patchwerk) {
                        float x, y, z;
                        patchwerk->GetPosition(x, y, z);
                        target->ToCreature()->GetMotionMaster()->MoveJump(x, y, z, 20.0f, 10.0f);
                    }
                    me->CastSpell(target, 811019, true); // kill ooze
                    me->CastSpell(me, 1231414, true);  //  aura on Ramstein for each ooze pulled
                }
                else {
                    // Cast Chains of Ice on all other units
                    me->CastSpell(target, 845524, true);
                }

                // Cast Death Grip on all units 
                me->CastSpell(target, 49576, true);  
            }
        }

        void EnterEvadeMode(EvadeReason why) override {
            ScriptedAI::EnterEvadeMode(why);
            Reset();  // Ensure everything is reset properly when evading
        }

        void UpdateAI(uint32 diff) override {
            if (!UpdateVictim()) {
                // Handle out-of-combat actions
                HandleOutOfCombatActions(diff);
                return;
            }

            events.Update(diff);

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            while (uint32 eventId = events.ExecuteEvent()) {
                switch (eventId) {
                case EVENT_TRAMPLE:
                    if (Unit* target = SelectTarget(SelectTargetMethod::MaxThreat)) {
                        DoCast(target, SPELL_TRAMPLE);
                    }
                    events.ScheduleEvent(EVENT_TRAMPLE, 7000);
                    break;
                case EVENT_KNOCKOUT:
                    if (Unit* target = SelectTarget(SelectTargetMethod::MaxThreat)) {
                        DoCast(target, SPELL_KNOCKOUT);
                    //    me->GetThreatMgr().ResetAllThreat();
                    //    me->GetThreatMgr().AddThreat(target, -100.0f);
                    }
                    events.ScheduleEvent(EVENT_KNOCKOUT, 10000);
                    break;
                case EVENT_SUNDER_ARMOR:
                    if (Unit* target = SelectTarget(SelectTargetMethod::MaxThreat)) {
                        DoCast(target, SPELL_SUNDER_ARMOR);
                    }
                    events.ScheduleEvent(EVENT_SUNDER_ARMOR, 21000);
                    break;
                case EVENT_SUMMON_OOZE:
                    SummonOoze();
                    if (urand(0, 100) < 40) {
                        me->Yell("Oozes make bones soft!", LANG_UNIVERSAL);
                        me->PlayDirectSound(188057); // Play sound for ooze summon
                    }
                    events.ScheduleEvent(EVENT_SUMMON_OOZE, urand(14000, 18000));
                    break;
                case EVENT_DELAYED_OOZE_SPAWN:
                    me->SummonCreature(NPC_GREEN_OOZE, delayedOozePosition, TEMPSUMMON_TIMED_DESPAWN, 300000);
                    break;
                case EVENT_CAST_HELLFIRE:
                    DoCast(811684);  // Hellfire spell
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

        void HandleOutOfCombatActions(uint32 diff) {
            if (!yellDone) {
                if (yellTimer <= diff) {
                    me->Yell("Been long time since fresh meat!", LANG_UNIVERSAL);
                    me->PlayDirectSound(188056);
                    if (Unit* nearest = me->SelectNearestPlayer(150.0f)) {
                        me->AI()->AttackStart(nearest); // Engage the nearest player
                    }
                    yellDone = true; // Prevent further yelling unless reset
                }
                else {
                    yellTimer -= diff;
                }
            }

            if (!doorCloseDone) {
                if (doorCloseTimer <= diff) {
                    if (GameObject* door = me->FindNearestGameObject(GO_DOOR_RAMSTEIN, 150.0f))
                        door->SetGoState(GO_STATE_READY);
                    me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC); // Remove immunities
                    doorCloseDone = true; // Prevent further door operations unless reset
                }
                else {
                    doorCloseTimer -= diff;
                }
            }
        }

        void OpenDoor() {
            if (GameObject* door = me->FindNearestGameObject(GO_DOOR_RAMSTEIN, 150.0f))
                door->SetGoState(GO_STATE_ACTIVE);
        }

        void SummonOoze() {
            std::vector<Position> validPositions;
            for (const auto& pos : oozeSpawnLocations) {
                if (me->GetDistance(pos) >= 30.0f && me->GetDistance(pos) <= 50.0f) {
                    validPositions.push_back(pos);
                }
            }

            if (!validPositions.empty()) {
                const Position& chosenPos = validPositions[urand(0, validPositions.size() - 1)];
                me->SetFacingTo(me->GetAngle(chosenPos.GetPositionX(), chosenPos.GetPositionY()));
                me->CastSpell(chosenPos.GetPositionX(), chosenPos.GetPositionY(), chosenPos.GetPositionZ(), SPELL_THROW_SLIME, true);
                delayedOozePosition = chosenPos; // Store the position for delayed spawning
                events.ScheduleEvent(EVENT_DELAYED_OOZE_SPAWN, 4300); // Schedule delayed spawn event
            }
        }

        void DespawnOozes() {
            std::list<Unit*> targets;
            Acore::AnyUnitInObjectRangeCheck check(me, 100.0f);
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
            Cell::VisitAllObjects(me, searcher, 100.0f);

            for (Unit* target : targets) {
                if (target->GetEntry() == NPC_GREEN_OOZE) {
                    target->ToCreature()->DespawnOrUnsummon();
                }
            }
        }

    private:
        static bool firstSpawn;
        bool pulledAt70;
        bool pulledAt30;
        bool yellDone;
        bool doorCloseDone;
        uint32 yellTimer = 2000;
        uint32 doorCloseTimer = 3000;
    };

    CreatureAI* GetAI(Creature* creature) const override {
        return new boss_ramstein_the_gorgerAI(creature);
    }
};

bool boss_ramstein_the_gorger::boss_ramstein_the_gorgerAI::firstSpawn = true;

class npc_custom_ooze : public CreatureScript
{
public:
    npc_custom_ooze() : CreatureScript("npc_custom_ooze") {}

    struct npc_custom_oozeAI : public ScriptedAI
    {
        npc_custom_oozeAI(Creature* creature) : ScriptedAI(creature)
        {
            creature->SetReactState(REACT_PASSIVE); // Set initial react state to passive
        }

        uint32 explosionSpellId = SPELL_ID_EXPLOSION;
        uint32 fixateTimer = 1000; // Initial delay before first fixate attempt
        Unit* lastFixatedTarget = nullptr;

        void Reset() override
        {
            DoCast(me, SPELL_ID_SELF_STUN, true);
            fixateTimer = 1000; // Reset fixate timer on reset
            me->SetReactState(REACT_PASSIVE); // Ensure react state is passive on reset
            lastFixatedTarget = nullptr;
        }

        void JustAppeared()
        {
            DoCast(me, SPELL_ID_SELF_STUN, true);
        }

        void JustDied(Unit* /*killer*/) override
        {
            if (lastFixatedTarget && lastFixatedTarget->IsAlive())
            {
                lastFixatedTarget->RemoveAurasDueToSpell(SPELL_ID_FIXATE); // Remove fixate aura from the target

                if (Creature* bot = lastFixatedTarget->ToCreature())
                {
                    if (bot->IsNPCBot())
                    {
                        bot->GetBotAI()->SetBotCommandState(BOT_COMMAND_FOLLOW, true); // Set the bot to follow mode
                    }
                }
            }
            me->DespawnOrUnsummon(1000); // Delay the despawn to 1 second after death
        }

        void UpdateAI(uint32 diff) override
        {
            if (!me->GetVictim()) {
                // No current victim, attempt to find and fixate on a new target
                if (fixateTimer <= diff) {
                    CastSpellOnRandomTarget(SPELL_ID_FIXATE, 100.0f);
                    fixateTimer = 5000;
                }
                else {
                    fixateTimer -= diff;
                }
            }
            else {
                // The ooze has a victim and is actively engaged
                if (me->IsWithinMeleeRange(me->GetVictim())) {
                    DoCast(me->GetVictim(), explosionSpellId); // Cast explosion if in range
                }
            }
        }

        void CastSpellOnRandomTarget(uint32 spellId, float range)
        {
            if (me->GetVictim()) return;

            std::list<Unit*> targets;
            Acore::AnyUnitInObjectRangeCheck check(me, range);
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
            Cell::VisitAllObjects(me, searcher, range);

            if (Creature* ramstein = me->FindNearestCreature(NPC_BOSS_RAMSTEIN, range, true))
            {
                Unit* ramsteinsTarget = ramstein->GetVictim();
                targets.remove_if([ramsteinsTarget](Unit* unit) -> bool {
                    return !unit->IsAlive() || unit == ramsteinsTarget || !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                    });
            }
            else
            {
                targets.remove_if([](Unit* unit) -> bool {
                    return !unit->IsAlive() || !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                    });
            }

            if (!targets.empty())
            {
                Unit* target = Acore::Containers::SelectRandomContainerElement(targets);
                me->AddThreat(target, 1000000.0f);
                me->AI()->AttackStart(target);
                me->GetMotionMaster()->MoveChase(target);
                DoCast(target, spellId, true);
                DoCast(target, 835846); // Immediately cast fixate on the target as soon as it is selected
                lastFixatedTarget = target;

                // Emote message when fixate spell is cast
                std::string targetName = target->GetName();
                std::string message = targetName + " is being fixated by an Digestive Slime!";
                me->TextEmote(message.c_str(), nullptr, true); // Send the emote to all players in the vicinity
                MoveBotsToPosition(target);
            }
        }

        void MoveBotsToPosition(Unit* target)
        {
            if (!target || target->GetTypeId() != TYPEID_UNIT || !static_cast<Creature*>(target)->IsNPCBot())
                return;

            // Get the current position of the ooze when fixate is cast
            float currentOozeX = me->GetPositionX();
            float currentOozeY = me->GetPositionY();

            Position const pos1 = { 4096.9614257812f, -3398.8784179688f, 115.96529388428f, 3.2046856880188f };
            Position const pos2 = { 3996.88671875f, -3394.4436035156f, 117.37201690674f, 3.1146523952484f };

            // Calculate absolute distances from the current ooze position to both positions
            float oozeDist1 = std::abs(me->GetDistance2d(pos1.GetPositionX(), pos1.GetPositionY()));
            float oozeDist2 = std::abs(me->GetDistance2d(pos2.GetPositionX(), pos2.GetPositionY()));

            // Choose the position with the greater absolute distance from the ooze's current position
            Position const& kitePosition = (oozeDist1 > oozeDist2) ? pos1 : pos2;

            Creature* bot = target->ToCreature();
            if (bot && bot->IsNPCBot() && bot->IsAlive())
            {
                bot->AttackStop();
                bot->InterruptNonMeleeSpells(true);
                bot->GetBotAI()->MoveToSendPosition(kitePosition); // Move bots to the chosen kite position
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_custom_oozeAI(creature);
    }
};

void AddSC_boss_ramstein_the_gorger()
{
    new boss_ramstein_the_gorger();
    new npc_custom_ooze();
}
