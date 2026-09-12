#include "ScriptedCreature.h"
#include "ScriptMgr.h"

class npc_generic_fire_storm : public CreatureScript
{
public:
    npc_generic_fire_storm() : CreatureScript("npc_generic_fire_storm") {}

    struct npc_generic_fire_stormAI : public ScriptedAI
    {
        uint32 combatStopTimer;

        npc_generic_fire_stormAI(Creature* creature) : ScriptedAI(creature)
        {
            combatStopTimer = 3000; // 3 seconds
        }

        void Reset() override
        {
            me->SetReactState(REACT_PASSIVE);
            DoCast(me, 816148, true); 
        }

        void UpdateAI(uint32 diff) override
        {
            if (combatStopTimer <= diff)
            {
                me->CombatStop(); // Force the creature to leave combat
                combatStopTimer = 3000; // Reset timer for 3 seconds
            }
            else
            {
                combatStopTimer -= diff;
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_generic_fire_stormAI(creature);
    }
};

void AddSC_npc_generic_fire_storm()
{
    new npc_generic_fire_storm();
}
