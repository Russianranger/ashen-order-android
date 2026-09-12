#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "TemporarySummon.h"
#include "../scripts/Custom/Timewalking/10Man.h"


enum Spells
{
    SPELL_CRUSADERSHAMMER = 17286,
    SPELL_CRUSADERSTRIKE = 17281,
    SPELL_HOLYSTRIKE = 17284,
    SPELL_BALNAZZARTRANSFORM = 17288,
    SPELL_SHADOWSHOCK = 17399,
    SPELL_MINDBLAST = 17287,
    SPELL_PSYCHICSCREAM = 13704,
    SPELL_SLEEP = 12098,
    SPELL_MINDCONTROL = 17405,
    SPELL_AVENGING_WRATH = 850837,
    SPELL_CARRION_SWARM = 831306,
    SPELL_INITIATE_DISCIPLINE = 861618
};

enum Events
{
    EVENT_CRUSADERS_HAMMER = 1,
    EVENT_CRUSADER_STRIKE,
    EVENT_HOLY_STRIKE,
    EVENT_TRANSFORM,
    EVENT_SHADOW_SHOCK,
    EVENT_MINDBLAST,
    EVENT_PSYCHIC_SCREAM,
    EVENT_SLEEP,
    EVENT_MIND_CONTROL,
    EVENT_AVENGING_WRATH,
    EVENT_CARRION_SWARM,
    EVENT_SUMMON_INITIATES  
};

enum Npcs
{
    NPC_DATHROHAN = 10812,
    NPC_BALNAZZAR = 10813,
    NPC_SKEL_BERSERKER = 10391,
    NPC_SKEL_GUARDIAN = 10390,
    NPC_CRIMSON_INITIATE = 10420
};

struct SummonPosition
{
    float x, y, z, orientation;
};

const SummonPosition summonPositions[] =
{
    {3444.156f, -3090.626f, 135.002f, 2.240f},
    {3449.123f, -3087.009f, 135.002f, 2.240f},
    {3446.246f, -3093.466f, 135.002f, 2.240f},
    {3451.160f, -3089.904f, 135.002f, 2.240f},
    {3457.995f, -3080.916f, 135.002f, 3.784f},
    {3454.302f, -3076.330f, 135.002f, 3.784f},
    {3460.975f, -3078.901f, 135.002f, 3.784f},
    {3457.338f, -3073.979f, 135.002f, 3.784f},
    {3479.995f, -3062.916f, 135.002f, 3.784f},
    {3476.302f, -3058.330f, 135.002f, 3.784f},
    {3482.975f, -3060.901f, 135.002f, 3.784f},
    {3479.338f, -3055.979f, 135.002f, 3.784f},
    {3501.995f, -3074.916f, 134.997f, 3.784f},
    {3498.302f, -3070.330f, 134.997f, 3.784f},
    {3504.975f, -3072.901f, 134.997f, 3.784f},
    {3501.338f, -3067.979f, 134.997f, 3.784f},
    {3530.995f, -3053.916f, 134.997f, 3.784f},
    {3527.302f, -3049.330f, 134.997f, 3.784f},
    {3533.975f, -3051.901f, 134.997f, 3.784f},
    {3530.338f, -3046.979f, 134.997f, 3.784f},
    {3559.995f, -3065.916f, 134.997f, 3.784f},
    {3556.302f, -3061.330f, 134.997f, 3.784f},
    {3562.975f, -3063.901f, 134.997f, 3.784f},
    {3559.338f, -3058.979f, 134.997f, 3.784f},
    {3591.995f, -3085.916f, 135.664f, 3.784f},
    {3588.302f, -3081.330f, 135.664f, 3.784f},
    {3594.975f, -3083.901f, 135.664f, 3.784f},
    {3591.338f, -3078.979f, 135.664f, 3.784f},
    {3624.995f, -3091.916f, 134.122f, 3.784f},
    {3621.302f, -3087.330f, 134.122f, 3.784f},
    {3627.975f, -3089.901f, 134.122f, 3.784f},
    {3624.338f, -3084.979f, 134.122f, 3.784f}
};

