#include "ScriptMgr.h"
#include "Player.h"
#include "ScriptedGossip.h"
#include <vector>
#include <random>
#include <algorithm>
#include <string>


enum GossipOptions
{
    GOSSIP_OPTION_CUSTOMIZE = 1,
    GOSSIP_OPTION_CHANGE_RACE = 4,
    GOSSIP_OPTION_CHANGE_FACTION = 7,
    GOSSIP_OPTION_CONFIRM_CUSTOMIZE = 2,
    GOSSIP_OPTION_CANCEL_CUSTOMIZE = 3,
    GOSSIP_OPTION_CONFIRM_CHANGE_RACE = 5,
    GOSSIP_OPTION_CANCEL_CHANGE_RACE = 6,
    GOSSIP_OPTION_CONFIRM_CHANGE_FACTION = 8,
    GOSSIP_OPTION_CANCEL_CHANGE_FACTION = 9
};

class npc_character_customizer : public CreatureScript
{
public:
    npc_character_customizer() : CreatureScript("npc_character_customizer") { }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        player->PlayerTalkClass->ClearMenus();
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Customize character", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_CUSTOMIZE);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Change race", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_CHANGE_RACE);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Change faction", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_CHANGE_FACTION);
        SendGossipMenuFor(player, 1, creature->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        player->PlayerTalkClass->ClearMenus();

        switch (action)
        {
        case GOSSIP_OPTION_CUSTOMIZE:
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Yes, customize my character", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_CONFIRM_CUSTOMIZE);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "No, cancel", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_CANCEL_CUSTOMIZE);
            SendGossipMenuFor(player, 1, creature->GetGUID());
            break;
        case GOSSIP_OPTION_CONFIRM_CUSTOMIZE:
            ChatHandler(player->GetSession()).SendNotification("Customization option selected. Please log out and back in.");
            player->SetAtLoginFlag(AT_LOGIN_CUSTOMIZE);
            CloseGossipMenuFor(player);
            break;
        case GOSSIP_OPTION_CANCEL_CUSTOMIZE:
            ChatHandler(player->GetSession()).SendNotification("Customization cancelled.");
            CloseGossipMenuFor(player);
            break;
        case GOSSIP_OPTION_CHANGE_RACE:
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Yes, change my race", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_CONFIRM_CHANGE_RACE);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "No, cancel", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_CANCEL_CHANGE_RACE);
            SendGossipMenuFor(player, 1, creature->GetGUID());
            break;
        case GOSSIP_OPTION_CONFIRM_CHANGE_RACE:
            ChatHandler(player->GetSession()).SendNotification("Changing race option selected. Please log out and back in.");
            player->SetAtLoginFlag(AT_LOGIN_CHANGE_RACE);
            CloseGossipMenuFor(player);
            break;
        case GOSSIP_OPTION_CANCEL_CHANGE_RACE:
            ChatHandler(player->GetSession()).SendNotification("Race change cancelled.");
            CloseGossipMenuFor(player);
            break;
        case GOSSIP_OPTION_CHANGE_FACTION:
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Yes, change my faction", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_CONFIRM_CHANGE_FACTION);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "No, cancel", GOSSIP_SENDER_MAIN, GOSSIP_OPTION_CANCEL_CHANGE_FACTION);
            SendGossipMenuFor(player, 1, creature->GetGUID());
            break;
        case GOSSIP_OPTION_CONFIRM_CHANGE_FACTION:
            ChatHandler(player->GetSession()).SendNotification("Changing faction option selected. Please log out and back in.");
            player->SetAtLoginFlag(AT_LOGIN_CHANGE_FACTION);
            CloseGossipMenuFor(player);
            break;
        case GOSSIP_OPTION_CANCEL_CHANGE_FACTION:
            ChatHandler(player->GetSession()).SendNotification("Faction change cancelled.");
            CloseGossipMenuFor(player);
            break;
        }
        return true;
    }
};

enum BuffNpcConstants
{
    ENABLE_BUFF_NPC = 1,
    Buffer_NPCID = 400117,
    BUFF_CURE_RES = 1,
    AURA_RESURRECTION_SICKNESS = 15007,
};

const std::vector<uint32> PASSIVITY_AREA_LIST = { 976, 541, 3425, 1446, 69, 42, 35, 2268, 152, 108, 1099, 392, 99, 117, 608, 2255 };
const std::vector<uint32> PASSIVITY_ZONE_LIST = { 1519, 1637 };

std::vector<std::string> whispers = {
    "With this boost, cut them loose, show them all your inner moose, %s!",
    "You'll shine bright, like a light, let your power take its flight, %s!",
    "A buff for you, strong and true, in your quest, they'll see you through, %s!",
    "These buffs I share, for those who dare, to face the world without despair, %s!",
    "Go with grace, win the race, let these buffs keep up your pace, %s!",
    "Fare thee well, give 'em hell, let your victories ring like a bell, %s!",
    "Forge ahead, show your stead, with these buffs, you'll be well-fed, %s!",
    "Stride with pride, side by side, let these buffs be your guide, %s!",
    "Off you go, steal the show, these buffs will help your power grow, %s!",
    "Now's your chance, take a stance, with these buffs, you'll enhance, %s!",
    "Buffed and ready, keep it steady, face the world with blade unsteady, %s!",
    "On your way, don't delay, let these buffs keep foes at bay, %s!",
    "Stay brave, ride the wave, with these buffs, you're sure to save, %s!",
    "Set to soar, ready for more, buffs that'll make your power roar, %s!"
};

