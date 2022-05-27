-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------
-- 'Imports'
----------------------------------------
local renderEzgui = dofile_once("mods/noita-mp/files/lib/external/ezgui/EZGUI.lua").init("mods/noita-mp/files/lib/external/ezgui")

----------------------------------------------------------------------------------------------------
--- Ui
--- @see PlayerList.xml
--- @see FoldingMenu.xml
----------------------------------------------------------------------------------------------------
Ui = {}

----------------------------------------
-- Global private variables:
----------------------------------------

----------------------------------------
-- Global private methods:
----------------------------------------

--- Returns width and height depending on resolution.
--- GuiGetScreenDimensions( gui:obj ) -> width:number,height:number [Returns dimensions of viewport in the gui coordinate system (which is equal to the coordinates of the screen bottom right corner in gui coordinates). The values returned may change depending on the game resolution because the UI is scaled for pixel-perfect text rendering.]
--- @return number width
--- @return number height
function GetWidthAndHeightByResolution()
    local gui = GuiCreate()
    local width, height = GuiGetScreenDimensions(gui)
    GuiDestroy(gui)
    -- pixels are twice as big as normal, thats why we need to divide by 2 to get the max value of height and width, when working with GUI
    return width / 2, height / 2
end

----------------------------------------
-- Access to global private variables
----------------------------------------

----------------------------------------
-- Global public variables:
----------------------------------------

----------------------------------------------------------------------------------------------------
--- Ui constructor
----------------------------------------------------------------------------------------------------
function Ui.new()
    local self = {}

    ------------------------------------
    -- Private variables:
    ------------------------------------
    local foldingOpen = false
    local width, height = GetWidthAndHeightByResolution()

    ------------------------------------
    -- Public variables:
    ------------------------------------

    ------------------------------------
    -- Private methods:
    ------------------------------------

    --- Draws [+ NoitaMP] or [- NoitaMP]
    local function drawFolding()
        local text = ""
        if foldingOpen then
            text = ("[- NoitaMP] v0.0.0-alpha")
        else
            text = ("[+ NoitaMP]")
        end

        local foldingData = {
            toggleFoling = function(data, element)
                foldingOpen = not foldingOpen
            end,
            text = text,
        }
        renderEzgui(0, height - 10, "mods/noita-mp/files/data/ezgui/FoldingMenu.xml", foldingData)
    end

    local function drawMenu()
        if not foldingOpen then
            return
        end

        local clients = {}
        if _G.Server.amIServer() then
            clients = _G.Server.clients
            for i = 1, #clients do
                clients[i].rtt = clients[i]:getRoundTripTime()
            end
        else
            clients = { name = _G.Client.name, rtt = _G.Client:getRoundTripTime() }
        end

        local playerListData = {
            version = "0.1.0 - alpha + 1", --fu.ReadFile(".version")
            ip = _G.Server:getAddress(),
            port = _G.Server:getPort(),
            start = function()
                _G.Server.start(nil, nil)
            end,
            clients = clients,
            kick = function(data, element, arg1)
                _G.Server.kick(arg1)
            end,
            ban = function(data, element, arg1)
                _G.Server.ban(arg1)
            end
        }
        renderEzgui(0, height - 20, "mods/noita-mp/files/data/ezgui/PlayerList.xml", playerListData)
    end

    ------------------------------------
    -- Public methods:
    ------------------------------------
    function self.update()
        drawFolding()
        drawMenu()
    end

    ------------------------------------
    -- Apply some private methods
    ------------------------------------

    return self
end

-- Init this object:

return Ui
