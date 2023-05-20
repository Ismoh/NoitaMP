---Everything regarding ImGui: Credits to dextercd#7326
--- @class Gui
local Gui = {}

if not load_imgui then
    function OnWorldInitialized()
        local defaultFile = "mods/component-explorer/entities/imgui_warning.xml"
        if not FileUtils.Exists(defaultFile) then
            defaultFile = "mods/noita-mp/files/data/entities/imgui_warning.xml"
        end
        EntityLoad(defaultFile, 0, 0)
    end

    error("Missing ImGui.", 2)
end

local imGui = load_imgui({ version = "1.10.0", mod = "noita-mp" })

--- Can't know the width before creating the window.. Just an initial value, it's updated to the real value once we can call imgui.GetWindowWidth()
local menuBarWidth = 100
local function getMenuBarPosition()
    local cpc = CustomProfiler.start("Gui.getMenuBarPosition")

    local menuBarHeight = imGui.GetFontSize() + 2 * imGui.GetStyle().FramePadding_y

    -- Available space
    local aw, ah = imGui.GetMainViewportSize()
    aw = aw - menuBarWidth
    ah = ah - menuBarHeight + 3 -- Bit extra to get rid of the bottom deadzone of the window

    local rx, ry

    local side = "top"

    if side == "top" then
        ry = 0
    elseif side == "bottom" then
        ry = 1
    elseif side == "left" then
        rx = 0
    elseif side == "right" then
        rx = 1
    end

    local roffset = 0

    if rx == nil then
        rx = roffset
    elseif ry == nil then
        ry = roffset
    end

    local vx, vy = imGui.GetMainViewportWorkPos()

    CustomProfiler.stop("Gui.getMenuBarPosition", cpc)
    return vx + aw * rx - 2, vy + ah * ry
end

local function tooltipHelper(tooltip)
    local cpc = CustomProfiler.start("Gui.tooltipHelper")

    if not Utils.IsEmpty(tooltip) then
        imGui.SameLine()
        imGui.TextDisabled("(?)")
        if imGui.IsItemHovered() then
            imGui.BeginTooltip()
            imGui.PushTextWrapPos(imGui.GetFontSize() * 35.0)
            imGui.TextUnformatted(tooltip)
            imGui.PopTextWrapPos()
            imGui.EndTooltip()
        end
    end

    CustomProfiler.stop("Gui.tooltipHelper", cpc)
end