std::vector<std::string> ShuffleWhispers(std::vector<std::string>& whispers)
{
    std::random_device rd;
    std::mt19937 g(rd());
    std::shuffle(whispers.begin(), whispers.end(), g);
    return whispers;
}

std::vector<std::string> shuffledWhispers = ShuffleWhispers(whispers);
uint32_t whisperIndex = 0;

std::string PickWhisper(const std::string& name)
{
    std::string whisper = shuffledWhispers[whisperIndex];
    whisperIndex = (whisperIndex + 1) % shuffledWhispers.size();
    size_t pos = whisper.find("%s");
    if (pos != std::string::npos)
    {
        whisper.replace(pos, 2, name);
    }
    return whisper;
}

bool Contains(const std::vector<uint32>& vec, uint32 element)
{
    return std::find(vec.begin(), vec.end(), element) != vec.end();
}

class npc_buffer : public CreatureScript
{
public:
    npc_buffer() : CreatureScript("npc_buffer") { }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        if (ENABLE_BUFF_NPC)
        {
            player->PlayerTalkClass->ClearMenus();
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "|TInterface\\icons\\spell_misc_emotionhappy:43:43:-33|t|cff007d45Buff me!|r", GOSSIP_SENDER_MAIN, 1);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "|TInterface\\icons\\pandarenracial_innerpeace:43:43:-33|t|cff007d45Grant Passivity|r", GOSSIP_SENDER_MAIN, 2);
            SendGossipMenuFor(player, 1, creature->GetGUID());
        }
        else
        {
            ChatHandler(player->GetSession()).SendNotification("You must Enable BufferNPC in lua_scripts to speak with this NPC.");
        }
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        player->PlayerTalkClass->ClearMenus();

        if (player->IsInCombat())
        {
            ChatHandler(player->GetSession()).SendNotification("You cannot use this feature while in combat.");
            CloseGossipMenuFor(player);
            return true;
        }

        std::string playerName = player->GetName();
        uint32 playerLevel = player->GetLevel();

        switch (action)
        {
        case 1:
            player->RemoveAura(80094);
            {
                std::map<uint32, std::vector<uint32>> spellTable = {
                    { 1, {1243, 1126, 25898, 1459} },
                    { 10, {1244, 5232, 25898, 1460} },
                    { 20, {1245, 6756, 25898, 1461} },
                    { 30, {2791, 5234, 25898, 1461, 14752, 976} },
                    { 40, {10937, 8907, 25898, 10156, 14818, 10957} },
                    { 50, {10937, 9884, 25898, 10157, 14819, 16874} },
                    { 60, {10938, 9885, 25898, 10157, 27841, 16874} },
                    { 70, {25389, 26990, 25898, 27126, 25312, 25433} },
                    { 80, {48161, 48469, 25898, 42995, 48073, 48169} }
                };

                for (const auto& [level, spells] : spellTable)
                {
                    if (playerLevel >= level)
                    {
                        for (const auto& spell : spells)
                        {
                            creature->CastSpell(player, spell, true);
                        }
                    }
                }
                if (BUFF_CURE_RES)
                {
                    player->RemoveAura(AURA_RESURRECTION_SICKNESS);
                }
            }
            break;

        case 2:
        {
            uint32 playerArea = player->GetAreaId();
            uint32 playerZone = player->GetZoneId();

            if (Contains(PASSIVITY_AREA_LIST, playerArea) || Contains(PASSIVITY_ZONE_LIST, playerZone))
            {
                player->CastSpell(player, 80094, true);
            }
            else
            {
                ChatHandler(player->GetSession()).SendNotification("You must be in a designated safe area to receive Passivity.");
            }
        }
        break;
        }

        creature->Say(PickWhisper(playerName), LANG_UNIVERSAL, player);
        creature->HandleEmoteCommand(EMOTE_ONESHOT_CHEER);
        CloseGossipMenuFor(player);
        return true;
    }
};