const SummonPosition initiateSummonPositions[] = {
    {3445.7478027344f, -3079.853515625f, 135.00335693359f, 2.3563125133514f},
    {3438.5419921875f, -3085.0681152344f, 135.00205993652f, 1.86958360672f}
};

class boss_dathrohan_balnazzar : public CreatureScript
{
public:
    boss_dathrohan_balnazzar() : CreatureScript("boss_dathrohan_balnazzar") {}

    struct boss_dathrohan_balnazzarAI : public ScriptedAI
    {
        boss_dathrohan_balnazzarAI(Creature* creature) : ScriptedAI(creature), transformed(false) {}

        bool transformed;  
        bool avengingWrathCast;
        
        void Reset() override
        {
            events.Reset();
            transformed = false;
            avengingWrathCast = false;
            me->UpdateEntry(NPC_DATHROHAN);
            std::list<Creature*> initiates;
            GetCreatureListWithEntryInGrid(initiates, me, NPC_CRIMSON_INITIATE, 200.0f);
            for (Creature* initiate : initiates) {
                initiate->DespawnOrUnsummon();
            }
        }

        void JustDied(Unit* /*killer*/) override
        {
            me->Yell("Damn you mortals! All my plans of revenge, all my hate... all burned to ash...", LANG_UNIVERSAL);

            for (const auto& position : summonPositions)
            {
                me->SummonCreature(rand() % 2 ? NPC_SKEL_BERSERKER : NPC_SKEL_GUARDIAN,
                    position.x, position.y, position.z, position.orientation,
                    TEMPSUMMON_DEAD_DESPAWN, HOUR * IN_MILLISECONDS);
            }
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
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.ScheduleEvent(EVENT_CRUSADERS_HAMMER, 8000);
            events.ScheduleEvent(EVENT_CRUSADER_STRIKE, 12000);
            events.ScheduleEvent(EVENT_HOLY_STRIKE, 18000);
            events.ScheduleEvent(EVENT_TRANSFORM, 1000);
            events.ScheduleEvent(EVENT_SUMMON_INITIATES, 20000);
        }

        void CastSpellOnRandomTarget(uint32 spellId, float range)
        {
            std::list<Unit*> targets;
            Acore::AnyUnitInObjectRangeCheck check(me, range);
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
            Cell::VisitAllObjects(me, searcher, range);

            targets.remove_if([this](Unit* unit) -> bool {
                return !unit->IsAlive() || !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                });

            if (!targets.empty())
            {
                Unit* target = Acore::Containers::SelectRandomContainerElement(targets);
                DoCast(target, spellId);
            }
        }
        
        void TransformAndDisciplineInitiates()
        {
            std::list<Creature*> initiates;
            GetCreatureListWithEntryInGrid(initiates, me, NPC_CRIMSON_INITIATE, 100.0f); // Check within 100 meters
            for (Creature* initiate : initiates) {
                me->CastSpell(initiate, 5, true); 
                initiate->CastSpell(initiate, SPELL_INITIATE_DISCIPLINE, true); 
            }

            if (!initiates.empty()) {
                me->Yell("Useless!", LANG_UNIVERSAL);
            }
        }
        