function Gui.new()
    local cpc = CustomProfiler.start("Gui.new")
    local self = {}
    self.shortcuts = {
        about     = "CTRL + A",
        bugReport = "CTRL + B",
        play      = "CTRL + P",
        settings  = "CTRL + S",
    }
    self.menuBarLabel = "NoitaMP"
    self.playLabel = "NoitaMp - Play"
    self.settingsLabel = "NoitaMp - Settings"
    self.aboutLabel = "NoitaMp - About"
    self.showFirstTime = true
    self.showPlayMenu = false
    self.showSettings = false
    self.showAbout = false

    function self.update()
        local cpcUpdate = CustomProfiler.start("Gui.update")

        self.checkShortcuts()
        self.drawMenuBar()

        if self.firstTime then
            self.drawFirstTime()
        end

        if self.showPlayMenu then
            self.drawPlayMenu()
        else
            if not Server.isRunning() then
                self.isServer = nil
            end
        end

        if self.showSettings then
            self.drawSettings()
        end

        if self.showAbout then
            self.drawAbout()
        end

        CustomProfiler.stop("Gui.update", cpcUpdate)
    end

    function self.drawMenuBar()
        local cpcDrawMenuBar = CustomProfiler.start("Gui.drawMenuBar")

        local windowFlags = bit.bor(
            imGui.WindowFlags.MenuBar,
            imGui.WindowFlags.NoDocking,
            imGui.WindowFlags.NoSavedSettings,
            imGui.WindowFlags.NoFocusOnAppearing,
            imGui.WindowFlags.NoMove,
            imGui.WindowFlags.NoDecoration,
            imGui.WindowFlags.NoBackground,
            imGui.WindowFlags.AlwaysAutoResize
        )

        imGui.SetNextWindowViewport(imGui.GetMainViewportID())
        imGui.SetNextWindowPos(getMenuBarPosition())
        imGui.SetNextWindowSize(0, 0)

        if imGui.Begin(self.menuBarLabel, nil, windowFlags) then
            tooltipHelper(("CheatGui hidden? Press '%s'!"):format(self.shortcuts.settings))

            -- Save actual window width for next positioning
            menuBarWidth = imGui.GetWindowWidth()

            if imGui.BeginMenuBar() then
                if imGui.BeginMenu(self.menuBarLabel) then
                    if imGui.MenuItem("Play!", self.shortcuts.play) then
                        self.showPlayMenu = not self.showPlayMenu
                    end
                    if imGui.MenuItem("Settings", self.shortcuts.settings) then
                        self.showSettings = not self.showSettings
                    end
                    if imGui.MenuItem("About", self.shortcuts.about) then
                        self.showAbout = not self.showAbout
                    end
                    imGui.Separator()
                    if imGui.MenuItem("Found a bug?", self.shortcuts.bugReport) then
                        Utils.openUrl("https://github.com/Ismoh/NoitaMP/issues/new/choose")
                    end
                    imGui.EndMenu()
                end
                imGui.EndMenuBar()
            end
            imGui.End()
        end
        CustomProfiler.stop("Gui.drawMenuBar", cpcDrawMenuBar)
    end

    function self.drawFirstTime()
        local cpc = CustomProfiler.start("Gui.drawFirstTime")

        local windowFlags = --bit.bor(
        -- imGui.WindowFlags.MenuBar,
        -- imGui.WindowFlags.NoDocking,
        -- imGui.WindowFlags.NoSavedSettings,
        -- imGui.WindowFlags.NoFocusOnAppearing,
        -- imGui.WindowFlags.NoMove,
        -- imGui.WindowFlags.NoDecoration,
        -- imGui.WindowFlags.NoBackground
            imGui.WindowFlags.AlwaysAutoResize
        --)

        local isCollapsed
        isCollapsed, self.showFirstTime = imGui.Begin("Welcome to NoitaMP!", self.showFirstTime, windowFlags)
        if isCollapsed then
            imGui.Text("This is the first time you're using NoitaMP, please set your name and press 'Let's go!'")
            imGui.End()
        end

        CustomProfiler.stop("Gui.drawFirstTime", cpc)
    end

    function self.drawPlayMenu()
        local cpc = CustomProfiler.start("Gui.drawPlayMenu")

        local windowFlags = --bit.bor(
        -- imGui.WindowFlags.MenuBar,
        -- imGui.WindowFlags.NoDocking,
        -- imGui.WindowFlags.NoSavedSettings,
        -- imGui.WindowFlags.NoFocusOnAppearing,
        -- imGui.WindowFlags.NoMove,
        -- imGui.WindowFlags.NoDecoration,
        -- imGui.WindowFlags.NoBackground
            imGui.WindowFlags.AlwaysAutoResize
        --)

        local isCollapsed
        isCollapsed, self.showPlayMenu = imGui.Begin(self.playLabel, self.showPlayMenu, windowFlags)
        if isCollapsed then
            if Utils.IsEmpty(MinaUtils.getLocalMinaName()) then
                imGui.Text(("Please set your name in the settings first! Simply press '%s'!"):format(self.shortcuts.settings))
                imGui.End()
                CustomProfiler.stop("Gui.drawPlayMenu", cpc)
                return
            end

            if Utils.IsEmpty(self.isServer) then
                imGui.Text("Do you want to host or join a server?")
                imGui.Separator()
                if imGui.SmallButton("Host!") then
                    self.isServer = true
                end
                imGui.SameLine()
                if imGui.SmallButton("Join..") then
                    self.isServer = false
                end
                imGui.End()
                CustomProfiler.stop("Gui.drawPlayMenu", cpc)
                return
            end

            if self.isServer then
                local serverIpText = Server:getAddress()
                if StreamingGetIsConnected() then
                    serverIpText = "Hidden Server IP, because streaming is enabled!"
                end

                imGui.LabelText("Server IP:", serverIpText)
                imGui.SameLine()
                if imGui.SmallButton("Copy IP to clipboard!") then
                    imGui.SetClipboardText(Server:getAddress())
                end

                local isPortChanged, port = imGui.InputTextWithHint("Server Port", "Type from 1 to max of 65535!", tostring(Server:getPort()))
                if isPortChanged then
                    Server.port = port
                end

                imGui.Separator()
                if imGui.Button("Start Server!") then
                    Server.start(Server:getAddress(), Server:getPort())
                    self.showPlayMenu = false
                end
            else
                local isServerIpChanged, serverIp = imGui.InputTextWithHint("Server IP", "Use '*', 'localhost' or 'whatismyip.com'!",
                    Server:getAddress())
                if isServerIpChanged then
                    Server.address = serverIp
                end
            end
            imGui.End()
        end

        CustomProfiler.stop("Gui.drawPlayMenu", cpc)
    end

    function self.drawSettings()
        local cpc = CustomProfiler.start("Gui.drawSettings")

        local windowFlags = --bit.bor(
        -- imGui.WindowFlags.MenuBar,
        -- imGui.WindowFlags.NoDocking,
        -- imGui.WindowFlags.NoSavedSettings,
        -- imGui.WindowFlags.NoFocusOnAppearing,
        -- imGui.WindowFlags.NoMove,
        -- imGui.WindowFlags.NoDecoration,
        -- imGui.WindowFlags.NoBackground
            imGui.WindowFlags.AlwaysAutoResize
        --)

        local isCollapsed
        isCollapsed, self.showSettings = imGui.Begin(self.settingsLabel, self.showSettings, windowFlags)
        if isCollapsed then
            -- Player name
            local isPlayerNameChanged, _playerName = imGui.InputTextWithHint("Name", "Type in your Nickname!", MinaUtils.getLocalMinaName())
            if isPlayerNameChanged then
                MinaUtils.setLocalMinaName(_playerName)
            end

            -- Guid
            imGui.Text(("Guid: %s"):format(MinaUtils.getLocalMinaGuid()))
            imGui.End()
        end

        CustomProfiler.stop("Gui.drawSettings", cpc)
    end

    function self.drawAbout()
        local cpc = CustomProfiler.start("Gui.drawAbout")

        local windowFlags = --bit.bor(
        -- imGui.WindowFlags.MenuBar,
        -- imGui.WindowFlags.NoDocking,
        -- imGui.WindowFlags.NoSavedSettings,
        -- imGui.WindowFlags.NoFocusOnAppearing,
        -- imGui.WindowFlags.NoMove,
        -- imGui.WindowFlags.NoDecoration,
        -- imGui.WindowFlags.NoBackground
            imGui.WindowFlags.AlwaysAutoResize
        --)

        -- imGui.SetNextWindowViewport(imGui.GetMainViewportID())
        -- imGui.SetNextWindowPos(getMenuBarPosition())
        -- imGui.SetNextWindowSize(0, 0)

        local isCollapsed
        isCollapsed, self.showAbout = imGui.Begin(self.aboutLabel, self.showAbout, windowFlags)
        if isCollapsed then
            imGui.Text("NoitaMP is a multiplayer mod for Noita.")
            imGui.Text("It's currently in early development, so expect bugs and crashes.")
            imGui.Text("If you find any bugs, please report them on the GitHub page. Just press on 'Found a bug?' in the menu bar or press " ..
                self.shortcuts.bugReport .. ".")

            imGui.Separator()
            imGui.Text("NoitaMP - Noita Multiplayer version " .. FileUtils.GetVersionByFile())
            imGui.Text("Made by Ismoh#0815 and many other awesome contributers!")
            imGui.Text("Homepage: https://github.com/Ismoh/NoitaMP")
            imGui.SameLine()
            if imGui.SmallButton("Open in Browser") then
                Utils.openUrl("https://github.com/Ismoh/NoitaMP")
            end
            imGui.Text("Join 'Ismoh Games' Discord server!")
            imGui.SameLine()
            if imGui.SmallButton("Open in Browser") then
                Utils.openUrl("https://discord.gg/DhMurdcw4k")
            end

            imGui.Separator()
            imGui.Text("If you want to help with the development, you can find the source code on GitHub.")
            imGui.Text("If you want to chat with other players, you can join the Discord server.")
            imGui.Text("If you want to support the development, you can donate on Patreon.")
            imGui.Text("If you want to contact me, you can find my contact info on GitHub.")

            imGui.End()
        end

        CustomProfiler.stop("Gui.drawAbout", cpc)
    end

    function self.checkShortcuts()
        local cpc = CustomProfiler.start("Gui.checkShortcuts")

        if not imGui.IsKeyDown(imGui.Key.LeftCtrl) then
            return
        end

        if imGui.IsKeyPressed(imGui.Key.A) then
            self.showAbout = not self.showAbout
        end

        if imGui.IsKeyPressed(imGui.Key.B) then
            Utils.openUrl("https://github.com/Ismoh/NoitaMP/issues/new/choose")
        end

        if imGui.IsKeyPressed(imGui.Key.P) then
            self.showPlayMenu = not self.showPlayMenu
        end

        if imGui.IsKeyPressed(imGui.Key.S) then
            self.showSettings = not self.showSettings
        end

        CustomProfiler.stop("Gui.checkShortcuts", cpc)
    end

    CustomProfiler.stop("Gui.new", cpc)
    return self
end

return Gui
