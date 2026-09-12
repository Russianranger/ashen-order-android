#include "ScriptMgr.h"
#include "Player.h"
#include "Creature.h"
#include "TaskScheduler.h"

class AreaTrigger_at_cathedral_of_light : public AreaTriggerScript
{
public:
    AreaTrigger_at_cathedral_of_light() : AreaTriggerScript("at_cathedral_of_light") { }

    bool OnTrigger(Player* player, AreaTrigger const* /*trigger*/) override
    {
        if (!player->isDead())
        {
            Creature* sarno = player->FindNearestCreature(7917, 25.0f);
            if (sarno)
            {
                uint64 playerGUID = player->GetGUID().GetRawValue();
                time_t currentTime = time(nullptr);

                // Check both global and individual cooldowns
                if (globalCooldown <= currentTime)
                {
                    auto it = cooldownMap.find(playerGUID);
                    if (it == cooldownMap.end() || it->second <= currentTime)
                    {
                        // Set facing to the player
                        sarno->SetFacingToObject(player);

                        // Schedule the wave and talk after 1 second
                        sarno->m_Events.AddEvent(new WaveAndTalkEvent(sarno, player), sarno->m_Events.CalculateTime(750));

                        // Schedule reset orientation after 4 seconds
                        sarno->m_Events.AddEvent(new ResetOrientationEvent(sarno), sarno->m_Events.CalculateTime(3300));

                        // Set individual cooldown
                        cooldownMap[playerGUID] = currentTime + 3600; // 60 minutes cooldown

                        // Set global cooldown
                        globalCooldown = currentTime + 60; // 1 minute cooldown
                    }
                }
            }
        }

        return false;
    }

    std::string GetClassName(uint8 classId)
    {
        switch (classId)
        {
        case CLASS_WARRIOR: return "Warrior";
        case CLASS_PALADIN: return "Paladin";
        case CLASS_HUNTER: return "Hunter";
        case CLASS_ROGUE: return "Rogue";
        case CLASS_PRIEST: return "Priest";
        case CLASS_DEATH_KNIGHT: return "Death Knight";
        case CLASS_SHAMAN: return "Shaman";
        case CLASS_MAGE: return "Mage";
        case CLASS_WARLOCK: return "Warlock";
        case CLASS_DRUID: return "Druid";
        default: return "Unknown";
        }
    }

private:
    std::unordered_map<uint64, time_t> cooldownMap;
    time_t globalCooldown = 0; 

    class WaveAndTalkEvent : public BasicEvent
    {
    public:
        WaveAndTalkEvent(Creature* creature, Player* player) : _creature(creature), _player(player) { }

        bool Execute(uint64 /*time*/, uint32 /*diff*/) override
        {
            if (_player && _creature)
            {
                _creature->HandleEmoteCommand(EMOTE_ONESHOT_WAVE);
                std::string className = GetClassName(_player->getClass());
                std::string msg = "Welcome to the Cathedral of Light, " + className + "!";
                _creature->Say(msg.c_str(), LANG_UNIVERSAL);
            }
            return true;
        }

    private:
        Creature* _creature;
        Player* _player;

        std::string GetClassName(uint8 classId)
        {
            switch (classId)
            {
            case CLASS_WARRIOR: return "Warrior";
            case CLASS_PALADIN: return "Paladin";
            case CLASS_HUNTER: return "Hunter";
            case CLASS_ROGUE: return "Rogue";
            case CLASS_PRIEST: return "Priest";
            case CLASS_DEATH_KNIGHT: return "Death Knight";
            case CLASS_SHAMAN: return "Shaman";
            case CLASS_MAGE: return "Mage";
            case CLASS_WARLOCK: return "Warlock";
            case CLASS_DRUID: return "Druid";
            default: return "Unknown";
            }
        }
    };

    class ResetOrientationEvent : public BasicEvent
    {
    public:
        explicit ResetOrientationEvent(Creature* creature) : _creature(creature) { }

        bool Execute(uint64 /*time*/, uint32 /*diff*/) override
        {
            _creature->SetFacingTo(_creature->GetHomePosition().GetOrientation());
            return true;
        }

    private:
        Creature* _creature;
    };
};

void AddSC_cathedral_of_light()
{
    new AreaTrigger_at_cathedral_of_light();
}
