local SPELL_TYRANNICAL = 800142
local SPELL_DECAY = 811142
local SPELL_ENFEEBLE = 811143
local SPELL_NULLIFY = 961618
local SPELL_CORPSE = 861617

local function IsInDungeonOrRaid(player)
    local map = player:GetMap()
    if map and (map:IsDungeon() or map:IsRaid()) then
        return true
    end
    return false
end

local function HandleCommand(event, player, command)
    if not IsInDungeonOrRaid(player) then
        player:SendBroadcastMessage("You must be in a dungeon or raid to use this command.")
        return false
    end

    if command == "cmtyrannical" then
        player:CastSpell(player, SPELL_TYRANNICAL, true)
        player:SendBroadcastMessage("Tyrannical spell casted on you.")
    elseif command == "cmdecay" then
        player:CastSpell(player, SPELL_DECAY, true)
        player:SendBroadcastMessage("Decay spell casted on you.")
    elseif command == "cmenfeeble" then
        player:CastSpell(player, SPELL_ENFEEBLE, true)
        player:SendBroadcastMessage("Enfeeble spell casted on you.")
    elseif command == "cmnullify" then
        player:CastSpell(player, SPELL_NULLIFY, true)
        player:SendBroadcastMessage("Nullify spell casted on you.")
    elseif command == "cmcorpse" then
        player:CastSpell(player, SPELL_CORPSE, true)
        player:SendBroadcastMessage("Corpse spell casted on you.")
    else
        return false 
    end

    return true 
end

RegisterPlayerEvent(42, function(event, player, command)
    local cmd = command:lower()
    if cmd:find("cmtyrannical") or cmd:find("cmdecay") or cmd:find("cmenfeeble") or cmd:find("cmnullify") or cmd:find("cmcorpse") then
        return HandleCommand(event, player, cmd)
    end
end)