class npc_weapon_master : public CreatureScript
{
public:
    npc_weapon_master() : CreatureScript("npc_weapon_master") { }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Warrior", GOSSIP_SENDER_MAIN, CLASS_WARRIOR);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Paladin", GOSSIP_SENDER_MAIN, CLASS_PALADIN);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Hunter", GOSSIP_SENDER_MAIN, CLASS_HUNTER);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Rogue", GOSSIP_SENDER_MAIN, CLASS_ROGUE);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Priest", GOSSIP_SENDER_MAIN, CLASS_PRIEST);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Shaman", GOSSIP_SENDER_MAIN, CLASS_SHAMAN);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Mage", GOSSIP_SENDER_MAIN, CLASS_MAGE);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Warlock", GOSSIP_SENDER_MAIN, CLASS_WARLOCK);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Druid", GOSSIP_SENDER_MAIN, CLASS_DRUID);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Death Knight", GOSSIP_SENDER_MAIN, CLASS_DEATH_KNIGHT);
        player->PlayerTalkClass->SendGossipMenu(1, creature->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        if (player->GetClass() == action)
        {
            LearnWeaponSkills(player, creature, action);
            CloseGossipMenuFor(player);
        }
        else
        {
            creature->Say("Wrong Class, fool!", LANG_UNIVERSAL, player);
            CloseGossipMenuFor(player);
        }
        return true;
    }

    void LearnWeaponSkills(Player* player, Creature* creature, uint32 classId)
    {
        std::map<uint32, std::vector<uint32>> skillsMap = {
            {CLASS_WARRIOR, {202, 199, 197, 227, 200, 201, 198, 196, 266, 15590, 1180, 5011, 264}},
            {CLASS_PALADIN, {202, 199, 197, 200, 201, 198, 196}},
            {CLASS_HUNTER, {202, 197, 227, 200, 201, 196, 266, 15590, 1180, 5011, 264}},
            {CLASS_ROGUE, {201, 198, 196, 266, 15590, 1180, 5011, 264}},
            {CLASS_PRIEST, {227, 198, 1180}},
            {CLASS_SHAMAN, {199, 197, 227, 198, 196, 15590, 1180}},
            {CLASS_MAGE, {227, 201, 1180}},
            {CLASS_WARLOCK, {227, 201, 1180}},
            {CLASS_DRUID, {199, 227, 200, 198, 15590, 1180}},
            {CLASS_DEATH_KNIGHT, {202, 199, 197, 200, 201, 198, 196}}
        };

        auto it = skillsMap.find(classId);
        if (it != skillsMap.end())
        {
            for (auto skill : it->second)
            {
                if (!player->HasSpell(skill))
                {
                    player->learnSpell(skill, false);
                }
            }
            creature->Say("You've learned all your weapon skills! Now go out there and show 'em what you got!", LANG_UNIVERSAL, player);
        }
    }
};

std::map<uint32, std::vector<std::tuple<std::string, uint32, bool>>> enchantments = {
    {0, {
        {"Arcanum of Burning Mysteries", 3820, false},
        {"Arcanum of Blissful Mending", 3819, false},
        {"Arcanum of the Stalward Protector", 3818, false},
        {"Arcanum of Torment", 3817, false},
        {"Arcanum of the Savage Gladiator", 3842, false},
        {"Arcanum of Triumph", 3795, false},
        {"Arcanum of Dominance", 3797, false}
    }},
    {2, {
        {"Inscription of Triumph", 3793, false},
        {"Inscription of Dominance", 3794, false},
        {"Greater Inscription of the Gladiator", 3852, false},
        {"Greater Inscription of the Axe", 3808, false},
        {"Greater Inscription of the Crag", 3809, false},
        {"Greater Inscription of the Pinnacle", 3811, false},
        {"Greater Inscription of the Storm", 3810, false},
        {"Might of the Scourge", 2717, false},
        {"Power of the Scourge", 2721, false},
        {"Zandalar Signet of Might", 2606, false}
    }},
    {4, {
        {"Enchant Chest - Powerful Stats", 3832, false},
        {"Enchant Chest - Super Health", 3297, false},
        {"Enchant Chest - Greater Mana Restoration", 2381, false},
        {"Enchant Chest - Exceptional Resilience", 3245, false},
        {"Enchant Chest - Greater Defense", 1953, false}
    }},
    {6, {
        {"Earthen Leg Armor", 3853, false},
        {"Frosthide Leg Armor", 3822, false},
        {"Icescale Leg Armor", 3823, false},
        {"Brilliant Spellthread", 3719, false},
        {"Sapphire Spellthread", 3721, false}
    }},
    {7, {
        {"Greater Assault", 1597, false},
        {"Tuskars Vitality", 3232, false},
        {"Superior Agility", 983, false},
        {"Greater Spirit", 1147, false},
        {"Greater Vitality", 3244, false},
        {"Icewalker", 3826, false},
        {"Greater Fortitude", 1075, false}
    }},
    {8, {
        {"Socket bracers test", 3717, false},
        {"Major Stamina", 3850, false},
        {"Superior Spellpower", 2332, false},
        {"Greater Assault", 3845, false},
        {"Major Spirit", 1147, false},
        {"Expertise", 3231, false},
        {"Greater Stats", 2661, false},
        {"Exceptional Intellect", 1119, false}
    }},
    {9, {
        {"Socket gloves", 3723, false},
        {"Riding Skill Increase", 930, false},
        {"Greater Blasting", 3249, false},
        {"Armsman", 3253, false},
        {"Crusher", 1603, false},
        {"Agility", 3222, false},
        {"Precision", 3234, false},
        {"Expertise", 3231, false},
        {"Exceptional Spellpower", 3246, false}
    }},
    {14, {
        {"Shadow Armor", 3256, false},
        {"Wisdom", 3296, false},
        {"Titan Weave", 1951, false},
        {"Greater Speed", 3831, false},
        {"Mighty Armor", 3294, false},
        {"Major Agility", 1099, false},
        {"Spell Piercing", 1262, false}
    }},
    {15, {
        {"Crusader", 1900, false},
        {"Titan Guard", 3851, false},
        {"Accuracy", 3788, false},
        {"Berserking", 3789, false},
        {"Black Magic", 3790, false},
        {"Mighty Spellpower", 3834, false},
        {"Superior Potency", 3833, false},
        {"Ice Breaker", 3239, false},
        {"Lifeward", 3241, false},
        {"Blood Draining", 3870, false},
        {"Blade Ward", 3869, false},
        {"Exceptional Agility", 1103, false},
        {"Exceptional Spirit", 3844, false},
        {"Executioner", 3225, false},
        {"Mongoose", 2673, false},
        {"Massacre", 3827, true},
        {"Scourgebane", 3247, true},
        {"Giant Slayer", 3251, true},
        {"Greater Spellpower", 3854, true}
    }},
    {16, {
        {"Titan Guard", 3851, false},
        {"Accuracy", 3788, false},
        {"Berserking", 3789, false},
        {"Black Magic", 3790, false},
        {"Mighty Spellpower", 3834, false},
        {"Superior Potency", 3833, false},
        {"Ice Breaker", 3239, false},
        {"Lifeward", 3241, false},
        {"Blood Draining", 3870, false},
        {"Blade Ward", 3869, false},
        {"Exceptional Agility", 1103, false},
        {"Exceptional Spirit", 3844, false},
        {"Executioner", 3225, false},
        {"Mongoose", 2673, false},
        {"Defense", 1952, true},
        {"Greater Intellect", 1128, true},
        {"Shield Block", 2655, true},
        {"Resilience", 3229, true},
        {"Major Stamina", 1071, true},
        {"Tough Shield", 2653, true}
    }},
    {17, {
        {"Diamond-cut Refractor Scope", 3843, false},
        {"Sun Scope", 3607, false},
        {"Heartseeker Scope", 3608, false}
    }}
};

