function PlayerNameFunction(playerName)
    gui = gui or GuiCreate()
    GuiStartFrame(gui)
    local screenWidth, screenHeight = GuiGetScreenDimensions(gui)
    screenWidth, screenHeight = screenWidth/2, screenHeight/2

    local entityId = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entityId)

    function getEntityPositionOnScreen(entityId)
        local camX, camY = GameGetCameraPos()
        return screenWidth+((x-camX)*1.5),screenHeight+((y-camY)*1.5)
    end

    local entityX, entityY = getEntityPositionOnScreen(EntityGetWithTag("player_unit")[1])
    local playerNameLength = string.len(playerName)
    local playerNameMid = entityX -(playerNameLength*2)

    GuiText(gui,playerNameMid,entityY,playerName)
end

PlayerNameFunction("testname")