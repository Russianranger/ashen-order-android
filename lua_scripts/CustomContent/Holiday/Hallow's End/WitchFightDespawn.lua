local npcsToCheck = {
    [814496] = true,
    [888849] = true,
    [888851] = true
}

local npcsToLookFor = {
    [881853] = true,
    [881854] = true,
    [881855] = true
}

local gameObjectsToCheck = {
    [187988] = true,
    [914401] = true
}

local function OnSpawn(event, creature)
    local creatureId = creature:GetEntry()

    if npcsToCheck[creatureId] then
        local creaturesInRange = creature:GetCreaturesInRange(100)

        for _, target in pairs(creaturesInRange) do
            local targetId = target:GetEntry()
            
            if npcsToLookFor[targetId] then
                creature:DespawnOrUnsummon(0)
                return
            end
        end
    end
end

RegisterCreatureEvent(814496, 5, OnSpawn)
RegisterCreatureEvent(888849, 5, OnSpawn)
RegisterCreatureEvent(888851, 5, OnSpawn)



local function OnGameObjectSpawn(event, go)
    local goId = go:GetEntry()

    if gameObjectsToCheck[goId] then
        local creaturesInRange = go:GetCreaturesInRange(100)

        for _, target in pairs(creaturesInRange) do
            local targetId = target:GetEntry()
            
            if npcsToLookFor[targetId] then
                go:Despawn()
                return
            end
        end
    end
end

RegisterGameObjectEvent(187988, 2, OnGameObjectSpawn)
RegisterGameObjectEvent(914401, 2, OnGameObjectSpawn)