std::vector<std::pair<std::string, uint32>> menuItems = {
    {"Headpiece", 0},
    {"Shoulders", 2},
    {"Chest", 4},
    {"Legs", 6},
    {"Boots", 7},
    {"Bracers", 8},
    {"Gloves", 9},
    {"Cloak", 14},
    {"Main-Hand Weapons", 15},
    {"Two-Handed Weapons", 151},
    {"Off-Hand Weapons", 16},
    {"Shields", 161},
    {"Ranged", 17}
};

std::map<std::string, uint32> pVar;

class npc_enchanter : public CreatureScript
{
public:
    npc_enchanter() : CreatureScript("npc_enchanter") { }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        pVar[player->GetName()] = 0;

        for (auto& item : menuItems)
        {
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, item.first, GOSSIP_SENDER_MAIN, item.second);
        }
        SendGossipMenuFor(player, 1, creature->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        player->PlayerTalkClass->ClearMenus();
        if (action < 500)
        {
            uint32 ID = action;
            bool isSpecial = false;
            if (action == 161 || action == 151)
            {
                ID = action / 10;
                isSpecial = true;
            }
            pVar[player->GetName()] = action;
            if (enchantments.find(ID) != enchantments.end())
            {
                for (auto& ench : enchantments[ID])
                {
                    if ((!isSpecial && !std::get<2>(ench)) || (isSpecial && std::get<2>(ench)))
                    {
                        AddGossipItemFor(player, GOSSIP_ICON_CHAT, std::get<0>(ench), GOSSIP_SENDER_MAIN, std::get<1>(ench));
                    }
                }
            }
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "[Back]", GOSSIP_SENDER_MAIN, 500);
            SendGossipMenuFor(player, 1, creature->GetGUID());
        }
        else if (action == 500)
        {
            OnGossipHello(player, creature);
        }
        else if (action >= 900)
        {
            uint32 ID = pVar[player->GetName()];
            if (ID == 161 || ID == 151)
            {
                ID = ID / 10;
            }
            for (auto& ench : enchantments[ID])
            {
                if (std::get<1>(ench) == action)
                {
                    Item* item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, ID);
                    if (item)
                    {
                        if (std::get<2>(ench))
                        {
                            uint32 WType = item->GetTemplate()->SubClass;
                            if (ID == 15 && (WType == 1 || WType == 5 || WType == 6 || WType == 8 || WType == 10))
                            {
                                item->ClearEnchantment(PERM_ENCHANTMENT_SLOT);
                                item->SetEnchantment(PERM_ENCHANTMENT_SLOT, action, 0, 0);
                            }
                            else if (ID == 16 && WType == 6)
                            {
                                item->ClearEnchantment(PERM_ENCHANTMENT_SLOT);
                                item->SetEnchantment(PERM_ENCHANTMENT_SLOT, action, 0, 0); 
                            }
                            else if (ID == 17 && (WType == 2 || WType == 3 || WType == 18))
                            {
                                item->ClearEnchantment(PERM_ENCHANTMENT_SLOT);
                                item->SetEnchantment(PERM_ENCHANTMENT_SLOT, action, 0, 0); 
                            }
                            else
                            {
                                player->GetSession()->SendAreaTriggerMessage("You do not have the correct type of item equipped!");
                            }
                        }
                        else
                        {
                            item->ClearEnchantment(PERM_ENCHANTMENT_SLOT);
                            item->SetEnchantment(PERM_ENCHANTMENT_SLOT, action, 0, 0); 
                            player->CastSpell(player, 36937, true);
                        }
                    }
                    else
                    {
                        player->GetSession()->SendAreaTriggerMessage("You have no item to enchant in the selected slot!");
                    }
                }
            }
            OnGossipSelect(player, creature, sender, pVar[player->GetName()]);
        }
        return true;
    }
};

