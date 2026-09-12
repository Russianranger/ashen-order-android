#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "GridNotifiers.h"
#include "GridNotifiersImpl.h"
#include "CellImpl.h"
#include "CreatureData.h"
#include "SpellScript.h"
#include "../scripts/Custom/Timewalking/10Man.h"


enum Spells
{
    SPELL_FROST_ARMOR = 18100,
    SPELL_FEAR = 12096,
    SPELL_FROSTBOLT_VOLLEY = 8398,
    SPELL_FREEZE = 18763,
    SPELL_CHILL_NOVA = 18099,
    SPELL_ICE_TOMB_TRAP = 836911,
};

enum Events
{
    EVENT_FROST_ARMOR = 1,
    EVENT_FEAR,
    EVENT_FROSTBOLT_VOLLEY,
    EVENT_FREEZE,
    EVENT_CHILL_NOVA,
    EVENT_ICE_TOMB
};

enum Npcs
{
    NPC_ICE_TOMB = 836980 
};

class npc_ras_frostwhisper_ice_tomb : public CreatureScript
{
public:
    npc_ras_frostwhisper_ice_tomb() : CreatureScript("npc_ras_frostwhisper_ice_tomb") {}

    struct npc_ras_frostwhisper_ice_tombAI : public NullCreatureAI
    {
        ObjectGuid targetGuid; 

        npc_ras_frostwhisper_ice_tombAI(Creature* creature) : NullCreatureAI(creature)
        {
            me->SetReactState(REACT_PASSIVE);
        }

        void SetGUID(ObjectGuid guid, int32 /*type*/) override
        {
            targetGuid = guid; 
        }

        void JustDied(Unit* /*killer*/) override
        {
            if (Unit* target = ObjectAccessor::GetUnit(*me, targetGuid))
            {
                target->RemoveAura(SPELL_ICE_TOMB_TRAP); 
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

        void UpdateAI(uint32 /*diff*/) override {}
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_ras_frostwhisper_ice_tombAI(creature);
    }
};


class boss_ras_frostwhisper : public CreatureScript
{
public:
    boss_ras_frostwhisper() : CreatureScript("boss_ras_frostwhisper") { }

    struct boss_ras_frostwhisperAI : public ScriptedAI
    {
        boss_ras_frostwhisperAI(Creature* creature) : ScriptedAI(creature) { }

        EventMap events;

        void Reset() override
        {
            events.Reset();
            events.ScheduleEvent(EVENT_FROST_ARMOR, 45min);
            CastSpellOnIceTombs(5);
        }

        void JustDied(Unit* /*killer*/) override
        {
            CastSpellOnIceTombs(5);
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            if (players.begin() != players.end())
            {
                uint32 baseRewardLevel = 1;
                bool isDungeon = me->GetMap()->IsDungeon();

                Player* player = players.begin()->GetSource();
                if (player)
                {
                    DistributeChallengeRewards(player, me, baseRewardLevel, isDungeon);
                }
            }
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            DoCast(me, SPELL_FROST_ARMOR);
            events.ScheduleEvent(EVENT_FEAR, urand(7000, 15000));
            events.ScheduleEvent(EVENT_FROSTBOLT_VOLLEY, urand(3000, 6000));
            events.ScheduleEvent(EVENT_FREEZE, urand(7000, 10000));
            events.ScheduleEvent(EVENT_CHILL_NOVA, urand(15000, 20000));
            events.ScheduleEvent(EVENT_ICE_TOMB, urand(5000, 15000));
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            events.Update(diff);

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_FROST_ARMOR:
                    DoCast(me, SPELL_FROST_ARMOR);
                    events.ScheduleEvent(EVENT_FROST_ARMOR, 45min);
                    break;
                case EVENT_FEAR:
                {
                    std::list<Unit*> targets;
                    Acore::AnyUnitInObjectRangeCheck check(me, 100.0f);
                    Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
                    Cell::VisitAllObjects(me, searcher, 100.0f);

                    Unit* currentVictim = me->GetVictim(); // Get the current victim

                    targets.remove_if([this, currentVictim](Unit* unit) -> bool {
                        return !unit->IsAlive() || unit->HasAura(SPELL_ICE_TOMB_TRAP) || unit == currentVictim ||
                            !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                        });

                    if (!targets.empty())
                    {
                        Unit* target = Acore::Containers::SelectRandomContainerElement(targets);
                        DoCast(target, SPELL_FEAR);
                    }

                    events.ScheduleEvent(EVENT_FEAR, urand(15000, 25000));
                    break;
                }
                case EVENT_FROSTBOLT_VOLLEY:
                    DoCast(me, SPELL_FROSTBOLT_VOLLEY);
                    events.ScheduleEvent(EVENT_FROSTBOLT_VOLLEY, urand(7000, 12000));
                    break;
                case EVENT_FREEZE:
                {
                    std::list<Unit*> targets;
                    Acore::AnyUnitInObjectRangeCheck check(me, 100.0f); // Adjust the range as needed
                    Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
                    Cell::VisitAllObjects(me, searcher, 100.0f);
                    targets.remove_if([this](Unit* unit) -> bool {
                        return !unit->IsAlive() || unit->HasAura(SPELL_ICE_TOMB_TRAP) ||
                            !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                        });

                    if (!targets.empty())
                    {
                        Unit* target = Acore::Containers::SelectRandomContainerElement(targets);
                        DoCast(target, SPELL_FREEZE);
                    }
                    events.ScheduleEvent(EVENT_FREEZE, 20000);
                    break;
                }
                case EVENT_CHILL_NOVA:
                    DoCast(me, SPELL_CHILL_NOVA);
                    events.ScheduleEvent(EVENT_CHILL_NOVA, 20000);
                    break;
                case EVENT_ICE_TOMB:
                {
                    std::vector<Unit*> potentialTargets;

                    std::list<Unit*> units;
                    Acore::AnyUnitInObjectRangeCheck unitCheck(me, 100.0f);
                    Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> unitSearcher(me, units, unitCheck);
                    Cell::VisitAllObjects(me, unitSearcher, 100.0f);
                    Unit* currentVictim = me->GetVictim();
                    
                    for (Unit* unit : units)
                    {
                        if (unit->IsAlive() && !unit->HasAura(SPELL_ICE_TOMB_TRAP) &&
                            (unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot())) &&
                            unit != currentVictim) // Exclude the current victim
                        {
                            potentialTargets.push_back(unit);
                        }
                    }

                    if (!potentialTargets.empty())
                    {
                        Unit* target = Acore::Containers::SelectRandomContainerElement(potentialTargets);
                        me->CastSpell(target, SPELL_ICE_TOMB_TRAP, true);
                        me->Yell("A frozen tomb will be your final resting place!", LANG_UNIVERSAL);
                        Creature* iceTomb = me->SummonCreature(NPC_ICE_TOMB, target->GetPositionX(), target->GetPositionY(), target->GetPositionZ(), 0, TEMPSUMMON_MANUAL_DESPAWN);
                        if (iceTomb)
                        {
                            if (npc_ras_frostwhisper_ice_tomb::npc_ras_frostwhisper_ice_tombAI* iceTombAI = dynamic_cast<npc_ras_frostwhisper_ice_tomb::npc_ras_frostwhisper_ice_tombAI*>(iceTomb->GetAI()))
                            {
                                iceTombAI->SetGUID(target->GetGUID(), 0);
                            }
                        }
                    }

                    events.ScheduleEvent(EVENT_ICE_TOMB, urand(26000, 30000));
                    break;
                }
                }
            }

