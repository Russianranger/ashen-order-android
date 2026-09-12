#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "Creature.h"
#include "Player.h"
#include "MotionMaster.h"
#include "EventMap.h"
#include "ObjectMgr.h"
#include "GameObject.h"

enum TricktotemSpells
{
    SPELL_EARTH_BOLT = 900673,
    SPELL_GREATER_HEALING_RAPIDS = 900674,
    SPELL_SUMMON_TOTEM = 900676
};

enum TricktotemSounds
{
    SOUND_GREATER_HEALING_RAPIDS = 188120,
    SOUND_SUMMON_TOTEM = 188121,
    SOUND_DEATH = 188115
};

enum TricktotemEvents
{
    EVENT_MOVE_TO_CASTING_POSITION = 1,
    EVENT_EARTH_BOLT,
    EVENT_GREATER_HEALING_RAPIDS,
    EVENT_SUMMON_TOTEM,
    EVENT_CHECK_VICTIM_DISTANCE
};

enum RiraHackclawSpells
{
    SPELL_CLEAVE = 900677,
    SPELL_CHARGE = 900678,
    SPELL_BLADESTORM = 900679,
    SPELL_REND = 821949
};

enum RiraHackclawSounds
{
    RIRA_SOUND_AGGRO = 188117,
    RIRA_SOUND_LEAVE_COMBAT = 188122,
    RIRA_SOUND_DEATH = 188123
};

enum RiraHackclawEvents
{
    EVENT_CAST_CLEAVE = 1,
    EVENT_CAST_CHARGE,
    EVENT_CAST_BLADESTORM
};

enum GashtoothSpells
{
    SPELL_DECAYED_SENSES = 900683,
    SPELL_GASH_FRENZY = 51690
};

enum GashtoothSounds
{
    SOUND_GASH_FRENZY = 188119,
    SOUND_GASH_DEATH = 188118
};

enum GashtoothEvents
{
    EVENT_CAST_DECAYED_SENSES = 1,
    EVENT_CAST_GASH_FRENZY
};

enum TrioSharedSpells
{
    SPELL_ENRAGE = 830485,
    SPELL_ENRAGE_2 = 830486

};

enum TrioSharedData
{
    NPC_TRICKTOTEM = 900617,
    NPC_RIRA_HACKCLAW = 900615,
    NPC_GASHTOOTH = 900616,
    NPC_TO_DESPAWN = 900619
};

template <typename AI>
class TrioSharedAI : public ScriptedAI
{
public:
    TrioSharedAI(Creature* creature) : ScriptedAI(creature) {}

    void Reset() override
    {
        events.Reset();
        RespawnOtherTrioMembers();
    }

    void RespawnOtherTrioMembers()
    {
        uint32 members[] = { NPC_TRICKTOTEM, NPC_RIRA_HACKCLAW, NPC_GASHTOOTH };
        std::list<Creature*> nearbyCreatures;

        for (uint32 entry : members)
        {
            if (entry != me->GetEntry())
            {
                me->GetCreatureListWithEntryInGrid(nearbyCreatures, entry, 100.0f);
            }
        }

        for (Creature* member : nearbyCreatures)
        {
            if (!member->IsAlive())
            {
                member->Respawn();
            }
        }
    }

    void HandleTrioDeath()
    {
        uint32 members[] = { NPC_TRICKTOTEM, NPC_RIRA_HACKCLAW, NPC_GASHTOOTH };
        std::list<Creature*> nearbyCreatures;
        bool allDead = true;

        for (uint32 entry : members)
        {
            me->GetCreatureListWithEntryInGrid(nearbyCreatures, entry, 100.0f);
        }

        for (Creature* member : nearbyCreatures)
        {
            if (member->IsAlive())
            {
                allDead = false;

                if (member->HasAura(SPELL_ENRAGE))
                {
                    me->CastSpell(member, SPELL_ENRAGE_2, true);
                }
                else
                {
                    me->CastSpell(member, SPELL_ENRAGE, true);
                }
            }
        }

        if (allDead)
        {
            if (Creature* nearbyNPC = me->FindNearestCreature(NPC_TO_DESPAWN, 100.0f))
            {
                nearbyNPC->DespawnOrUnsummon();
            }

            me->CastSpell(me, 862950, true);
        }
    }

    void JustDied(Unit* /*killer*/) override
    {
        switch (me->GetEntry())
        {
        case NPC_GASHTOOTH:
            me->PlayDirectSound(188118);
            me->Yell("Didn't... cut... deep enough...", LANG_UNIVERSAL);
            break;

        case NPC_RIRA_HACKCLAW:
            me->PlayDirectSound(188123);
            me->Yell("Couldn't... hack it...", LANG_UNIVERSAL);
            break;

        case NPC_TRICKTOTEM:
            me->PlayDirectSound(188115);
            me->Yell("All....out of tricks...", LANG_UNIVERSAL);
            break;
        }

        HandleTrioDeath();
    }
};

class npc_tricktotem_hexxer : public CreatureScript
{
public:
    npc_tricktotem_hexxer() : CreatureScript("npc_tricktotem_hexxer") { }