        void ExecuteEvent(uint32 eventId) 
        {
            if (eventId == EVENT_TRANSFORM)
            {
                if (HealthBelowPct(18) && !transformed)
                {
                    DoCast(me, SPELL_BALNAZZARTRANSFORM);
                    me->UpdateEntry(NPC_BALNAZZAR);
                    transformed = true;
                    TransformAndDisciplineInitiates();
                    events.ScheduleEvent(EVENT_SHADOW_SHOCK, 11000);
                    events.ScheduleEvent(EVENT_CARRION_SWARM, 8000);
                    events.ScheduleEvent(EVENT_MINDBLAST, 6000);
                    events.ScheduleEvent(EVENT_PSYCHIC_SCREAM, 12000);
                    events.ScheduleEvent(EVENT_SLEEP, 9000);
                    events.ScheduleEvent(EVENT_MIND_CONTROL, 18000);
                }
                events.ScheduleEvent(EVENT_TRANSFORM, 1000); // Continue checking every second
                return; // Return early to prevent blocking other events
            }

            if (transformed)
            {
                // Balnazzar abilities
                switch (eventId)
                {
                case EVENT_SHADOW_SHOCK:
                    DoCastVictim(SPELL_SHADOWSHOCK);
                    events.ScheduleEvent(EVENT_SHADOW_SHOCK, 11000);
                    break;
                case EVENT_CARRION_SWARM:
                    DoCastVictim(SPELL_CARRION_SWARM);
                    events.ScheduleEvent(EVENT_CARRION_SWARM, urand(12000, 22000));
                    break;
                case EVENT_MINDBLAST:
                    DoCastVictim(SPELL_MINDBLAST, true);
                    events.ScheduleEvent(EVENT_MINDBLAST, urand(15000, 20000));
                    break;
                case EVENT_PSYCHIC_SCREAM:
                    DoCast(SPELL_PSYCHICSCREAM);
                    events.ScheduleEvent(EVENT_PSYCHIC_SCREAM, 20000);
                    break;
                case EVENT_SLEEP:
                    CastSpellOnRandomTarget(SPELL_SLEEP, 80.0f);
                    events.ScheduleEvent(EVENT_SLEEP, 15000);
                    break;
                case EVENT_MIND_CONTROL:
                    if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0))
                        DoCast(target, SPELL_MINDCONTROL);
                    events.ScheduleEvent(EVENT_MIND_CONTROL, urand(25000, 30000));
                    break;
                }
            }
            else
            {
                // Dathrohan abilities
                switch (eventId)
                {
                case EVENT_CRUSADERS_HAMMER:
                    DoCast(SPELL_CRUSADERSHAMMER);
                    events.ScheduleEvent(EVENT_CRUSADERS_HAMMER, 12000);
                    break;
                case EVENT_CRUSADER_STRIKE:
                    DoCastVictim(SPELL_CRUSADERSTRIKE);
                    events.ScheduleEvent(EVENT_CRUSADER_STRIKE, 15000);
                    break;
                case EVENT_HOLY_STRIKE:
                    DoCastVictim(SPELL_HOLYSTRIKE);
                    events.ScheduleEvent(EVENT_HOLY_STRIKE, 18000);
                    break;
                case EVENT_AVENGING_WRATH:
                    if (!avengingWrathCast)
                    {
                        me->Yell("Feel the wrath of the Light!", LANG_UNIVERSAL);
                        DoCast(me, SPELL_AVENGING_WRATH, true);
                        avengingWrathCast = true;
                    }
                    break;
                case EVENT_SUMMON_INITIATES:
                    me->Yell("Initiates, now is the time to prove yourselves! To me!", LANG_UNIVERSAL);
                    for (const auto& pos : initiateSummonPositions) {
                        Creature* initiate = me->SummonCreature(NPC_CRIMSON_INITIATE, pos.x, pos.y, pos.z, pos.orientation, TEMPSUMMON_TIMED_DESPAWN, 300000);
                        if (initiate) {
                            initiate->SetInCombatWithZone();
                        }
                    }
                    events.ScheduleEvent(EVENT_SUMMON_INITIATES, 40000);  
                    break;
                }
            }
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            events.Update(diff);

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            if (me->HealthBelowPct(60) && !avengingWrathCast) {
                ExecuteEvent(EVENT_AVENGING_WRATH);
            }

            while (uint32 eventId = events.ExecuteEvent())
            {
                ExecuteEvent(eventId);
            }

            DoMeleeAttackIfReady();
        }

    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_dathrohan_balnazzarAI(creature);
    }
};

void AddSC_boss_dathrohan_balnazzar()
{
    new boss_dathrohan_balnazzar();
}