            DoMeleeAttackIfReady();
        }
        void CastSpellOnIceTombs(uint32 spellId)
        {
            std::list<Creature*> iceTombs;
            GetCreatureListWithEntryInGrid(iceTombs, me, NPC_ICE_TOMB, 200.0f); 

            for (Creature* iceTomb : iceTombs)
            {
                me->CastSpell(iceTomb, spellId, true); 
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_ras_frostwhisperAI(creature);
    }
};

class spell_chill_nova : public SpellScriptLoader
{
public:
    spell_chill_nova() : SpellScriptLoader("spell_chill_nova") { }

    class spell_chill_nova_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_chill_nova_SpellScript);

        void FilterTargets(std::list<WorldObject*>& targets)
        {
            targets.remove_if([](WorldObject* obj) -> bool
                {
                    return obj->ToUnit() && obj->ToUnit()->HasAura(SPELL_ICE_TOMB_TRAP);
                });
        }

        void Register() override
        {
            OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_chill_nova_SpellScript::FilterTargets, EFFECT_0, TARGET_UNIT_SRC_AREA_ENEMY);
            OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_chill_nova_SpellScript::FilterTargets, EFFECT_1, TARGET_UNIT_SRC_AREA_ENEMY);
            OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_chill_nova_SpellScript::FilterTargets, EFFECT_2, TARGET_UNIT_SRC_AREA_ENEMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_chill_nova_SpellScript();
    }
};

class spell_ras_frostbolt_volley_custom : public SpellScriptLoader
{
public:
    spell_ras_frostbolt_volley_custom() : SpellScriptLoader("spell_ras_frostbolt_volley_custom") { }

    class spell_ras_frostbolt_volley_custom_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_ras_frostbolt_volley_custom_SpellScript);

        void FilterTargets(std::list<WorldObject*>& targets)
        {
            targets.remove_if([](WorldObject* obj) -> bool
                {
                    return obj->ToUnit() && obj->ToUnit()->HasAura(SPELL_ICE_TOMB_TRAP);
                });
        }

        void Register() override
        {
            OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_ras_frostbolt_volley_custom_SpellScript::FilterTargets, EFFECT_0, TARGET_UNIT_SRC_AREA_ENEMY);
            OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_ras_frostbolt_volley_custom_SpellScript::FilterTargets, EFFECT_1, TARGET_UNIT_SRC_AREA_ENEMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_ras_frostbolt_volley_custom_SpellScript();
    }
};

void AddSC_boss_ras_frostwhisper()
{
    new boss_ras_frostwhisper();
    new npc_ras_frostwhisper_ice_tomb();
    new spell_chill_nova();
    new spell_ras_frostbolt_volley_custom();
}