    struct npc_tricktotem_hexxerAI : public TrioSharedAI<npc_tricktotem_hexxerAI>
    {
        npc_tricktotem_hexxerAI(Creature* creature) : TrioSharedAI(creature), isMoving(false), inCastingPosition(false) { }

        bool isMoving;
        bool inCastingPosition;

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.ScheduleEvent(EVENT_GREATER_HEALING_RAPIDS, 14000);
            events.ScheduleEvent(EVENT_SUMMON_TOTEM, 48000);
            events.ScheduleEvent(EVENT_MOVE_TO_CASTING_POSITION, 15000);
        }

        void MovementInform(uint32 type, uint32 id) override
        {
            if (type == POINT_MOTION_TYPE && id == 1)
            {
                isMoving = false;
                inCastingPosition = true;
                me->GetMotionMaster()->MoveIdle();

                events.ScheduleEvent(EVENT_EARTH_BOLT, 1000);
                events.ScheduleEvent(EVENT_CHECK_VICTIM_DISTANCE, 1000);
            }
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            events.Update(diff);

            if (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_GREATER_HEALING_RAPIDS:
                    if (inCastingPosition)
                    {
                        me->InterruptNonMeleeSpells(false);
                    }

                    if (me->CanCastSpell(SPELL_GREATER_HEALING_RAPIDS))
                    {
                        me->Yell("Water, fix our meat.", LANG_UNIVERSAL);
                        me->PlayDirectSound(SOUND_GREATER_HEALING_RAPIDS);
                        me->CastSpell(me, SPELL_GREATER_HEALING_RAPIDS, false);
                    }
                    events.ScheduleEvent(EVENT_GREATER_HEALING_RAPIDS, 14000);

                    if (inCastingPosition)
                    {
                        events.ScheduleEvent(EVENT_EARTH_BOLT, 1000);
                    }
                    break;
                case EVENT_SUMMON_TOTEM:
                    if (inCastingPosition)
                    {
                        me->InterruptNonMeleeSpells(false);
                    }

                    if (me->CanCastSpell(SPELL_SUMMON_TOTEM))
                    {
                        me->Yell("Heh, heh... Let me show you good trick.", LANG_UNIVERSAL);
                        me->PlayDirectSound(SOUND_SUMMON_TOTEM);
                        me->CastSpell(me, SPELL_SUMMON_TOTEM, true);
                    }
                    events.ScheduleEvent(EVENT_SUMMON_TOTEM, 48000);

                    if (inCastingPosition)
                    {
                        events.ScheduleEvent(EVENT_EARTH_BOLT, 1000);
                    }
                    break;
                case EVENT_MOVE_TO_CASTING_POSITION:
                    if (Unit* victim = me->GetVictim())
                    {
                        Position moveTo = victim->GetNearPosition(20.0f, float(M_PI));
                        me->GetMotionMaster()->MovePoint(1, moveTo);

                        isMoving = true;
                    }
                    break;
                case EVENT_EARTH_BOLT:
                    if (inCastingPosition)
                    {
                        if (!me->IsWithinCombatRange(me->GetVictim(), 45.0f) || !me->CanCastSpell(SPELL_EARTH_BOLT))
                        {
                            inCastingPosition = false;
                            ChaseVictim();
                        }
                        else
                        {
                            me->CastSpell(me->GetVictim(), SPELL_EARTH_BOLT, false);
                            events.ScheduleEvent(EVENT_EARTH_BOLT, 3500);
                        }
                    }
                    break;
                case EVENT_CHECK_VICTIM_DISTANCE:
                    if (inCastingPosition && me->GetVictim())
                    {
                        if (!me->IsWithinCombatRange(me->GetVictim(), 45.0f))
                        {
                            inCastingPosition = false;
                            ChaseVictim();
                        }
                        else
                        {
                            events.ScheduleEvent(EVENT_CHECK_VICTIM_DISTANCE, 1000);
                        }
                    }
                    break;
                default:
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

        void ChaseVictim()
        {
            if (Unit* victim = me->GetVictim())
            {
                me->GetMotionMaster()->MoveChase(victim);
                isMoving = false;
                inCastingPosition = false;
                events.ScheduleEvent(EVENT_MOVE_TO_CASTING_POSITION, 15000);
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_tricktotem_hexxerAI(creature);
    }
};

class npc_rira_hackclaw : public CreatureScript
{
public:
    npc_rira_hackclaw() : CreatureScript("npc_rira_hackclaw") { }

    struct npc_rira_hackclawAI : public TrioSharedAI<npc_rira_hackclawAI>
    {
        npc_rira_hackclawAI(Creature* creature) : TrioSharedAI(creature) { }

        void JustEngagedWith(Unit* /*who*/) override
        {
            me->Yell("No! Shut them down!", LANG_UNIVERSAL);
            me->PlayDirectSound(RIRA_SOUND_AGGRO);
            events.ScheduleEvent(EVENT_CAST_CLEAVE, 4000);
            events.ScheduleEvent(EVENT_CAST_CHARGE, 7000);
            events.ScheduleEvent(EVENT_CAST_BLADESTORM, 16000);
        }

        Unit* SelectRandomPlayerOrNPCBot(float range)
        {
            std::list<Unit*> targets;
            Acore::AnyUnitInObjectRangeCheck check(me, range);
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
            Cell::VisitAllObjects(me, searcher, range);

            targets.remove_if([this](Unit* unit) -> bool {
                return !unit->IsAlive() || unit == me->GetVictim() || !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                });

            if (targets.empty())
                return nullptr;

            return Acore::Containers::SelectRandomContainerElement(targets);
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
                case EVENT_CAST_CLEAVE:
                    if (Unit* victim = me->GetVictim())
                    {
                        me->CastSpell(victim, SPELL_CLEAVE, true);
                    }
                    events.ScheduleEvent(EVENT_CAST_CLEAVE, 4000);
                    break;
                case EVENT_CAST_CHARGE:
                    if (Unit* target = SelectRandomPlayerOrNPCBot(100.0f))
                    {
                        me->CastSpell(target, SPELL_CHARGE, true);
                        me->AddAura(SPELL_REND, target);
                    }
                    events.ScheduleEvent(EVENT_CAST_CHARGE, 7000);
                    break;
                case EVENT_CAST_BLADESTORM:
                    me->CastSpell(me, SPELL_BLADESTORM, false);
                    events.ScheduleEvent(EVENT_CAST_BLADESTORM, 16000);
                    break;
                default:
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_rira_hackclawAI(creature);
    }
};

class npc_gashtooth : public CreatureScript
{
public:
    npc_gashtooth() : CreatureScript("npc_gashtooth") { }

    struct npc_gashtoothAI : public TrioSharedAI<npc_gashtoothAI>
    {
        npc_gashtoothAI(Creature* creature) : TrioSharedAI(creature) { }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.ScheduleEvent(EVENT_CAST_DECAYED_SENSES, 15000);
            events.ScheduleEvent(EVENT_CAST_GASH_FRENZY, 17000);
        }

        Unit* SelectRandomPlayerOrNPCBot(float range)
        {
            std::list<Unit*> targets;
            Acore::AnyUnitInObjectRangeCheck check(me, range);
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
            Cell::VisitAllObjects(me, searcher, range);

            targets.remove_if([this](Unit* unit) -> bool {
                return !unit->IsAlive() || !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                });

            if (targets.empty())
                return nullptr;

            return Acore::Containers::SelectRandomContainerElement(targets);
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
                case EVENT_CAST_DECAYED_SENSES:
                    if (Unit* target = SelectRandomPlayerOrNPCBot(100.0f))
                    {
                        me->CastSpell(target, SPELL_DECAYED_SENSES, false);
                    }
                    events.ScheduleEvent(EVENT_CAST_DECAYED_SENSES, 15000);
                    break;
                case EVENT_CAST_GASH_FRENZY:
                    if (Unit* victim = me->GetVictim())
                    {
                        me->CastSpell(victim, SPELL_GASH_FRENZY, false);
                        me->Yell("Butcher and slice!", LANG_UNIVERSAL);
                        me->PlayDirectSound(SOUND_GASH_FRENZY);
                    }
                    events.ScheduleEvent(EVENT_CAST_GASH_FRENZY, 17000);
                    break;
                default:
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_gashtoothAI(creature);
    }
};

class AreaTrigger_at_rira_warning : public AreaTriggerScript
{
public:
    AreaTrigger_at_rira_warning() : AreaTriggerScript("at_rira_warning"), eventTriggered(false) { }

    bool OnTrigger(Player* player, AreaTrigger const* /*trigger*/) override
    {
        if (!player->isDead() && !eventTriggered)
        {
            Creature* riraHackclaw = player->FindNearestCreature(900615, 125.0f, true);
            if (riraHackclaw && riraHackclaw->IsAlive())
            {
                riraHackclaw->PlayDirectSound(188116);
                riraHackclaw->Yell("Here! Come for us, meat thieves! We rip you apart!", LANG_UNIVERSAL);
                eventTriggered = true;
            }
        }
        return false;
    }

private:
    bool eventTriggered;
};

enum TindralSpells
{
    TINDRAL_SPELL_STARFALL = 900648,
    TINDRAL_SPELL_MASS_ENTANGLE = 20654,
    TINDRAL_SPELL_SUNFIRE = 900649,
    TINDRAL_SPELL_SUMMON_TREANTS = 887993  
};

enum TindralSounds
{
    TINDRAL_SOUND_STARFALL = 188060,
    TINDRAL_SOUND_MASS_ENTANGLE = 188070,
    TINDRAL_SOUND_SUNFIRE = 188061,
    TINDRAL_SOUND_SPAWN_CREATURES = 188069,
    TINDRAL_SOUND_ENTER_COMBAT = 188072,
    TINDRAL_SOUND_LEAVE_COMBAT = 188065,
    TINDRAL_SOUND_DEATH = 188064
};

enum TindralNPCs
{
    TINDRAL_NPC_TREANT = 900649,
    TINDRAL_AREA_TRIGGER_NPC_ID = 900614
};

enum TindralEvents
{
    TINDRAL_EVENT_STARFALL = 1,
    TINDRAL_EVENT_MASS_ENTANGLE,
    TINDRAL_EVENT_SUNFIRE,
    TINDRAL_EVENT_SPAWN_CREATURES
};

class npc_tindral : public CreatureScript
{
public:
    npc_tindral() : CreatureScript("npc_tindral") { }

    struct npc_tindralAI : public ScriptedAI
    {
        npc_tindralAI(Creature* creature) : ScriptedAI(creature), spawnIndex(0) { }

        void Reset() override
        {
            events.Reset();
            me->PlayDirectSound(TINDRAL_SOUND_LEAVE_COMBAT);
            DespawnCreatures();

            me->Yell("A futile attempt!", LANG_UNIVERSAL);
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            me->Yell("The wind answers to me!", LANG_UNIVERSAL);
            me->PlayDirectSound(TINDRAL_SOUND_ENTER_COMBAT);

            events.ScheduleEvent(TINDRAL_EVENT_STARFALL, 22000);
            events.ScheduleEvent(TINDRAL_EVENT_MASS_ENTANGLE, 18000);
            events.ScheduleEvent(TINDRAL_EVENT_SUNFIRE, 14000);
            events.ScheduleEvent(TINDRAL_EVENT_SPAWN_CREATURES, 50000);
        }

        void JustDied(Unit* /*killer*/) override
        {
            me->Yell("I...failed my..people...", LANG_UNIVERSAL);
            DespawnCreatures();
            DespawnAreaTrigger();
            DespawnAreaTriggerTwo(); //redundancy
            me->PlayDirectSound(TINDRAL_SOUND_DEATH);
            events.Reset();
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
                case TINDRAL_EVENT_STARFALL:
                    if (Unit* target = me->GetVictim())
                    {
                        me->CastSpell(target, TINDRAL_SPELL_STARFALL, true);
                        me->Yell("Astral BREAK!", LANG_UNIVERSAL);
                        me->PlayDirectSound(TINDRAL_SOUND_STARFALL);
                    }
                    events.ScheduleEvent(TINDRAL_EVENT_STARFALL, 22000);
                    break;
                case TINDRAL_EVENT_MASS_ENTANGLE:
                    if (Unit* target = me->GetVictim())
                    {
                        me->CastSpell(target, TINDRAL_SPELL_MASS_ENTANGLE, true);
                        me->Yell("Grasping Snarl!", LANG_UNIVERSAL);
                        me->PlayDirectSound(TINDRAL_SOUND_MASS_ENTANGLE);
                    }
                    events.ScheduleEvent(TINDRAL_EVENT_MASS_ENTANGLE, 18000);
                    break;
                case TINDRAL_EVENT_SUNFIRE:
                    if (Unit* target = me->GetVictim())
                    {
                        me->CastSpell(target, TINDRAL_SPELL_SUNFIRE, true);
                        me->Yell("Blazing sky!", LANG_UNIVERSAL);
                        me->PlayDirectSound(TINDRAL_SOUND_SUNFIRE);
                    }
                    events.ScheduleEvent(TINDRAL_EVENT_SUNFIRE, 14000);
                    break;
                case TINDRAL_EVENT_SPAWN_CREATURES:
                    me->CastSpell(me, TINDRAL_SPELL_SUMMON_TREANTS, true);  // Spell should summon the creatures
                    me->Yell("Their screams shall be music to your ears.", LANG_UNIVERSAL);
                    me->PlayDirectSound(TINDRAL_SOUND_SPAWN_CREATURES);
                    events.ScheduleEvent(TINDRAL_EVENT_SPAWN_CREATURES, 50000);
                    break;
                default:
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

        void DespawnCreatures()
        {
            std::list<Creature*> treants;
            me->GetCreatureListWithEntryInGrid(treants, TINDRAL_NPC_TREANT, 1000.0f);

            for (Creature* treant : treants)
            {
                treant->DespawnOrUnsummon();
            }
        }

        void DespawnAreaTrigger()
        {
            if (Creature* areaTriggerNpc = me->FindNearestCreature(TINDRAL_AREA_TRIGGER_NPC_ID, 1000.0f))
            {
                areaTriggerNpc->DespawnOrUnsummon();
            }
        }

        void DespawnAreaTriggerTwo()
        {
            if (Creature* areaTriggerNpc = me->FindNearestCreature(TINDRAL_AREA_TRIGGER_NPC_ID, 1000.0f))
            {
                areaTriggerNpc->DespawnOrUnsummon();
            }
        }

    private:
        uint8 spawnIndex;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_tindralAI(creature);
    }
};

class AreaTrigger_at_tindral_warning : public AreaTriggerScript
{
public:
    AreaTrigger_at_tindral_warning() : AreaTriggerScript("at_tindral_warning"), eventTriggered(false) { }

    bool OnTrigger(Player* player, AreaTrigger const* /*trigger*/) override
    {
        if (!player->isDead() && !eventTriggered)
        {
            Creature* rTindral = player->FindNearestCreature(900648, 125.0f, true);
            if (rTindral && rTindral->IsAlive())
            {
                rTindral->PlayDirectSound(188085);
                rTindral->Yell("Enough! Your Doom is Here!", LANG_UNIVERSAL);
                eventTriggered = true;
            }
        }
        return false;
    }

private:
    bool eventTriggered;
};

enum UrsaguardianSpells
{
    SPELL_WAR_STOMP = 31408,
    SPELL_MASS_ROOT = 20654
};

enum UrsaguardianSounds
{
    GUARDIAN_SOUND_WAR_STOMP = 188091,
    GUARDIAN_SOUND_MASS_ROOT = 188092,
    GUARDIAN_SOUND_DEATH = 188090
};

enum UrsaguardianYells
{
    GUARDIAN_YELL_ENTER_COMBAT = 0,
    GUARDIAN_YELL_MASS_ROOT = 1,
    GUARDIAN_YELL_DEATH = 2
};

enum UrsaguardianEvents
{
    GUARDIAN_EVENT_WAR_STOMP = 1,
    GUARDIAN_EVENT_MASS_ROOT
};

class npc_ursaguardian : public CreatureScript
{
public:
    npc_ursaguardian() : CreatureScript("npc_ursaguardian") { }

    struct npc_ursaguardianAI : public ScriptedAI
    {
        npc_ursaguardianAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override
        {
            events.Reset();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            DoZoneInCombat();

            me->Yell("Return to the earth!", LANG_UNIVERSAL);
            me->PlayDirectSound(GUARDIAN_SOUND_WAR_STOMP);

            events.ScheduleEvent(GUARDIAN_EVENT_WAR_STOMP, 0);
            events.ScheduleEvent(GUARDIAN_EVENT_WAR_STOMP, 13000);
            events.ScheduleEvent(GUARDIAN_EVENT_MASS_ROOT, 25000);
        }

        void JustDied(Unit* /*killer*/) override
        {
            me->Yell("Nooooo!", LANG_UNIVERSAL);
            me->PlayDirectSound(GUARDIAN_SOUND_DEATH);
            events.Reset();
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
                case GUARDIAN_EVENT_WAR_STOMP:
                    me->CastSpell(me->GetVictim(), SPELL_WAR_STOMP, true);
                    events.ScheduleEvent(GUARDIAN_EVENT_WAR_STOMP, 13000);
                    break;
                case GUARDIAN_EVENT_MASS_ROOT:
                    me->CastSpell(me, SPELL_MASS_ROOT, true);
                    me->Yell("Feed my roots!", LANG_UNIVERSAL);
                    me->PlayDirectSound(GUARDIAN_SOUND_MASS_ROOT);
                    events.ScheduleEvent(GUARDIAN_EVENT_MASS_ROOT, 25000);
                    break;
                default:
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_ursaguardianAI(creature);
    }
};

enum GolaSpells
{
    GOLA_SPELL_REVITALIZE = 900616,
    GOLA_SPELL_TOXIC_BLOOM = 900610,
    GOLA_SPELL_TORRENTIAL_FURY = 900614,
    GOLA_SPELL_NOXIOUS_CHARGE = 900615,
    GOLA_SPELL_WATER_BOLT = 900606
};

enum GolaSounds
{
    GOLA_SOUND_REVITALIZE = 188088,
    GOLA_SOUND_WATER_BOLT = 188087,
    GOLA_SOUND_ENTER_COMBAT = 188087,
    GOLA_SOUND_LEAVE_COMBAT = 188086,
    GOLA_SOUND_DEATH = 188086
};

enum GolaYells
{
    GOLA_YELL_REVITALIZE = 0,
    GOLA_YELL_WATER_BOLT = 1,
    GOLA_YELL_ENTER_COMBAT = 2,
    GOLA_YELL_DEATH = 3
};

enum GolaEvents
{
    GOLA_EVENT_WATER_BOLT = 1,
    GOLA_EVENT_REVITALIZE,
    GOLA_EVENT_TOXIC_BLOOM,
    GOLA_EVENT_TORRENTIAL_FURY,
    GOLA_EVENT_NOXIOUS_CHARGE
};

class npc_gola : public CreatureScript
{
public:
    npc_gola() : CreatureScript("npc_gola") { }

    struct npc_golaAI : public ScriptedAI
    {
        npc_golaAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override
        {
            me->PlayDirectSound(GOLA_SOUND_LEAVE_COMBAT);
            events.Reset();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            me->Yell("The forest closes in around you.", LANG_UNIVERSAL);
            me->PlayDirectSound(GOLA_SOUND_ENTER_COMBAT);

            events.ScheduleEvent(GOLA_EVENT_WATER_BOLT, 3500);
            events.ScheduleEvent(GOLA_EVENT_REVITALIZE, 20000);
            events.ScheduleEvent(GOLA_EVENT_TOXIC_BLOOM, 17000);
            events.ScheduleEvent(GOLA_EVENT_TORRENTIAL_FURY, 26000);
            events.ScheduleEvent(GOLA_EVENT_NOXIOUS_CHARGE, 15000);
        }

        void JustDied(Unit* /*killer*/) override
        {
            me->Yell("I return... to the soil...", LANG_UNIVERSAL);
            me->PlayDirectSound(GOLA_SOUND_DEATH);
            events.Reset();
        }

        Unit* SelectRandomPlayerOrNPCBot(float range)
        {
            std::list<Unit*> targets;
            Acore::AnyUnitInObjectRangeCheck check(me, range);
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
            Cell::VisitAllObjects(me, searcher, range);

            targets.remove_if([this](Unit* unit) -> bool {
                return !unit->IsAlive() || !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                });

            if (targets.empty())
                return nullptr;

            return Acore::Containers::SelectRandomContainerElement(targets);
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
                switch (eventId)
                {
                case GOLA_EVENT_WATER_BOLT:
                    if (Unit* target = me->GetVictim())
                    {
                        me->CastSpell(target, GOLA_SPELL_WATER_BOLT, false);
                    }
                    events.ScheduleEvent(GOLA_EVENT_WATER_BOLT, 3500);
                    break;
                case GOLA_EVENT_REVITALIZE:
                    me->CastSpell(me, GOLA_SPELL_REVITALIZE, false);
                    me->Yell("Water brings life!", LANG_UNIVERSAL);
                    me->PlayDirectSound(GOLA_SOUND_REVITALIZE);
                    events.ScheduleEvent(GOLA_EVENT_REVITALIZE, 20000);
                    break;
                case GOLA_EVENT_TOXIC_BLOOM:
                    if (Unit* target = SelectRandomPlayerOrNPCBot(30.0f))
                    {
                        me->CastSpell(target, GOLA_SPELL_TOXIC_BLOOM, false);
                    }
                    events.ScheduleEvent(GOLA_EVENT_TOXIC_BLOOM, 17000);
                    break;
                case GOLA_EVENT_TORRENTIAL_FURY:
                    if (Unit* target = SelectRandomPlayerOrNPCBot(50.0f))
                    {
                        me->CastSpell(target, GOLA_SPELL_TORRENTIAL_FURY, false);
                    }
                    events.ScheduleEvent(GOLA_EVENT_TORRENTIAL_FURY, 26000);
                    break;
                case GOLA_EVENT_NOXIOUS_CHARGE:
                    if (Unit* target = SelectRandomPlayerOrNPCBot(60.0f))
                    {
                        me->CastSpell(target, GOLA_SPELL_NOXIOUS_CHARGE, true);
                    }
                    events.ScheduleEvent(GOLA_EVENT_NOXIOUS_CHARGE, 15000);
                    break;
                default:
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_golaAI(creature);
    }
};

enum SagewoodSpells
{
    SAGEWOOD_SPELL_UPROOTED_AGONY = 900643,
    SAGEWOOD_SPELL_RISING_MANIA = 900651,
    SAGEWOOD_SPELL_CLEAVE = 900652,
    SAGEWOOD_SPELL_SCORCHED_EARTH = 900653,
    SAGEWOOD_SPELL_TORTURED_SCREAM = 900654,
};

enum SagewoodSounds
{
    SAGEWOOD_SOUND_ENTER_COMBAT = 188097,
    SAGEWOOD_SOUND_SCORCHED_EARTH = 188095,
    SAGEWOOD_SOUND_TORTURED_SCREAM = 188110,
    SAGEWOOD_SOUND_UPROOTED_AGONY = 188107,
    SAGEWOOD_SOUND_RISING_MANIA = 188108,
    SAGEWOOD_SOUND_LEAVE_COMBAT = 188101,
    SAGEWOOD_SOUND_DEATH = 188098
};

enum SagewoodEvents
{
    SAGEWOOD_EVENT_CAST_CLEAVE = 1,
    SAGEWOOD_EVENT_CAST_SCORCHED_EARTH,
    SAGEWOOD_EVENT_CAST_TORTURED_SCREAM,
    SAGEWOOD_EVENT_CHECK_PHASE,
    SAGEWOOD_EVENT_CAST_SHADOWFLAME_BUFFET,
    SAGEWOOD_EVENT_CAST_RISING_MANIA
};

class npc_sagewood : public CreatureScript
{
public:
    npc_sagewood() : CreatureScript("npc_sagewood") { }

    struct npc_sagewoodAI : public ScriptedAI
    {
        npc_sagewoodAI(Creature* creature) : ScriptedAI(creature)
        {
            hasCastUprootedAgony.fill(false);
        }

        void Reset() override
        {
            events.Reset();
            hasCastUprootedAgony.fill(false);
            me->Yell("All life turns to dust!", LANG_UNIVERSAL);
            me->PlayDirectSound(SAGEWOOD_SOUND_LEAVE_COMBAT);
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            me->Yell("There is only darkness and pain!", LANG_UNIVERSAL);
            me->PlayDirectSound(SAGEWOOD_SOUND_ENTER_COMBAT);
            me->CastSpell(me->GetVictim(), SAGEWOOD_SPELL_TORTURED_SCREAM, true);

            events.ScheduleEvent(SAGEWOOD_EVENT_CAST_CLEAVE, 5000);
            events.ScheduleEvent(SAGEWOOD_EVENT_CAST_SCORCHED_EARTH, 10000);
            events.ScheduleEvent(SAGEWOOD_EVENT_CAST_TORTURED_SCREAM, 13000);
            events.ScheduleEvent(SAGEWOOD_EVENT_CHECK_PHASE, 1000);
        }

        void JustDied(Unit* /*killer*/) override
        {
            me->Yell("Extinguished...", LANG_UNIVERSAL);
            me->PlayDirectSound(SAGEWOOD_SOUND_DEATH);
            events.Reset();
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            events.Update(diff);

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case SAGEWOOD_EVENT_CAST_CLEAVE:
                    me->CastSpell(me->GetVictim(), SAGEWOOD_SPELL_CLEAVE, true);
                    events.ScheduleEvent(SAGEWOOD_EVENT_CAST_CLEAVE, 5000);
                    break;

                case SAGEWOOD_EVENT_CAST_SCORCHED_EARTH:
                    if (Unit* target = SelectRandomPlayerOrNPCBot(40.0f))
                    {
                        me->CastSpell(target, SAGEWOOD_SPELL_SCORCHED_EARTH, true);
                        me->Yell("Char flesh!", LANG_UNIVERSAL);
                        me->PlayDirectSound(SAGEWOOD_SOUND_SCORCHED_EARTH);
                    }
                    events.ScheduleEvent(SAGEWOOD_EVENT_CAST_SCORCHED_EARTH, 10000);
                    break;

                case SAGEWOOD_EVENT_CAST_TORTURED_SCREAM:
                    me->CastSpell(me->GetVictim(), SAGEWOOD_SPELL_TORTURED_SCREAM, true);
                    me->Yell("Shadow and flame take root!", LANG_UNIVERSAL);
                    me->PlayDirectSound(SAGEWOOD_SOUND_TORTURED_SCREAM);
                    events.ScheduleEvent(SAGEWOOD_EVENT_CAST_TORTURED_SCREAM, 13000);
                    break;

                case SAGEWOOD_EVENT_CHECK_PHASE:
                    CheckUprootedAgonyPhase();
                    events.ScheduleEvent(SAGEWOOD_EVENT_CHECK_PHASE, 1000);
                    break;

                default:
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

        void CheckUprootedAgonyPhase()
        {
            static constexpr std::array<uint8, 2> uprootedAgonyThresholds = { 80, 40 };
            uint8 healthPct = me->GetHealthPct();

            for (size_t i = 0; i < uprootedAgonyThresholds.size(); ++i)
            {
                if (healthPct <= uprootedAgonyThresholds[i] && !hasCastUprootedAgony[i])
                {
                    StartUprootedAgonyPhase(i);
                    break;
                }
            }
        }

        void StartUprootedAgonyPhase(size_t thresholdIndex)
        {
            hasCastUprootedAgony[thresholdIndex] = true;

            me->Yell("My roots scorch the earth!", LANG_UNIVERSAL);
            me->PlayDirectSound(SAGEWOOD_SOUND_UPROOTED_AGONY);
            me->CastSpell(me, SAGEWOOD_SPELL_UPROOTED_AGONY, false);

            events.ScheduleEvent(SAGEWOOD_EVENT_CAST_RISING_MANIA, 20000);
        }

        Unit* SelectRandomPlayerOrNPCBot(float range)
        {
            std::list<Unit*> targets;
            Acore::AnyUnitInObjectRangeCheck check(me, range);
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
            Cell::VisitAllObjects(me, searcher, range);

            targets.remove_if([this](Unit* unit) -> bool {
                return !unit->IsAlive() || !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                });

            if (targets.empty())
                return nullptr;

            return Acore::Containers::SelectRandomContainerElement(targets);
        }

    private:
        std::array<bool, 2> hasCastUprootedAgony;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_sagewoodAI(creature);
    }
};

enum BossPipSpells
{
    BOSSPIP_SPELL_FAERIE_FIRE = 16857,
    BOSSPIP_SPELL_SLEEP = 900637,
    BOSSPIP_SPELL_SPARKLE_SPIT = 900635,
    BOSSPIP_SPELL_NATURE_BOMB = 900638,
    BOSSPIP_SPELL_ENRAGE = 47008,
    BOSSPIP_SPELL_HEAL_ABSORB = 900644,
    BOSSPIP_SPELL_WIPE = 900636
};

enum BossPipEvents
{
    BOSSPIP_EVENT_CAST_SLEEP = 1,
    BOSSPIP_EVENT_CAST_SPARKLE_SPIT,
    BOSSPIP_EVENT_CAST_NATURE_BOMB,
    BOSSPIP_EVENT_CAST_ENRAGE,
    BOSSPIP_EVENT_CHECK_HEALTH,
    BOSSPIP_EVENT_CAST_HEAL_ABSORB,
    BOSSPIP_EVENT_CAST_WIPE,
    BOSSPIP_EVENT_CHECK_DISTANCE
};

class npc_boss_pip : public CreatureScript
{
public:
    npc_boss_pip() : CreatureScript("npc_boss_pip") { }

    struct npc_boss_pipAI : public ScriptedAI
    {
        npc_boss_pipAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override
        {
            events.Reset();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            me->CastSpell(me->GetVictim(), BOSSPIP_SPELL_FAERIE_FIRE, false);
            events.ScheduleEvent(BOSSPIP_EVENT_CAST_SLEEP, 15000);
            events.ScheduleEvent(BOSSPIP_EVENT_CAST_SPARKLE_SPIT, 20000);
            events.ScheduleEvent(BOSSPIP_EVENT_CAST_NATURE_BOMB, 30000);
            events.ScheduleEvent(BOSSPIP_EVENT_CAST_ENRAGE, 240000);
            events.ScheduleEvent(BOSSPIP_EVENT_CHECK_HEALTH, 1000);
            events.ScheduleEvent(BOSSPIP_EVENT_CHECK_DISTANCE, 1000);
        }

        void JustDied(Unit* /*killer*/) override
        {
            me->RemoveAllAuras();
            events.Reset();

            if (Creature* nearbyNPC = me->FindNearestCreature(900620, 500.0f))
            {
                nearbyNPC->DespawnOrUnsummon();
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
                switch (eventId)
                {
                case BOSSPIP_EVENT_CAST_SLEEP:
                    if (Unit* target = SelectRandomPlayerOrNPCBot(40.0f))
                    {
                        me->CastSpell(target, BOSSPIP_SPELL_SLEEP, true);
                    }
                    events.ScheduleEvent(BOSSPIP_EVENT_CAST_SLEEP, 15000);
                    break;
                case BOSSPIP_EVENT_CAST_SPARKLE_SPIT:
                    me->CastSpell(me->GetVictim(), BOSSPIP_SPELL_SPARKLE_SPIT, true);
                    events.ScheduleEvent(BOSSPIP_EVENT_CAST_SPARKLE_SPIT, 20000);
                    break;
                case BOSSPIP_EVENT_CAST_NATURE_BOMB:
                    me->CastSpell(me->GetVictim(), BOSSPIP_SPELL_NATURE_BOMB, false);
                    events.ScheduleEvent(BOSSPIP_EVENT_CAST_NATURE_BOMB, 30000);
                    break;
                case BOSSPIP_EVENT_CAST_ENRAGE:
                    me->CastSpell(me, BOSSPIP_SPELL_ENRAGE, true);
                    break;
                case BOSSPIP_EVENT_CHECK_HEALTH:
                    if (me->GetHealthPct() <= 50)
                    {
                        StartPhase2();
                    }
                    else
                    {
                        events.ScheduleEvent(BOSSPIP_EVENT_CHECK_HEALTH, 1000);
                    }
                    break;
                case BOSSPIP_EVENT_CHECK_DISTANCE:
                    CheckDistance();
                    events.ScheduleEvent(BOSSPIP_EVENT_CHECK_DISTANCE, 1000);
                    break;
                default:
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

        void StartPhase2()
        {
            events.Reset();  // Clear current events
            me->CastSpell(me, BOSSPIP_SPELL_HEAL_ABSORB, true);
            me->CastSpell(me, BOSSPIP_SPELL_WIPE, false);
            events.ScheduleEvent(BOSSPIP_EVENT_CAST_SLEEP, 15000);
            events.ScheduleEvent(BOSSPIP_EVENT_CAST_SPARKLE_SPIT, 20000);
            events.ScheduleEvent(BOSSPIP_EVENT_CAST_NATURE_BOMB, 30000);
            events.ScheduleEvent(BOSSPIP_EVENT_CAST_ENRAGE, 120000);
            events.ScheduleEvent(BOSSPIP_EVENT_CHECK_DISTANCE, 1000);
        }

        void CheckDistance()
        {
            if (me->GetDistance(me->GetHomePosition()) > 62.0f)
            {
                EnterEvadeMode();  // Reset the boss if it goes too far from its home position
            }
        }

        Unit* SelectRandomPlayerOrNPCBot(float range)
        {
            std::list<Unit*> targets;
            Acore::AnyUnitInObjectRangeCheck check(me, range);
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
            Cell::VisitAllObjects(me, searcher, range);

            targets.remove_if([this](Unit* unit) -> bool {
                return !unit->IsAlive() || !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                });

            if (targets.empty())
                return nullptr;

            return Acore::Containers::SelectRandomContainerElement(targets);
        }

    private:
        EventMap events;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_boss_pipAI(creature);
    }
};

void AddSC_ursa_lair_screature()
{
    new npc_tricktotem_hexxer();
    new npc_rira_hackclaw();
    new npc_gashtooth();
    new AreaTrigger_at_rira_warning();
    new npc_tindral();
    new AreaTrigger_at_tindral_warning();
    new npc_ursaguardian();
    new npc_gola();
    new npc_sagewood();
    new npc_boss_pip();
}
