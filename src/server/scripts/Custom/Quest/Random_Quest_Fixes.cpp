#include "ScriptMgr.h"
#include "Player.h"
#include "Creature.h"
#include "ScriptedCreature.h"
#include "CreatureAI.h"

enum NPC_IDS
{
    NPC_ID_AQUILA = 100139,
    NPC_ID_SHADOWCLOUD = 1500017,
    NPC_ID_KLOVERIELL = 100140,
    NPC_ID_VESPRYSTUS = 3838

};

enum SPELL_IDS
{
    SPELL_ID = 80102
};

enum QUEST_IDS
{
    QUEST_ID_AQUILA = 30032,
};

enum Actions
{
    ACTION_COMPLETE_QUEST = 1
};

enum Events
{
    EVENT_SHADOWCLOUD_SAY = 1,
    EVENT_AQUILA_SAY_II,
    EVENT_KLOVERIELL_SAY
};

enum BarrelQuestConstants
{
    SPELL_ID_BARREL_QUEST = 80106,
    QUEST_ID_BARREL_QUEST = 30036,
    CREATURE_ID_BARREL = 29692,
    SPAWN_DELAY_MS = 6000,
    DESPAWN_DELAY_MS = 20000
};

Position const BARREL_SPAWN_POSITION(-8936.0f, 635.0f, 98.88f, 0.0f);

class npc_aquila : public CreatureScript
{
public:
    npc_aquila() : CreatureScript("npc_aquila") {}

    struct npc_aquilaAI : public ScriptedAI
    {
        npc_aquilaAI(Creature* creature) : ScriptedAI(creature) {}

        void DoAction(int32 action) override
        {
            if (action == ACTION_COMPLETE_QUEST)
            {
                // Cast spell on Aquila
                me->CastSpell(me, SPELL_ID, false);
                me->Say("Preparations are complete...now for the vital part.", LANG_UNIVERSAL);

                // Schedule another NPC's say event
                if (Creature* anotherNpc = GetClosestCreatureWithEntry(me, NPC_ID_SHADOWCLOUD, 15.0f))
                {
                    events.ScheduleEvent(EVENT_SHADOWCLOUD_SAY, 9000);
                }

                // Schedule Aquila's response
                events.ScheduleEvent(EVENT_AQUILA_SAY_II, 14000);

                // Schedule Kloveriell's say event
                if (Creature* kloveriell = GetClosestCreatureWithEntry(me, NPC_ID_KLOVERIELL, 20.0f))
                {
                    events.ScheduleEvent(EVENT_KLOVERIELL_SAY, 20000);
                }
            }
        }

        void UpdateAI(uint32 diff) override
        {
            events.Update(diff);

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_SHADOWCLOUD_SAY:
                    if (Creature* anotherNpc = GetClosestCreatureWithEntry(me, NPC_ID_SHADOWCLOUD, 15.0f))
                    {
                        anotherNpc->Say("Aquila, may I have a word? The messenger who just arrived has brought forth some intriguing information that demands immediate attention. Could I per chance borrow your little helper here?", LANG_UNIVERSAL);
                        anotherNpc->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                    }
                    break;
                case EVENT_AQUILA_SAY_II:
                    me->Say("Oh very well. Kloveriell, see to it that these crystals are properly positioned around the city.", LANG_UNIVERSAL);
                    break;
                case EVENT_KLOVERIELL_SAY:
                    if (Creature* kloveriell = GetClosestCreatureWithEntry(me, NPC_ID_KLOVERIELL, 20.0f))
                    {
                        kloveriell->Say("Yes, High Priestess", LANG_UNIVERSAL);
                        kloveriell->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                    }
                    break;
                default:
                    break;
                }
            }
        }

    private:
        EventMap events;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_aquilaAI(creature);
    }

    bool OnQuestReward(Player* player, Creature* creature, const Quest* quest, uint32 /*opt*/) override
    {
        if (quest->GetQuestId() == QUEST_ID_AQUILA)
        {
            if (creature && creature->AI())
            {
                creature->AI()->DoAction(ACTION_COMPLETE_QUEST);
            }
        }
        return true;
    }
};

class spell_barrel_quest : public SpellScriptLoader
{
public:
    spell_barrel_quest() : SpellScriptLoader("spell_barrel_quest") { }

