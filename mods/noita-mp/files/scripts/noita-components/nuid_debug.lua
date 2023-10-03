dofile_once("mods/noita-mp/files/scripts/init/init_.lua")

---@type Logger
logger = logger or
    dofile_once("mods/noita-mp/files/scripts/util/Logger.lua")
    :new(nil, { start = function() end, stop = function() end })

---@type GlobalsUtils
globalsUtils = globalsUtils or
    dofile_once("mods/noita-mp/files/scripts/util/GlobalsUtils.lua")
    :new(nil, logger.customProfiler, logger, {}, {
        isEmpty = function(self, var)
            if var == nil then
                return true
            end
            if var == "" then
                return true
            end
            if type(var) == "table" and not next(var) then
                return true
            end
            return false
        end
    })

---@type NetworkVscUtils
networkVscUtils = networkVscUtils or
    dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")
    :new(nil, logger.customProfiler, logger, {}, globalsUtils, globalsUtils.utils)

---@type NoitaComponentUtils
noitaComponentUtils = noitaComponentUtils or
    dofile_once("mods/noita-mp/files/scripts/util/NoitaComponentUtils.lua")
    :new(nil, logger.customProfiler, globalsUtils, logger, networkVscUtils, globalsUtils.utils)

if ModSettingGet("noita-mp.toggle_debug") then
    local entityId = GetUpdatedEntityID()
    if not EntityGetIsAlive(entityId) then return end

    gui = gui or GuiCreate()
    GuiStartFrame(gui)
    local screenWidth, screenHeight = GuiGetScreenDimensions(gui)
    screenWidth, screenHeight = screenWidth / 2, screenHeight / 2

    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = noitaComponentUtils:getEntityData(entityId)
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
