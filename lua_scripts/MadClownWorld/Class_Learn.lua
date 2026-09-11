local function RemoveZeroSkillsOnServerStart()
    local query = "DELETE FROM character_skills WHERE skill = 0"
    CharDBExecute(query)
    print("[Server Cleanup] Removed all entries from character_skills where skill = 0.")
end

RegisterServerEvent(33, RemoveZeroSkillsOnServerStart)
