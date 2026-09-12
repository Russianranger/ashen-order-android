#include "ScriptMgr.h"
#include "Creature.h"
#include "Player.h"

class npc_mount_warning : public CreatureScript
{
public:
    npc_mount_warning() : CreatureScript("npc_mount_warning") {}

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        if (!player)
            return false;
        creature->Whisper("These mounts are largely unimplemented and may contain some visual or sound errors.", LANG_UNIVERSAL, player);

        return true;
    }
};

void AddSC_npc_mount_warning()
{
    new npc_mount_warning();
}