    class spell_barrel_quest_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_barrel_quest_SpellScript);

        SpellCastResult HandleCheckCast()
        {
            Player* player = GetCaster()->ToPlayer();
            if (!player)
                return SPELL_FAILED_CASTER_DEAD;

            Position const& playerPos = player->GetPosition();
            float distance = playerPos.GetExactDist2d(&BARREL_SPAWN_POSITION);

            if (distance > 5.0f)
            {
                ChatHandler(player->GetSession()).PSendSysMessage("You need to be closer to the ladder to use that item.");
                return SPELL_FAILED_OUT_OF_RANGE;
            }

            return SPELL_CAST_OK;
        }

        void HandleOnCast()
        {
            Player* player = GetCaster()->ToPlayer();
            if (!player)
                return;

            player->m_scheduler.Schedule(Milliseconds(SPAWN_DELAY_MS), [player](TaskContext /*context*/)
                {
                    Creature* spawnedCreature = player->SummonCreature(CREATURE_ID_BARREL, BARREL_SPAWN_POSITION, TEMPSUMMON_TIMED_DESPAWN, DESPAWN_DELAY_MS);
                    if (spawnedCreature)
                    {
                        // Additional actions
                    }
                });
        }

        void Register() override
        {
            OnCheckCast += SpellCheckCastFn(spell_barrel_quest_SpellScript::HandleCheckCast);
            OnCast += SpellCastFn(spell_barrel_quest_SpellScript::HandleOnCast);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_barrel_quest_SpellScript();
    }
};

//Defias.lua
class npc_stormwind_defias : public CreatureScript
{
public:
    npc_stormwind_defias() : CreatureScript("npc_stormwind_defias") { }

    struct npc_stormwind_defiasAI : public ScriptedAI
    {
        npc_stormwind_defiasAI(Creature* creature) : ScriptedAI(creature) { }

        void JustEngagedWith(Unit* who) override
        {
            me->Say("You can't have our explosives!", LANG_UNIVERSAL);
        }

        void JustDied(Unit* /*killer*/) override
        {
            me->Say("Ugh...our grand entrance is ruined...", LANG_UNIVERSAL);
        }

        void UpdateAI(uint32 diff) override
        {
            ScriptedAI::UpdateAI(diff);

            if (!UpdateVictim())
                return;

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_stormwind_defiasAI(creature);
    }
};

enum AverySpells
{
    SPELL_CAST_ON_SPAWN = 67040,
    SPELL_SHADOW_BOLT = 695
};


enum AveryEvents
{
    EVENT_SHADOW_BOLT = 1,
    EVENT_RECAST_SPELL = 2
};

class Npc_Avery : public CreatureScript
{
public:
    Npc_Avery() : CreatureScript("Npc_Avery") { }

    struct npc_averyAI : public ScriptedAI
    {
        npc_averyAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override
        {
            events.Reset();
            events.ScheduleEvent(EVENT_RECAST_SPELL, 8000);
        }

        void JustEngagedWith(Unit* who) override
        {
            me->Say("I will not permit you to interfere!", LANG_UNIVERSAL);
            events.ScheduleEvent(EVENT_SHADOW_BOLT, 3000); 
        }

        void JustDied(Unit* /*killer*/) override
        {
            me->Say("We were so...close....", LANG_UNIVERSAL);
            events.Reset();
        }

        void EnterEvadeMode(EvadeReason /*why*/) override
        {
            ScriptedAI::EnterEvadeMode();
            events.Reset();
        }

        void UpdateAI(uint32 diff) override
        {
            ScriptedAI::UpdateAI(diff);

            if (!UpdateVictim())
                return;

            events.Update(diff);

            switch (events.ExecuteEvent())
            {
            case EVENT_SHADOW_BOLT:
                if (Unit* target = me->GetVictim())
                {
                    me->CastSpell(target, SPELL_SHADOW_BOLT, false);
                    events.ScheduleEvent(EVENT_SHADOW_BOLT, 3000);
                }
                break;
            case EVENT_RECAST_SPELL:
                me->CastSpell(me, SPELL_CAST_ON_SPAWN, false);
                break;
            default:
                break;
            }
        }

    private:
        EventMap events;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_averyAI(creature);
    }
};

void AddSC_randomquestfixes()
{
    new npc_aquila();
    new spell_barrel_quest();
    new npc_stormwind_defias();
    new Npc_Avery();
}
