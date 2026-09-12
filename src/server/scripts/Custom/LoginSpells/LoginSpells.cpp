#include "Player.h"
#include "ScriptMgr.h"
#include "Chat.h"
#include <algorithm>
#include <string>

struct RaceSkillInfo {
    uint16 skillID;
    uint16 skillValue;
    uint16 maxValue;
    uint8 requiredClass;  // 0 means no class requirement
};

static const std::unordered_map<uint8, std::vector<RaceSkillInfo>> Races = {
    {1, {
        {226, 1, 1, 3}  // Crossbows, only for Hunters
    }},
    {2, {
        {45, 1, 1, 3},  // Bows, only for Hunters
        {226, 1, 1, 3}  // Crossbows, only for Hunters
    }},
    {4, {
        {45, 1, 1, 3}  // Bows, only for Hunters
    }},
    {5, {
        {45, 1, 1, 3},  // Bows, only for Hunters
        {226, 1, 1, 3}  // Crossbows, only for Hunters
    }},
    {8, {
        {45, 1, 1, 3},  // Bows, only for Hunters
        {226, 1, 1, 3}  // Crossbows, only for Hunters
    }},
    {10, {
        {137, 1, 300, 0}  // Thalassian
    }},
    {12, {
        {137, 1, 300, 0}  // Thalassian
    }},
    {14, {
        {137, 1, 300, 0}  // Thalassian
    }},
    {17, {
        {139, 1, 300, 0}  // Demonic
    }},
    {20, {
        {139, 1, 300, 0}  // Demonic
    }},
    {21, {
        {137, 1, 300, 0},  // Thalassian
        {139, 1, 300, 0}   // Demonic
    }}
};

std::string caesarCipher(const std::string& input, int shift)
{
    std::string result = input;
    std::transform(result.begin(), result.end(), result.begin(),
        [shift](char c) -> char {
            if (isalpha(c) || isdigit(c))
            {
                char offset = isupper(c) ? 'A' : (islower(c) ? 'a' : '0');
                int modulo = isalpha(c) ? 26 : 10;
                return (c - offset + shift + modulo) % modulo + offset;
            }
            return c;
        });
    return result;
}

class LoginSpells : public PlayerScript
{
public:
    LoginSpells() : PlayerScript("LoginSpells") {}

    void OnLogin(Player* player) override
    {
        if (!player)
            return;

        CheckRaceSkills(player);
        SetRidingSkills(player);
        //player->m_Events.AddEvent(new XYZ123Event(player), player->m_Events.CalculateTime(10000));
    }

    //void OnLogout(Player* player) override
    //{
    //    if (!player)
    //        return;

    //    RemoveSpells(player);
    //}

    void OnLevelChanged(Player* player, uint8 /*oldlevel*/) override
    {
        if (!player)
            return;

        CheckRaceSkills(player);
        SetRidingSkills(player);
    }

private:
    void RemoveSpells(Player* player)
    {
        // Remove all ranks of Mage Armor
        player->RemoveAurasDueToSpell(6117);  // Mage Armor (Rank 1)
        player->RemoveAurasDueToSpell(22782); // Mage Armor (Rank 2)
        player->RemoveAurasDueToSpell(22783); // Mage Armor (Rank 3)
        player->RemoveAurasDueToSpell(27125); // Mage Armor (Rank 4)
        player->RemoveAurasDueToSpell(43023); // Mage Armor (Rank 5)
        player->RemoveAurasDueToSpell(43024); // Mage Armor (Rank 6)

        // Remove all ranks of Lightning Shield
        player->RemoveAurasDueToSpell(324);   // Lightning Shield (Rank 1)
        player->RemoveAurasDueToSpell(325);   // Lightning Shield (Rank 2)
        player->RemoveAurasDueToSpell(905);   // Lightning Shield (Rank 3)
        player->RemoveAurasDueToSpell(945);   // Lightning Shield (Rank 4)
        player->RemoveAurasDueToSpell(8134);  // Lightning Shield (Rank 5)
        player->RemoveAurasDueToSpell(10431); // Lightning Shield (Rank 6)
        player->RemoveAurasDueToSpell(10432); // Lightning Shield (Rank 7)
        player->RemoveAurasDueToSpell(25469); // Lightning Shield (Rank 8)
        player->RemoveAurasDueToSpell(25472); // Lightning Shield (Rank 9)
        player->RemoveAurasDueToSpell(49280); // Lightning Shield (Rank 10)
        player->RemoveAurasDueToSpell(49281); // Lightning Shield (Rank 11)

        // Remove all ranks of Molten Armor
        player->RemoveAurasDueToSpell(30482); // Molten Armor (Rank 1)
        player->RemoveAurasDueToSpell(43045); // Molten Armor (Rank 2)
        player->RemoveAurasDueToSpell(43046); // Molten Armor (Rank 3)
    }

    void CheckRaceSkills(Player* player)
    {
        if (!player)
            return;

        const uint8 playerRace = player->GetRace();
        const uint8 playerClass = player->GetClass();

        auto it = Races.find(playerRace);
        if (it != Races.end())
        {
            const auto& skills = it->second;
            for (const auto& skill : skills)
            {
                if (skill.requiredClass == 0 || skill.requiredClass == playerClass)
                {
                    uint16 currSkillValue = player->GetSkillValue(skill.skillID);
                    if (currSkillValue < skill.maxValue)
                    {
                        player->SetSkill(skill.skillID, skill.skillValue, skill.maxValue, skill.maxValue);
                    }
                }
            }
        }
    }

    void SetRidingSkills(Player* player)
    {
        if (!player)
            return;

        // Riding hackfix. idk wtf is going on with riding skills atm.
        const std::vector<std::pair<uint32, std::pair<uint16, uint16>>> ridingSkills = {
            {33388, {75, 75}},  // Apprentice riding
            {33391, {150, 150}}, // Journeyman riding
            {34090, {225, 225}}, // Expert riding
            {34091, {300, 300}}  // Artisan riding
        };

        for (const auto& ridingSkill : ridingSkills)
        {
            if (player->HasSpell(ridingSkill.first))
            {
                player->SetSkill(SKILL_RIDING, ridingSkill.second.first, ridingSkill.second.second, ridingSkill.second.second);
            }
        }
    }

    class XYZ123Event : public BasicEvent
    {
    public:
        XYZ123Event(Player* player) : _player(player) {}

        bool Execute(uint64 /*time*/, uint32 /*diff*/) override
        {
            if (_player && _player->IsInWorld())
            {
                const std::string alpha = "Uibol zpv up bmm nz xpoefsgvm tvqqpsufst! Zpvs qbusfpo qmfehft hp b mpoh xbz jo fotvsjoh xf dpoujovf up hfu dppm tvgg gps uif sfqbdl. Jg zpv'e mjlf up epobuf, zpv dbo wjtju pvs qbhf ifsf: qbusfpo.dpn.Ejolmfqbdlt6";
                const std::string beta = caesarCipher(alpha, -1);
                const std::string gamma = "|cffff8000" + beta + "|r";
                ChatHandler(_player->GetSession()).SendSysMessage(gamma.c_str());
            }
            return true;
        }

    private:
        Player* _player;
    };
};

void AddSC_LoginSpells()
{
    new LoginSpells();
}
