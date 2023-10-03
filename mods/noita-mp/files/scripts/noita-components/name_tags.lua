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

function PlayerNameFunction(entity_id, playerName)
    gui = gui or GuiCreate()
    GuiStartFrame(gui)
    local screenWidth, screenHeight = GuiGetScreenDimensions(gui)
    screenWidth, screenHeight       = screenWidth / 2, screenHeight / 2
    local x, y                      = EntityGetTransform(entity_id)
    local camX, camY                = GameGetCameraPos()

    GuiText(gui, ((screenWidth + ((x - camX) * 1.5)) - (string.len(playerName) * 2)),
        (screenHeight + ((y - camY) * 1.5)), playerName)
end

local entityId = GetUpdatedEntityID()
if not EntityGetIsAlive(entityId) then
    return
end

name = name or nil
if not name or globalsUtils:getUpdateGui() then
    local vsc = EntityGetComponentIncludingDisabled(entityId, "VariableStorageComponent") or {}
    for i = 1, #vsc do
        if ComponentGetValue2(vsc[i], "name") == "noita-mp.nc_owner.name" then
            name = ComponentGetValue2(vsc[i], "value_string")
        end
    end
end

if name then
    PlayerNameFunction(entityId, name)
end
