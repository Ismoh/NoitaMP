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
    local showAddress = false
    local width, height = GetWidthAndHeightByResolution()
    local menuWidth = 0
    local menuHeight = 0

    ------------------------------------
    -- Public variables:
    ------------------------------------
    self.ezguiFoldingData = {
        toggleFoling = function(data, element)
            foldingOpen = not foldingOpen
        end,
        text = "",
    }

    self.ezguiMenuData = {
        debug = DebugGetIsDevBuild(),
        toggleAddressSrc = "",
        toggleAddress = function()
            showAddress = not showAddress
        end,
        address = "",
        copyAddress = function()
            util.copyToClipboard(("%s:%s"):format(_G.Server:getAddress(), _G.Server:getPort()))
        end,
        player = {},
        kick = function(data, element, arg1)
            _G.Server.kick(arg1)
        end,
        ban = function(data, element, arg1)
            _G.Server.ban(arg1)
        end,
        -----------
        showStart = function()
            return not _G.Server.isRunning() and not _G.Client.isConnected()
        end,
        showStop = function()
            return _G.Server.isRunning()
        end,
        showConnect = function()
            return not _G.Server.isRunning() and not _G.Client.isConnected()
        end,
        showConnected = function()
            return _G.Client.isConnected()
        end,
        showDisconnect = function()
            return _G.Client.isConnected()
        end,
        -----------
        start = function()
            _G.Server.start(nil, nil)
        end,
        stop = function()
            _G.Server.stop()
        end,
        connect = function()
            _G.Client.connect()
        end,
        disconnect = function()
            _G.Client.disconnect()
        end,
    }

    ------------------------------------
    -- Private methods:
    ------------------------------------

    --- Draws [+ NoitaMP] or [- NoitaMP]
    local function drawFolding()
        local text = ""
        if foldingOpen then
            self.ezguiFoldingData.text = ("[- NoitaMP] v0.0.0-alpha")
        else
            self.ezguiFoldingData.text = ("[+ NoitaMP]")
        end

        renderEzgui(0, height - 10, "mods/noita-mp/files/data/ezgui/FoldingMenu.xml", self.ezguiFoldingData)
    end

    local function drawMenu()
        if not foldingOpen then
            return
        end

        local player = {}
        if _G.Server.amIServer() then
            table.insert(player, { name = _G.Server.name, health = 123, x = 1, y = 3, rtt = 0 })
            table.insertAllButNotDuplicates(player, _G.Server.clients)
            for i = 2, #player do
                player[i].health = i
                player[i].x = 2 * i
                player[i].y = 3 * i
                player[i].rtt = player[i]:getRoundTripTime()
            end
        else
            table.insert(player, { name = _G.Client.name, health = 123, x = 1, y = 3, rtt = _G.Client:getRoundTripTime() })
            table.insertAllButNotDuplicates(player, _G.Client.otherClients)
            for i = 2, #player do
                player[i].health = i
                player[i].x = 2 * i
                player[i].y = 3 * i
                player[i].rtt = player[i]:getRoundTripTime()
            end
        end
        self.ezguiMenuData.player = player


        if showAddress then
            self.ezguiMenuData.address = ("%s:%s"):format(_G.Server:getAddress(), _G.Server:getPort())
            self.ezguiMenuData.toggleAddressSrc = "mods/noita-mp/files/data/ezgui/src/hideAddress.png"
        else
            self.ezguiMenuData.address = "XXX.XXX.XXX.XXX:XXXXX"
            self.ezguiMenuData.toggleAddressSrc = "mods/noita-mp/files/data/ezgui/src/showAddress.png"
        end

        menuWidth, menuHeight = renderEzgui(10, height - menuHeight - 10, "mods/noita-mp/files/data/ezgui/PlayerList.xml", self.ezguiMenuData)
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
