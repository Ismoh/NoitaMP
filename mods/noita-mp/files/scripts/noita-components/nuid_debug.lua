dofile_once("mods/noita-mp/files/scripts/extensions/table_extensions.lua")
dofile_once("mods/noita-mp/files/scripts/noita-components/dump_logger.lua")
NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")

logger:setFile("nuid_debug")

if ModSettingGet("noita-mp.toggle_debug") then

    local entity_id = GetUpdatedEntityID()

    gui = gui or GuiCreate()
    GuiStartFrame(gui)

    local screenWidth, screenHeight = GuiGetScreenDimensions(gui)
    screenWidth, screenHeight = screenWidth / 2, screenHeight / 2

    local x, y = EntityGetTransform(entity_id)

    local function getEntityPositionOnScreen()
        local camX, camY = GameGetCameraPos()
        return screenWidth + ((x - camX) * 1.5), screenHeight + ((y - camY) * 1.5)
    end

    local vsc = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}
    for i = 1, #vsc do
        local entityX, entityY = getEntityPositionOnScreen()
        local variable_storage_component_name = ComponentGetValue2(vsc[i], "name") or nil
        local found = string.find(variable_storage_component_name, "noita-mp", 1, true)
        local found = string.find(variable_storage_component_name, NetworkVscUtils.componentNameOfNuid, 1, true)
        if found ~= nil then
            local value = ComponentGetValue2(vsc[i], "value_string")
            local text = ("%s = %s, component_id = %s"):format(variable_storage_component_name, value, vsc[i])
            local text = ("nuid = %s"):format(value)

            local textLength = string.len(text)
            local textMid = entityX - (textLength * 2)

            GuiText(gui, textMid, entityY + (i * 2), text)
        end
    end

end
