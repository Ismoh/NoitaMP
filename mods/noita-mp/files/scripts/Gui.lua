--- @class Gui
local Gui = {}

local imGui = load_imgui({ version = "1.10.0", mod = "noita-mp" })

function Gui.new()
    local self = {}

    function self.update()
        if imGui.Begin("test") then
            local playerName = ModSettingGet("noita-mp.name") or ""
            local isPlayerNameChanged, _playerName = imGui.InputTextWithHint("Name", "Type in your Nickname!", playerName)
            if isPlayerNameChanged then
                playerName = _playerName
                print(("isPlayerNameChanged %s, playerName %s"):format(isPlayerNameChanged, playerName))
            end
        end

        imGui.End()
    end

    return self
end

return Gui
