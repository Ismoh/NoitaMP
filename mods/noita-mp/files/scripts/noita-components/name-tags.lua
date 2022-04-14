
function PlayerNameFunction(playerName)
    gui = gui or GuiCreate()
    GuiStartFrame(gui)
    local x1, y1 = GuiGetScreenDimensions(gui)
    x1, y1 = x1/2, y1/2

    local entityId = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entityId)

    function getEntityPositionOnScreen(entityId)
        local camX, camY = GameGetCameraPos()
        return x1+((x-camX)*1.5),y1+((y-camY)*1.5)
    end

    local xL, yL = getEntityPositionOnScreen(EntityGetWithTag("player_unit")[1])
    local playerNameLength = string.len(playerName)
    local playerNameMid = xL -(playerNameLength*2)

    GuiText(gui,playerNameMid,yL,playerName)
end

PlayerNameFunction("testname")