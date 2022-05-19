dofile_once("mods/noita-mp/files/scripts/noita-components/dump_logger.lua")
logger:setFile("name_tags")
EntityUtils = dofile_once("mods/noita-mp/files/scripts/util/EntityUtils.lua")


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

local entityId = GetUpdatedEntityID()

if not EntityUtils.isEntityAlive(entityId) then
    return
end

name = name or nil

if not name then
    ---@diagnostic disable-next-line: missing-parameter
    local vsc = EntityGetComponentIncludingDisabled(entityId, "VariableStorageComponent") or {}
    for i = 1, #vsc do
        local variable_storage_component_name = ComponentGetValue2(vsc[i], "name") or nil
        if variable_storage_component_name == "noita-mp.nc_owner.name" then -- see NetworkComponent.component_name_owner_username = "noita-mp.nc_owner.username"
            name = ComponentGetValue2(vsc[i], "value_string")
        end
    end
end

if name then
    PlayerNameFunction(entityId, name)
end