enum ValkyrProtectorSpells
{
    SPELL_FLASH_HEAL = 10916,
    SPELL_SMITE = 10933
};

enum ValkyrProtectorEvents
{
    EVENT_CAST_FLASH_HEAL = 1,
    EVENT_CAST_SMITE
};

class npc_valkyr_protector : public CreatureScript
{
public:
    npc_valkyr_protector() : CreatureScript("npc_valkyr_protector") {}

    struct npc_valkyr_protectorAI : public ScriptedAI
    {
        npc_valkyr_protectorAI(Creature* creature) : ScriptedAI(creature) {}

        void Reset() override
        {
            events.Reset();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.ScheduleEvent(EVENT_CAST_FLASH_HEAL, 6000, 0);
            events.ScheduleEvent(EVENT_CAST_SMITE, 5000, 0);
        }

        void JustDied(Unit* /*killer*/) override
        {
            events.Reset();
        }

        void EnterEvadeMode(EvadeReason /*why*/) override
        {
            events.Reset();
            ScriptedAI::EnterEvadeMode();
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
                case EVENT_CAST_FLASH_HEAL:
                    CastFlashHealOnLowHealthUnit();
                    events.ScheduleEvent(EVENT_CAST_FLASH_HEAL, 6000);
                    break;
                case EVENT_CAST_SMITE:
                    CastSmiteOnVictim();
                    events.ScheduleEvent(EVENT_CAST_SMITE, 5000);
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

    private:
        void CastFlashHealOnLowHealthUnit()
        {
            Unit* lowHealthUnit = FindLowHealthUnit();
            if (lowHealthUnit)
            {
                me->CastSpell(lowHealthUnit, SPELL_FLASH_HEAL, false);
            }
        }

        void CastSmiteOnVictim()
        {
            Unit* victim = me->GetVictim();
            if (victim)
            {
                me->CastSpell(victim, SPELL_SMITE, false);
            }
        }

        Unit* FindLowHealthUnit()
        {
            UnitList friendlyUnits;
            Acore::AnyFriendlyUnitInObjectRangeCheck checker(me, me, 40.0f);
            Acore::UnitListSearcher<Acore::AnyFriendlyUnitInObjectRangeCheck> searcher(me, friendlyUnits, checker);
            Cell::VisitAllObjects(me, searcher, 40.0f);

            Unit* lowHealthUnit = nullptr;
            float minHealthPercent = 90.0f;

            for (Unit* unit : friendlyUnits)
            {
                if (unit->IsPlayer() || unit->IsNPCBot())
                {
                    float healthPercent = (unit->GetHealth() / float(unit->GetMaxHealth())) * 100.0f;
                    if (healthPercent < minHealthPercent)
                    {
                        minHealthPercent = healthPercent;
                        lowHealthUnit = unit;
                    }
                }
            }

            return lowHealthUnit;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_valkyr_protectorAI(creature);
    }
};

class npc_custom_shadow_tendril : public CreatureScript
{
public:
    npc_custom_shadow_tendril() : CreatureScript("npc_custom_shadow_tendril") {}

    struct npc_custom_shadow_tendrilAI : public ScriptedAI
    {
        npc_custom_shadow_tendrilAI(Creature* creature) : ScriptedAI(creature) {}

        enum Spells
        {
            SHADOW_WORD_PAIN = 10892,
            MIND_BLAST = 10945,
            SLOW = 30283
        };

        void Reset() override
        {
            events.Reset();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.ScheduleEvent(SHADOW_WORD_PAIN, 100);
            events.ScheduleEvent(MIND_BLAST, 5000);
            events.ScheduleEvent(SLOW, 100);
        }

        void JustDied(Unit* /*killer*/) override
        {
            events.Reset();
        }

