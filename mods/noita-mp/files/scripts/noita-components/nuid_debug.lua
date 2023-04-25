dofile_once("mods/noita-mp/files/scripts/init/init_.lua")
-- dofile_once("mods/noita-mp/files/scripts/init/init_logger.lua")
-- dofile_once("mods/noita-mp/files/scripts/extensions/tableExtensions.lua")
-- dofile_once("mods/noita-mp/files/scripts/extensions/mathExtensions.lua")
-- EntityUtils         = dofile_once("mods/noita-mp/files/scripts/util/EntityUtils.lua")
-- NetworkVscUtils     = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")
-- NoitaComponentUtils = dofile_once("mods/noita-mp/files/scripts/util/NoitaComponentUtils.lua")
if ModSettingGet("noita-mp.toggle_debug") then
    local entityId = GetUpdatedEntityID()
    if not EntityUtils.isEntityAlive(entityId) then return end

    gui = gui or GuiCreate()
    GuiStartFrame(gui)
    local screenWidth, screenHeight = GuiGetScreenDimensions(gui)
    screenWidth, screenHeight = screenWidth / 2, screenHeight / 2

    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
    local function getEntityPositionOnScreen()
        local camX, camY = GameGetCameraPos()
        return screenWidth + ((x - camX) * 1.5), screenHeight + ((y - camY) * 1.5)
    end

    local data = {
        owner         = compOwnerName,
        --guid        = compOwnerGuid,
        nuid          = compNuid,
        filename      = filename,
        healthCurrent = health.current,
        healthMax     = health.max,
        --rotation    = rotation,
        vX            = velocity.x,
        vY            = velocity.y,
        x             = x,
        y             = y
    }

    table.setNoitaMpDefaultMetaMethods(data, "kv")
    local i = 0
    
    for name, value in pairs(data) do
        local entityX, entityY = getEntityPositionOnScreen()
        local text             = ("%s: %s"):format(name, value)
        local textLength       = string.len(text)
        local textMid          = entityX - (textLength * 2)
        GuiText(gui, textMid, entityY + (i * 6), text)
        i = i + 1
    end
    data = nil
end
