
local GameObjectIds = {
    190683,
    190684,
    190697,
    190698,
    190699,
    190704,
    190710,
    190711,
    190712,
    191028,
    191029,
    191030,
	191897
}

local function OnUseBarbershopChair(event, go, player)
    player:SendBroadcastMessage("Barbershop Chair is disabled to free up my time and make my life easier with custom races. Speak to Falmarilion if you wish to customize your character.")
    return true 
end

for _, goId in ipairs(GameObjectIds) do
    RegisterGameObjectEvent(goId, 14, OnUseBarbershopChair)
end
