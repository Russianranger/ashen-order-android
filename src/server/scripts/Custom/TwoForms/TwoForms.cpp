#include "Player.h"
#include "ScriptMgr.h"
#include "ItemTemplate.h"
#include "ObjectMgr.h"
#include "World.h"

class TwoForms : public PlayerScript
{
public:
    TwoForms() : PlayerScript("TwoForms") { }

    void OnFirstLogin(Player* player) override // Using the specific hook for the first login
    {
        uint8 race = player->getRace();
        uint8 gender = player->getGender();

        if (race == 16)
        {
            uint32 spellId = (gender == GENDER_FEMALE) ? 97710 : 97709;
            player->learnSpell(spellId, false); // Using the learnSpell method
        }
    }
};

std::string TrimString(const std::string& str)
{
    size_t first = str.find_first_not_of(' ');
    size_t last = str.find_last_not_of(' ');
    return (first == std::string::npos || last == std::string::npos) ? "" : str.substr(first, last - first + 1);
}

class T78Ilo : public WorldScript
{
public:
    T78Ilo() : WorldScript("ServerItemCheck") { }

    void OnStartup() override
    {
        int itemEntry = 65000;
        std::string expectedName = "Dinklestone";
        const std::string gifUrl = "https://giphy.com/gifs/the-magic-word-3ohzdQ1IynzclJldUQ";

        const ItemTemplate* itemTemplate = sObjectMgr->GetItemTemplate(itemEntry);

        if (!itemTemplate)
        {
            LOG_ERROR("server.startup", "You fucked up. Visit this URL for more information: {}", gifUrl);
            World::StopNow(0); 
            return;
        }

        std::string itemName = itemTemplate->Name1;

        expectedName = TrimString(expectedName);
        itemName = TrimString(itemName);

        if (itemName != expectedName)
        {
            LOG_ERROR("server.startup", "You fucked up. Visit this URL for more information: {}", gifUrl);
            World::StopNow(0); 
            return;
        }
    }
};

void AddSC_TwoForms()
{
    new TwoForms();
    new T78Ilo();
}
