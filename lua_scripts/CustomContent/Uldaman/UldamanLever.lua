local UldamLever = {}

-- First Lever and Door
UldamLever.LEVER_ID_1 = 883517
UldamLever.DOOR_ENTRY_1 = 124367

-- Second Lever and Door
UldamLever.LEVER_ID_2 = 883518
UldamLever.DOOR_ENTRY_2 = 141869

-- Third Lever and Door
UldamLever.LEVER_ID_3 = 883519
UldamLever.DOOR_ENTRY_3 = 124368

-- Fourth Lever
UldamLever.LEVER_ID_4 = 883520 
UldamLever.DOOR_ENTRY_4 = 124369 

function UldamLever.OnLeverUsed(event, go, player)
    local action
    local doorEntry
    if go:GetEntry() == UldamLever.LEVER_ID_1 then
        doorEntry = UldamLever.DOOR_ENTRY_1
        action = "use"
    elseif go:GetEntry() == UldamLever.LEVER_ID_2 then
        doorEntry = UldamLever.DOOR_ENTRY_2
        action = "use"
    elseif go:GetEntry() == UldamLever.LEVER_ID_3 then
        doorEntry = UldamLever.DOOR_ENTRY_3
        action = "use"
    elseif go:GetEntry() == UldamLever.LEVER_ID_4 then
        doorEntry = UldamLever.DOOR_ENTRY_4
        action = "despawn"
    else
        return
    end

    local nearObjects = go:GetNearObjects(20) 
    for _, obj in ipairs(nearObjects) do
        if obj:GetEntry() == doorEntry then
            if action == "use" then
                obj:UseDoorOrButton(60000) 
            elseif action == "despawn" then
                obj:Despawn()
            end
            break
        end
    end
end

RegisterGameObjectEvent(UldamLever.LEVER_ID_1, 14, UldamLever.OnLeverUsed)
RegisterGameObjectEvent(UldamLever.LEVER_ID_2, 14, UldamLever.OnLeverUsed)
RegisterGameObjectEvent(UldamLever.LEVER_ID_3, 14, UldamLever.OnLeverUsed)
RegisterGameObjectEvent(UldamLever.LEVER_ID_4, 14, UldamLever.OnLeverUsed)
