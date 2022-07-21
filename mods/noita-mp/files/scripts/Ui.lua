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
    local debug = false -- DebugGetIsDevBuild()
    local foldingOpen = false
    local showAddress = false
    local width, height = GetWidthAndHeightByResolution()
    local menuWidth = 241
    local menuHeight = 113
    local x = -menuWidth
    local y = height - menuHeight - 10

    ------------------------------------
    -- Public variables:
    ------------------------------------
    self.ezguiFoldingData = {
        data = {
            text = "",
        },
        methods = {
            toggleFoling = function(data, element)
                foldingOpen = not foldingOpen
            end,
        }
    }

    self.ezguiMenuData = {
        data = {
            debug = debug,
            toggleAddressSrc = "",
            address = "",
            player = {},
            cellWidth = 50,
        },
        methods = {
            toggleAddress = function()
                showAddress = not showAddress
            end,
            copyAddress = function()
                util.copyToClipboard(("%s:%s"):format(_G.Server:getAddress(), _G.Server:getPort()))
            end,
            kick = function(data, element, arg1)
                _G.Server.kick(arg1)
            end,
            ban = function(data, element, arg1)
                _G.Server.ban(arg1)
            end,
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
            toggleDebug = function()
                debug = not debug
            end,
            startProfiler = function()
                profiler.start()
            end,
            stopProfiler = function()
                local directory = fu.GetAbsolutePathOfNoitaRootDirectory() .. _G.path_separator .. "noita-mp_profiler_reports" -- fu.GetAbsoluteDirectoryPathOfMods() .. _G.path_separator .. "profilerReports" .. _G.path_separator
                if fu.Exists(directory) == false then
                    fu.MkDir(directory)
                end
                profiler.stop()
                profiler.report(("%s%s%s"):format(directory, _G.path_separator, "profilerOf" .. whoAmI()))
            end,
        },
        computed = {
            showKickBan = function()
                return _G.Server.amIServer()
            end,
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
        }
    }


    ------------------------------------
    -- Private methods:
    ------------------------------------

    --- Draws [+ NoitaMP] or [- NoitaMP]
    local function drawFolding()
        local text = ""
        if foldingOpen then
            self.ezguiFoldingData.data.text = ("[- NoitaMP] %s"):format(_G.NoitaMPVersion)
        else
            self.ezguiFoldingData.data.text = ("[+ NoitaMP]")
        end

        renderEzgui(0, height - 10, "mods/noita-mp/files/data/ezgui/FoldingMenu.xml", self.ezguiFoldingData)
    end

    local function drawMenu()
        if not foldingOpen then
            x = -menuWidth
            y = height - menuHeight - 10
            return
        end

        local player = {}
        if _G.Server.amIServer() then
            table.insert(player, {
                name = string.ExtendOrCutStringToLength(_G.Server.name, 12, ".", true),
                health = _G.Server.health,
                transform = {
                    x = string.ExtendOrCutStringToLength(_G.Server.transform.x, 11, "", true),
                    y = string.ExtendOrCutStringToLength(_G.Server.transform.y, 11, "", true),
                },
                rtt = 0
            })
            table.insertAllButNotDuplicates(player, _G.Server.clients)
            for i = 2, #player do
                --player[i].name = string.ExtendOrCutStringToLength(player[i].name, 12, ".", true)
                --player[i].health = { current = i, max = 2 }
                --player[i].transform = { x = 123, y = 12334 }
                player[i].rtt = player[i]:getRoundTripTime()
            end
        else
            table.insert(player, 1, {
                name = string.ExtendOrCutStringToLength(_G.Client.serverInfo.name, 12, ".", true),
                health = { current = "?", max = "?" },
                transform = {
                    x = string.ExtendOrCutStringToLength("?", 11, "", true),
                    y = string.ExtendOrCutStringToLength("?", 11, "", true),
                },
                rtt = 0
            })
            table.insert(player, 2, {
                name = string.ExtendOrCutStringToLength(_G.Client.name, 12, ".", true),
                health = _G.Client.health,
                transform = {
                    x = string.ExtendOrCutStringToLength(_G.Client.transform.x, 11, "", true),
                    y = string.ExtendOrCutStringToLength(_G.Client.transform.y, 11, "", true),
                },
                rtt = _G.Client:getRoundTripTime()
            })
            table.insertAllButNotDuplicates(player, _G.Client.otherClients)
            for i = 3, #player do
                player[i].name = string.ExtendOrCutStringToLength(player[i].name, 12, ".", true)
                player[i].health = { current = i, max = 2 }
                player[i].transform = { x = 123, y = 12334 }
                player[i].rtt = player[i]:getRoundTripTime()
            end
        end
        self.ezguiMenuData.data.player = player


        if showAddress then
            self.ezguiMenuData.data.address = ("%s:%s"):format(_G.Server:getAddress(), _G.Server:getPort())
            self.ezguiMenuData.data.toggleAddressSrc = "mods/noita-mp/files/data/ezgui/src/hideAddress.png"
        else
            self.ezguiMenuData.data.address = "XXX.XXX.XXX.XXX:XXXXX"
            self.ezguiMenuData.data.toggleAddressSrc = "mods/noita-mp/files/data/ezgui/src/showAddress.png"
        end

        self.ezguiMenuData.data.debug = debug
        if menuWidth == 0 then
            self.ezguiMenuData.data.cellWidth = math.floor(menuWidth / 3)
        end

        if x < 10 then
            x = x + 20
        else
            x = 10
        end

        menuWidth, menuHeight = renderEzgui(x, y, "mods/noita-mp/files/data/ezgui/PlayerList.xml", self.ezguiMenuData)
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
