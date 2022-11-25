dofile_once("mods/noita-mp/files/scripts/noita-components/dump_logger.lua")
logger:setFile("nuid_debug")
dofile_once("mods/noita-mp/files/scripts/extensions/table_extensions.lua")
EntityUtils         = dofile_once("mods/noita-mp/files/scripts/util/EntityUtils.lua")
NetworkVscUtils     = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")
NoitaComponentUtils = dofile_once("mods/noita-mp/files/scripts/util/NoitaComponentUtils.lua")

function math.sign(v)
    return (v >= 0 and 1) or -1
end

function math.round(v, bracket)
    bracket = bracket or 1
    return math.floor(v / bracket + math.sign(v) * 0.5) * bracket
end

if ModSettingGet("noita-mp.toggle_debug") then

    local entityId = GetUpdatedEntityID()

    if not EntityUtils.isEntityAlive(entityId) then
        return
    end

    gui = gui or GuiCreate()
    GuiStartFrame(gui)

    local screenWidth, screenHeight                                                          = GuiGetScreenDimensions(gui)
    screenWidth, screenHeight                                                                = screenWidth / 2, screenHeight / 2

    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)

    local function getEntityPositionOnScreen()
        local camX, camY = GameGetCameraPos()
        return screenWidth + ((x - camX) * 1.5), screenHeight + ((y - camY) * 1.5)
    end

    local data = {
        owner         = compOwnerName,
        --guid          = compOwnerGuid,
        nuid          = compNuid,
        filename      = filename,
        healthCurrent = health.current,
        healthMax     = health.max,
        --rotation      = rotation,
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
