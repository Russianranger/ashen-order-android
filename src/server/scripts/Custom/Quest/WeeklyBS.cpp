#include "ScriptMgr.h"
#include "Player.h"
#include "World.h"
#include "WorldSession.h"
#include "ObjectMgr.h"
#include "DatabaseEnv.h"
#include <random>

#define WORLD_STATE_WEEKLY_QUEST 2000
#define WORLD_STATE_LAST_RESET 20002

class WeeklyQuestManager : public WorldScript
{
public:
    WeeklyQuestManager() : WorldScript("WeeklyQuestManager") {}

    void OnStartup() override
    {
        // Initialize world states if they do not exist
        if (!sWorld->getWorldState(WORLD_STATE_WEEKLY_QUEST))
        {
            sWorld->setWorldState(WORLD_STATE_WEEKLY_QUEST, 41536); // Set to the first quest ID as default
        }

        if (!sWorld->getWorldState(WORLD_STATE_LAST_RESET))
        {
            sWorld->setWorldState(WORLD_STATE_LAST_RESET, time(nullptr));
        }
    }

    void OnUpdate(uint32 diff) override
    {
        static uint32 updateInterval = 60000; // 1 minute
        static uint32 lastUpdate = 0;

        lastUpdate += diff;
        if (lastUpdate >= updateInterval)
        {
            lastUpdate = 0;

            time_t currentTime = time(nullptr);
            time_t lastResetTime = sWorld->getWorldState(WORLD_STATE_LAST_RESET);

            // Check if a week has passed since the last reset
            if (difftime(currentTime, lastResetTime) >= 7 * DAY)
            {
                // Update the last reset time
                sWorld->setWorldState(WORLD_STATE_LAST_RESET, currentTime);

                // Select the next weekly quest
                uint32 nextQuest = GetRandomWeeklyQuest();

                // Update the world state with the next weekly quest
                sWorld->setWorldState(WORLD_STATE_WEEKLY_QUEST, nextQuest);

            }
        }
    }

private:
    uint32 GetRandomWeeklyQuest()
    {
        // List of weekly quest IDs
        std::vector<uint32> weeklyQuests = {
            41536, 41537, 41538, 41539, 41540,
            41541, 41542, 41543, 41544, 41545,
            41546, 41547, 41548, 41549
        };

        // Seed the random number generator
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<> dis(0, weeklyQuests.size() - 1);

        // Select a random quest
        return weeklyQuests[dis(gen)];
    }
};

void AddSC_WeeklyQuestManager()
{
    new WeeklyQuestManager();
}