        void EnterEvadeMode(EvadeReason /*why*/) override
        {
            events.Reset();
            ScriptedAI::EnterEvadeMode();
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
                case SHADOW_WORD_PAIN:
                    DoCastVictim(SHADOW_WORD_PAIN);
                    events.ScheduleEvent(SHADOW_WORD_PAIN, 10000);
                    break;
                case MIND_BLAST:
                    DoCastVictim(MIND_BLAST);
                    events.ScheduleEvent(MIND_BLAST, 5000);
                    break;
                case SLOW:
                    DoCastVictim(SLOW);
                    events.ScheduleEvent(SLOW, 10000);
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_custom_shadow_tendrilAI(creature);
    }
};

class npc_kloveriell_city : public CreatureScript
{
public:
    npc_kloveriell_city() : CreatureScript("npc_kloveriell_city") { }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        player->PlayerTalkClass->ClearMenus();
        player->PrepareQuestMenu(creature->GetGUID());
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Tell me about yourself, Kloveriell.", GOSSIP_SENDER_MAIN, 1);
        SendGossipMenuFor(player, 1, creature->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        player->PlayerTalkClass->ClearMenus();
        switch (action)
        {
        case 1:
            creature->Say("I am a Paladin, once a Knight of the Silver Hand. My path has been one of honor, justice, and protection. I've seen battles, held comrades as they drew their last breath, and fought for peace. Serving alongside High Priestess Aquila Empyrean, I now strive to guard and counsel High Elves and Void Elves alike.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "How did you come to serve High Priestess Aquila Empyrean?", GOSSIP_SENDER_MAIN, 2);
            break;
        case 2:
            creature->Say("The Priestess and I share a similar outlook on the sanctity of our people and the realm. When she took a stance against Kael'thas, my honor dictated that I stand by her. Our paths converged, and here I serve to safeguard our ideals and values.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "I've heard you are a formidable Paladin. What advice do you have for aspiring Paladins?", GOSSIP_SENDER_MAIN, 3);
            break;
        case 3:
            creature->Say("The path of a Paladin is not for the faint of heart. It is a path where your faith will be tested and your resolve must be unyielding. Always be guided by the virtues of honor, compassion, and justice. Let the Light guide you, but never forget that the strength of your character is your truest shield.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Can you tell me about your search for Tirion Fordring?", GOSSIP_SENDER_MAIN, 4);
            break;
        case 4:
            creature->Say("Ah, Tirion, a beacon of Light and my dearest friend. His disappearance has weighed heavy upon my soul. I ventured to the Eastern Plaguelands in search of him, and though I found no trace, the journey was not in vain. I would continue the search if the Priestess ever needs me not.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "What’s your role in the Silver Covenant?", GOSSIP_SENDER_MAIN, 5);
            break;
        case 5:
            creature->Say("I joined the Silver Covenant later in my years. My role there is much akin to my role here; a guardian and protector. The Silver Covenant stands for the preservation of High Elven culture and values, and I am honored to lend my sword and shield to their cause.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Thank you for your time, Kloveriell. May the Light guide you.", GOSSIP_SENDER_MAIN, 6);
            break;
        case 6:
            creature->Say("Thank you, traveler. May the Light guide your path and may your heart remain steadfast in the face of darkness. Should you or the Priestess ever need assistance, know that my blade is at the ready.", LANG_UNIVERSAL, player);
            player->CastSpell(player, 25898, true);  // Greater Blessing of Kings
            CloseGossipMenuFor(player);
            break;
        }
        if (action != 6)
        {
            SendGossipMenuFor(player, 1, creature->GetGUID());
        }
        return true;
    }
};

class npc_elathalis_city : public CreatureScript
{
public:
    npc_elathalis_city() : CreatureScript("npc_elathalis_city") { }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        player->PlayerTalkClass->ClearMenus();
        player->PrepareQuestMenu(creature->GetGUID());
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Who are you?", GOSSIP_SENDER_MAIN, 1);
        SendGossipMenuFor(player, 1, creature->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        player->PlayerTalkClass->ClearMenus();
        switch (action)
        {
        case 1:
            creature->Say("My name is Elathalis Shadowcloud, a Void Elf priest, and a proud member of the Order of the Empyrean Void. I was once a student in Quel'Thalas, but after the fall of Silvermoon, I sought refuge in the Void.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "What is the Order of the Empyrean Void?", GOSSIP_SENDER_MAIN, 2);
            break;
        case 2:
            creature->Say("The Order of the Empyrean Void is an organization created by High Priestess Aquila Empyrean. Our mission is to preserve the High Elven culture and values, while also exploring the mysteries of the Void. We believe in maintaining balance between the Light and Shadow, and strive to protect Azeroth from any threat that emerges.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "How did you join the Order?", GOSSIP_SENDER_MAIN, 3);
            break;
        case 3:
            creature->Say("After being exiled from Quel'Thalas, I wandered Azeroth, seeking a new purpose. I came across the Exiled Enclave and met High Priestess Aquila Empyrean. Her wisdom and vision for unity between the Light and Shadow inspired me, and I decided to join the Order of the Empyrean Void to contribute my knowledge and skills to their cause.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "What are your thoughts on High Priestess Aquila Empyrean?", GOSSIP_SENDER_MAIN, 4);
            break;
        case 4:
            creature->Say("High Priestess Aquila Empyrean is a true visionary. She's not only a leader but also a mentor for many of us in the Order. Her dedication to preserving our culture and exploring the potential of the Void is truly admirable. I am honored to be part of her legacy and to fight alongside her in the battles that lie ahead.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Farewell.", GOSSIP_SENDER_MAIN, 5);
            break;
        case 5:
            creature->Say("Farewell, traveler. May the Void guide you on your journey.", LANG_UNIVERSAL, player);
            player->CastSpell(player, 1244, true);  
            CloseGossipMenuFor(player);
            break;
        }
        if (action != 5)
        {
            SendGossipMenuFor(player, 1, creature->GetGUID());
        }
        return true;
    }
};

class npc_highelf_pilgrim : public CreatureScript
{
public:
    npc_highelf_pilgrim() : CreatureScript("npc_highelf_pilgrim") { }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        player->PlayerTalkClass->ClearMenus();
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Tell me about yourself, Pilgrim.", GOSSIP_SENDER_MAIN, 1);
        SendGossipMenuFor(player, 1, creature->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        player->PlayerTalkClass->ClearMenus();

        switch (action)
        {
        case 1:
            creature->Say("I am a High Elf who once lived in the beautiful city of Quel'Thalas. I have seen both peace and turmoil in my time, and I am now seeking refuge in Stormwind after the tragic events that have befallen my people.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Why did you leave Quel'Thalas?", GOSSIP_SENDER_MAIN, 2);
            break;
        case 2:
            creature->Say("Our homeland was ravaged by conflict, and many of us were forced to flee. I chose to leave, seeking safety and a new beginning in Stormwind. I cherish the memories of my homeland, but I must now forge a new path.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "How has Stormwind been treating you?", GOSSIP_SENDER_MAIN, 3);
            break;
        case 3:
            creature->Say("Stormwind has been kind in welcoming me and others who sought refuge here. It is not without its challenges, but I have found solace in the presence of fellow High Elves, and I have been able to start anew.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "What are your thoughts on the Exiled Enclave?", GOSSIP_SENDER_MAIN, 4);
            break;
        case 4:
            creature->Say("The Exiled Enclave is a beacon of hope for us. It represents the unity and strength of our people in the face of adversity. I am grateful for the support Aquila provides and for the opportunity to be a part of this community.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "What do you miss most about your homeland?", GOSSIP_SENDER_MAIN, 5);
            break;
        case 5:
            creature->Say("I miss the beauty and serenity of Quel'Thalas, the vibrant forests, and the camaraderie of our people. But most of all, I miss the sense of belonging to a place where our history and culture thrived.", LANG_UNIVERSAL, player);
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Thank you for sharing your story. Stay strong.", GOSSIP_SENDER_MAIN, 6);
            break;
        case 6:
            creature->Say("Thank you for your kind words, traveler. It is heartening to see that there are still those who care. May our paths cross again in the future, and may fortune favor you on your journey.", LANG_UNIVERSAL, player);
            CloseGossipMenuFor(player);
            break;
        default:
            break;
        }

        if (action != 6)
        {
            SendGossipMenuFor(player, 1, creature->GetGUID());
        }

        return true;
    }
};

enum ValkGuardSpells
{
    SPELL_FLASH_OF_LIGHT = 19942,
    SPELL_HAMMER_OF_WRATH = 824275,
    SPELL_HOLY_NOVA = 27799,
    SPELL_AVENGING_WRATH = 31884
};

enum ValkGuardEvents
{
    EVENT_CAST_FO_LOW_HEALTH = 1,
    EVENT_CAST_HAMMER_VICTIM,
    EVENT_CAST_HOLY_NOVA
};

class npc_valk_guard : public CreatureScript
{
public:
    npc_valk_guard() : CreatureScript("npc_valk_guard") { }

    struct npc_valk_guardAI : public ScriptedAI
    {
        npc_valk_guardAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override
        {
            events.Reset();
        }

        void JustSummoned(Creature* summoned) override
        {
            if (Unit* owner = me->GetOwner())
            {
                owner->CastSpell(owner, 54428, true);
            }
        }

        void IsSummonedBy(WorldObject* summoner) override
        {
            if (Unit* unitSummoner = summoner->ToUnit())
            {
                unitSummoner->AddAura(54428, unitSummoner);
            }
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.ScheduleEvent(EVENT_CAST_FO_LOW_HEALTH, urand(3000, 7000));
            events.ScheduleEvent(EVENT_CAST_HAMMER_VICTIM, urand(6000, 8000));
            events.ScheduleEvent(EVENT_CAST_HOLY_NOVA, urand(4000, 9000));
        }

        void JustDied(Unit* /*killer*/) override
        {
            events.Reset();
        }

        void EnterEvadeMode(EvadeReason /*why*/) override
        {
            events.Reset();
            ScriptedAI::EnterEvadeMode();
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
                case EVENT_CAST_FO_LOW_HEALTH:
                    CastFlashOfLightOnLowHealthUnit();
                    events.ScheduleEvent(EVENT_CAST_FO_LOW_HEALTH, urand(3000, 7000));
                    break;
                case EVENT_CAST_HAMMER_VICTIM:
                    CastHammerOnVictim();
                    events.ScheduleEvent(EVENT_CAST_HAMMER_VICTIM, urand(4000, 7000));
                    break;
                case EVENT_CAST_HOLY_NOVA:
                    me->CastSpell(me, SPELL_HOLY_NOVA, true);
                    events.ScheduleEvent(EVENT_CAST_HOLY_NOVA, urand(4000, 9000));
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

    private:
        void CastFlashOfLightOnLowHealthUnit()
        {
            Unit* lowHealthUnit = FindLowHealthUnit();
            if (lowHealthUnit)
            {
                me->CastSpell(lowHealthUnit, SPELL_FLASH_OF_LIGHT, true);
            }
        }

        void CastHammerOnVictim()
        {
            Unit* victim = me->GetVictim();
            if (victim)
            {
                me->CastSpell(victim, SPELL_HAMMER_OF_WRATH, true);
            }
        }

        Unit* FindLowHealthUnit()
        {
            std::list<Unit*> friendlyUnits;
            Acore::AnyFriendlyUnitInObjectRangeCheck checker(me, me, 40.0f);
            Acore::UnitListSearcher<Acore::AnyFriendlyUnitInObjectRangeCheck> searcher(me, friendlyUnits, checker);
            Cell::VisitAllObjects(me, searcher, 40.0f);

            Unit* lowHealthUnit = nullptr;
            float minHealthPercent = 90.0f;

            for (Unit* unit : friendlyUnits)
            {
                if (unit->IsPlayer() || (unit->GetEntry() >= 70000 && unit->GetEntry() <= 81000))
                {
                    float healthPercent = (unit->GetHealth() / float(unit->GetMaxHealth())) * 100.0f;
                    if (healthPercent < minHealthPercent)
                    {
                        minHealthPercent = healthPercent;
                        lowHealthUnit = unit;
                    }
                }
            }

            return lowHealthUnit;
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_valk_guardAI(creature);
    }
};

class spell_remove_banish : public SpellScriptLoader
{
public:
    spell_remove_banish() : SpellScriptLoader("spell_remove_banish") { }

    class spell_remove_banish_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_remove_banish_SpellScript);

        SpellCastResult CheckCast()
        {
            if (Unit* caster = GetCaster())
            {
                if (Player* player = caster->ToPlayer())
                {
                    Map* map = player->GetMap();
                    if (!map || (!map->IsDungeon() && !map->IsRaid()))
                    {
                        player->GetSession()->SendAreaTriggerMessage("This ability can only be used in dungeons or raids.");
                        return SPELL_FAILED_INCORRECT_AREA;
                    }

                    if (Unit* target = player->GetSelectedUnit())
                    {
                        if (!target->HasAura(710) && !target->HasAura(18647))
                        {
                            player->GetSession()->SendAreaTriggerMessage("Target must have banish aura.");
                            return SPELL_FAILED_BAD_TARGETS;
                        }
                    }
                }
            }
            return SPELL_CAST_OK;
        }

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* target = GetHitUnit())
            {
                target->RemoveAurasDueToSpell(710);
                target->RemoveAurasDueToSpell(18647);
            }
        }

        void Register() override
        {
            OnCheckCast += SpellCheckCastFn(spell_remove_banish_SpellScript::CheckCast);
            OnEffectHitTarget += SpellEffectFn(spell_remove_banish_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_remove_banish_SpellScript();
    }
};

class spell_leave_combat : public SpellScriptLoader
{
public:
    spell_leave_combat() : SpellScriptLoader("spell_leave_combat") { }
    class spell_leave_combat_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_leave_combat_SpellScript);
        SpellCastResult CheckCast()
        {
            if (Unit* caster = GetCaster())
            {
                if (Player* player = caster->ToPlayer())
                {
                    // Check if player already has the cooldown aura
                    if (player->HasAura(88099))
                    {
                        player->GetSession()->SendAreaTriggerMessage("You cannot use this ability yet.");
                        return SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW;
                    }
                    // Check if in dungeon or raid
                    Map* map = player->GetMap();
                    if (!map || (!map->IsDungeon() && !map->IsRaid()))
                    {
                        player->GetSession()->SendAreaTriggerMessage("This ability can only be used in dungeons or raids.");
                        return SPELL_FAILED_INCORRECT_AREA;
                    }
                }
            }
            return SPELL_CAST_OK;
        }
        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {
                if (Player* player = caster->ToPlayer())
                {
                    // apply cooldown aura
                    player->CastSpell(player, 88099, true);
                }
            }
        }
        void Register() override
        {
            OnCheckCast += SpellCheckCastFn(spell_leave_combat_SpellScript::CheckCast);
            OnEffectHitTarget += SpellEffectFn(spell_leave_combat_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };
    SpellScript* GetSpellScript() const override
    {
        return new spell_leave_combat_SpellScript();
    }
};

void AddSC_npc_custom_generic()
{
    new npc_character_customizer();
    new npc_buffer();
    new npc_weapon_master();
    new npc_enchanter();
    new npc_valkyr_protector();
    new npc_custom_shadow_tendril();
    new npc_kloveriell_city();
    new npc_elathalis_city();
    new npc_highelf_pilgrim();
    new npc_valk_guard();
    new spell_remove_banish();
    new spell_leave_combat();
}
