CursedGilnean = {
    NPC_ID = 1000009,
    SOUND_ID_1 = 9036,
    SOUND_ID_2 = 174314,
    TIMER_INTERVAL = 15000, -- 15 seconds in milliseconds
    CHANCE_TO_PLAY_SOUND = 5, -- 5% chance
    PeriodicEvent = function(_, _, _, creature)
        local randomChance = math.random(1, 100)
        if randomChance <= CursedGilnean.CHANCE_TO_PLAY_SOUND then
            local randomSound = math.random(1, 2)
            if randomSound == 1 then
                creature:PlayDirectSound(CursedGilnean.SOUND_ID_1)
            else
                creature:PlayDirectSound(CursedGilnean.SOUND_ID_2)
            end
        end
    end,
    OnSpawn = function(event, creature)
        creature:RegisterEvent(CursedGilnean.PeriodicEvent, CursedGilnean.TIMER_INTERVAL, 0)
    end
}

RegisterCreatureEvent(CursedGilnean.NPC_ID, 5, CursedGilnean.OnSpawn)
