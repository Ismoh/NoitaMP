function PlayerNameFunction(entity_id, playerName)
    gui = gui or GuiCreate()
    GuiStartFrame(gui)
    local screenWidth, screenHeight = GuiGetScreenDimensions(gui)
    screenWidth, screenHeight = screenWidth / 2, screenHeight / 2

    local x, y = EntityGetTransform(entity_id)

    local function getEntityPositionOnScreen()
        local camX, camY = GameGetCameraPos()
        return screenWidth + ((x - camX) * 1.5), screenHeight + ((y - camY) * 1.5)
    end

    local entityX, entityY = getEntityPositionOnScreen()
    local playerNameLength = string.len(playerName)
    local playerNameMid = entityX - (playerNameLength * 2)

    GuiText(gui, playerNameMid, entityY, playerName)
end

local entity_id = GetUpdatedEntityID()
username = username or nil

if not username then
    local vsc = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}
    for i = 1, #vsc do
        local variable_storage_component_name = ComponentGetValue2(vsc[i], "name") or nil
        if variable_storage_component_name == "noita-mp.nc_owner.username" then -- see NetworkComponent.component_name_owner_username = "noita-mp.nc_owner.username"
            username = ComponentGetValue2(vsc[i], "value_string")
        end
    end
end

PlayerNameFunction(entity_id, username)
