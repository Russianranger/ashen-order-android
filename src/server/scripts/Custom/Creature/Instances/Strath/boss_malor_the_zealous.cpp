#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "../scripts/Custom/Timewalking/10Man.h"

const char* SAY_MALOR_AGGRO = "Intruders! The Light shall be your end!";
const char* SAY_MALOR_DIVINE_STORM = "Feel the divine storm!";
const char* SAY_MALOR_HOLY_LIGHT = "The Light restores me!";
const char* SAY_MALOR_DEATH = "I have failed... The Crusade...";

enum Spells
{
    SPELL_DIVINE_STORM = 53385,
    SPELL_HOLY_LIGHT = 25292,
    SPELL_JUDGEMENT = 20271,
    SPELL_HAMMER_OF_JUSTICE = 853,
    SPELL_SEAL_OF_COMMAND = 20375,
    SPELL_CRUSADER_STRIKE = 17281
};

enum Events
{
    EVENT_DIVINE_STORM = 1,
    EVENT_HOLY_LIGHT,
    EVENT_JUDGEMENT,
    EVENT_HAMMER_OF_JUSTICE,
    EVENT_CRUSADER_STRIKE
};

class boss_malor_the_zealous : public CreatureScript
{
public:
    boss_malor_the_zealous() : CreatureScript("boss_malor_the_zealous") {}

    struct boss_malor_the_zealousAI : public ScriptedAI
    {
        boss_malor_the_zealousAI(Creature* creature) : ScriptedAI(creature) {}

        void Reset() override
        {
            ScriptedAI::Reset();
            events.Reset();  
        }

        void JustEngagedWith(Unit* who) override
        {
            me->Yell(SAY_MALOR_AGGRO, LANG_UNIVERSAL);
            DoCast(me, SPELL_SEAL_OF_COMMAND, true);
            events.ScheduleEvent(EVENT_DIVINE_STORM, 10000);
            events.ScheduleEvent(EVENT_HOLY_LIGHT, 8000);
            events.ScheduleEvent(EVENT_JUDGEMENT, 6000);
            events.ScheduleEvent(EVENT_HAMMER_OF_JUSTICE, 15000);
            events.ScheduleEvent(EVENT_CRUSADER_STRIKE, 12000);
        }

        void KilledUnit(Unit* victim) override
        {
            if (victim->IsPlayer())
                me->Say(SAY_MALOR_DIVINE_STORM, LANG_UNIVERSAL);
        }

        void JustDied(Unit* /*killer*/) override
        {
            me->Yell(SAY_MALOR_DEATH, LANG_UNIVERSAL);
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

        void ExecuteEvent(uint32 eventId)
        {
            switch (eventId)
            {
            case EVENT_DIVINE_STORM:
                DoCastVictim(SPELL_DIVINE_STORM);
                events.ScheduleEvent(EVENT_DIVINE_STORM, 20000);
                break;
            case EVENT_HOLY_LIGHT:
                if (HealthBelowPct(50))
                {
                    DoCast(me, SPELL_HOLY_LIGHT);
                    me->Say(SAY_MALOR_HOLY_LIGHT, LANG_UNIVERSAL);
                }
                events.ScheduleEvent(EVENT_HOLY_LIGHT, 17000);
                break;
            case EVENT_JUDGEMENT:
                DoCastVictim(SPELL_JUDGEMENT, true);
                events.ScheduleEvent(EVENT_JUDGEMENT, 15000);
                break;
            case EVENT_HAMMER_OF_JUSTICE:
                if (Unit* target = SelectTarget(SelectTargetMethod::Random, 0, 30.0f, false))
                {
                    DoCast(target, SPELL_HAMMER_OF_JUSTICE);
                }
                events.ScheduleEvent(EVENT_HAMMER_OF_JUSTICE, 20000);
                break;
            case EVENT_CRUSADER_STRIKE:  // Handle Crusader Strike
                DoCastVictim(SPELL_CRUSADER_STRIKE);
                events.ScheduleEvent(EVENT_CRUSADER_STRIKE, 12000);  // Reschedule as needed
                break;
            }
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            events.Update(diff);

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            while (uint32 eventId = events.ExecuteEvent())
            {
                ExecuteEvent(eventId);
            }

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_malor_the_zealousAI(creature);
    }
};

void AddSC_boss_malor_the_zealous()
{
    new boss_malor_the_zealous();
}
