---Everything regarding ImGui: Credits to @dextercd
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

local imGui = load_imgui({ version = "1.11.0", mod = "noita-mp" })

--- Can't know the width before creating the window.. Just an initial value, it's updated to the real value once we can call imgui.GetWindowWidth()
local menuBarWidth = 100
local function getMenuBarPosition(position)
    local cpc = CustomProfiler.start("Gui.getMenuBarPosition")

    local menuBarHeight = imGui.GetFontSize() + 2 * imGui.GetStyle().FramePadding_y

    -- Available space
    local aw, ah = imGui.GetMainViewportSize()
    aw = aw - menuBarWidth
    ah = ah - menuBarHeight + 3 -- Bit extra to get rid of the bottom deadzone of the window

    local rx, ry

    local side = position

    if side == "top-left" then
        rx = 0
        ry = 0
    elseif side == "top-right" then
        rx = 1
        ry = 0
    elseif side == "bottom-left" then
        rx = 0
        ry = 1
    elseif side == "bottom-right" then
        rx = 1
        ry = 1
    end

    local roffset = 0

    if rx == nil then
        rx = roffset
    elseif ry == nil then
        ry = roffset
    end

    local vx, vy = imGui.GetMainViewportWorkPos()

    CustomProfiler.stop("Gui.getMenuBarPosition", cpc)
    return vx + aw * rx - 2, vy + ah * ry + 20
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
        about      = "CTRL + ALT + A",
        bugReport  = "CTRL + ALT + B",
        playerList = "CTRL + ALT + L",
        play       = "CTRL + ALT + P",
        settings   = "CTRL + ALT + S",
    }
    self.menuBarLabel = "NoitaMP"
    self.menuBarPosition = "top-left"
    self.playLabel = "NoitaMp - Play"
    self.settingsLabel = "NoitaMp - Settings"
    self.aboutLabel = "NoitaMp - About"
    self.playerListLabel = "NoitaMp - Player List"
    self.showAbout = false
    self.showFirstTime = true
    self.showMissingSettings = false
    self.showPlayMenu = false
    self.showSettings = false
    self.showSettingsSaved = false
    self.showPlayerList = false

    function self.setShowSettingsSaved(show)
        self.showSettingsSaved = show
        if show then
            showSettingsSavedTimer = GameGetRealWorldTimeSinceStarted()
        end
    end

    function self.setShowMissingSettings(show)
        self.showMissingSettings = show
    end

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

        if self.showSettings or self.showMissingSettings then
            self.drawSettings()
        end

        if self.showAbout then
            self.drawAbout()
        end

        if self.showPlayerList then
            self.drawPlayerList()
        end

        -- TODO: Remove this before merging
        -- local imPlot = imGui.implot
        -- imGui.SetNextWindowSize(800, 400, imGui.Cond.Once)
        -- if imGui.Begin("Enemy Tracker") then
        --     if imPlot.BeginPlot("Enemies") then
        --         -- implot.SetupAxes("time", "enemy count", implot.PlotAxisFlags.AutoFit);
        --         -- implot.SetupAxisLimits(implot.Axis.Y1, 0, 20)
        --         -- implot.PlotLine("Hämis", hamis_history, 1, discarded)
        --         -- implot.PlotLine("Zombie", zombie_history, 1, discarded)
        --         -- implot.PlotLine("Miner", miner_history, 1, discarded)
        --         -- implot.PlotLine("Shotgunner", shotgunner_history, 1, discarded)
        --         local data = { 1, 2, 3, 4, 5,
        --             6, 7, 8, 9, 10,
        --             11, 12, 13, 14, 15 }
        --         imPlot.SetupLegend(imPlot.PlotLocation.East, imPlot.PlotLegendFlags.Outside)
        --         --imPlot.SetupAxes("Student", "Score", imPlot.PlotAxisFlags.AutoFit, imPlot.PlotAxisFlags.AutoFit);
        --         --imPlot.SetupAxisTicks(imPlot.PlotAxis.X1, { 0, 1, 2, 3, 4, 5 }, { "A", "B", "C", "D", "E" });
        --         --imPlot.PlotBarGroups({ "Test1", "Test2", "Test3" }, data, 3, 5, 0.75, 0, 0);
        --         imPlot.EndPlot()
        --     end
        --     imGui.End()
        -- end
        -- -- if (ImPlot::BeginPlot("Bar Group")) {
        -- --     ImPlot::SetupLegend(ImPlotLocation_East, ImPlotLegendFlags_Outside);
        -- --     if (horz) {
        -- --         ImPlot::SetupAxes("Score","Student",ImPlotAxisFlags_AutoFit,ImPlotAxisFlags_AutoFit);
        -- --         ImPlot::SetupAxisTicks(ImAxis_Y1,positions, groups, glabels);
        -- --         ImPlot::PlotBarGroups(ilabels,data,items,groups,size,0,flags|ImPlotBarGroupsFlags_Horizontal);
        -- --     }
        -- --     else {
        -- --         ImPlot::SetupAxes("Student","Score",ImPlotAxisFlags_AutoFit,ImPlotAxisFlags_AutoFit);
        -- --         ImPlot::SetupAxisTicks(ImAxis_X1,positions, groups, glabels);
        -- --         ImPlot::PlotBarGroups(ilabels,data,items,groups,size,0,flags);
        -- --     }
        -- --     ImPlot::EndPlot();
        -- -- }
        -- TODO: Remove this before merging


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
        imGui.SetNextWindowPos(getMenuBarPosition(self.menuBarPosition))
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
                    if imGui.MenuItem("Player List", self.shortcuts.playerList) then
                        self.showPlayerList = not self.showPlayerList
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
                local isServerPortChanged, serverPort = imGui.InputTextWithHint("Server Port", "Use '1 - 65535'!", tostring(Client:getPort()))
                if isServerPortChanged then
                    Client.port = serverPort
                end

                imGui.Separator()
                if imGui.Button("Join Server..") then
                    Client.connect(serverIp, serverPort)
                    self.showPlayMenu = false
                end
            end
            imGui.End()
        end

        CustomProfiler.stop("Gui.drawPlayMenu", cpc)
    end

    local base = 1
    local showSettingsSavedTimer = 10
    local oldMina = nil
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
            -- store previous Mina settings for being able using multiple instances locally
            if Utils.IsEmpty(oldMina) then
                oldMina = MinaUtils.getLocalMinaInformation()
            end

            if self.showMissingSettings then
                imGui.PushStyleColor(imGui.Col.Text, 255, 0, 0)
                imGui.Text("Some of the 'Mandatory' settings are missing!\n Please set them first and *restart* your run! \n Thanks <3")
                imGui.PopStyleColor()
            end

            -- Basic settings
            imGui.Text("Mandatory:")

            -- Player name
            local isPlayerNameChanged, playerName = imGui.InputTextWithHint("Nickname", "Type in your Nickname!", MinaUtils.getLocalMinaName())
            if isPlayerNameChanged then
                MinaUtils.setLocalMinaName(playerName)
            end
            -- Guid
            imGui.LabelText("Guid", MinaUtils.getLocalMinaGuid())

            -- Gui settings
            imGui.Separator()
            imGui.Text("Graphical user interface:")
            if imGui.BeginCombo("Position of 'NoitaMP' user interface", self.menuBarPosition) then
                if imGui.Selectable("Top left", self.menuBarPosition == "top-left") then
                    self.menuBarPosition = "top-left"
                    NoitaMpSettings.set("noita-mp.gui.position", self.menuBarPosition)
                end
                if imGui.Selectable("Top right", self.menuBarPosition == "top-right") then
                    self.menuBarPosition = "top-right"
                    NoitaMpSettings.set("noita-mp.gui.position", self.menuBarPosition)
                end
                if imGui.Selectable("Bottom left", self.menuBarPosition == "bottom-left") then
                    self.menuBarPosition = "bottom-left"
                    NoitaMpSettings.set("noita-mp.gui.position", self.menuBarPosition)
                end
                if imGui.Selectable("Bottom right", self.menuBarPosition == "bottom-right") then
                    self.menuBarPosition = "bottom-right"
                    NoitaMpSettings.set("noita-mp.gui.position", self.menuBarPosition)
                end
                imGui.EndCombo()
            end

            -- Logger settings
            imGui.Separator()
            imGui.Text("Logger:")

            -- Advanced settings
            imGui.Separator()
            imGui.Text("Advanced:")

            -- Entity detection radius
            local sliderFlags = bit.bor(
                imGui.SliderFlags.AlwaysClamp,
                imGui.SliderFlags.Logarithmic,
                imGui.SliderFlags.NoRoundToFormat
            )
            local isEntityDetectionRadiusChanged, entityDetectionRadius = imGui.SliderInt("Entity detection radius",
                NoitaMpSettings.get("noita-mp.entity-detection-radius", "number"), 350, 1024, "%d", sliderFlags);
            imGui.SameLine()
            tooltipHelper("'CTRL + Click' to input value.");
            if isEntityDetectionRadiusChanged then
                NoitaMpSettings.set("noita-mp.entity-detection-radius", entityDetectionRadius)
            end
            -- Tick rate
            local tickRate = NoitaMpSettings.get("noita-mp.tick-rate", "number")
            local isTickRateChanged, _base = imGui.SliderInt("Tick rate", base, 1, 8, "%d", sliderFlags);
            if isTickRateChanged then
                base = _base
                tickRate = math.pow(2, base - 1) -- https://www.wolframalpha.com/input?i2d=true&i=Power%5B2%2Cn-1%5D
                NoitaMpSettings.set("noita-mp.tick-rate", tickRate)
            end
            imGui.SameLine()
            imGui.Text(("= %s"):format(tickRate))
            imGui.SameLine()
            tooltipHelper("'CTRL + Click' to input value.");

            -- Save settings
            if imGui.Button("Save Settings") then
                if NoitaMpSettings.isMoreThanOneNoitaProcessRunning() then
                    local newGuid = GuidUtils:getGuid({ MinaUtils.getLocalMinaGuid() })
                    MinaUtils.setLocalMinaGuid(newGuid)
                end

                NoitaMpSettings.save()

                if not Utils.IsEmpty(MinaUtils.getLocalMinaName()) and not Utils.IsEmpty(MinaUtils.getLocalMinaGuid()) then
                    guiI.setShowMissingSettings(false)
                end

                local x, y = EntityGetTransform(MinaUtils.getLocalMinaEntityId())
                local entityIds = EntityGetInRadius(x, y, 2048) or {}
                for i = 1, #entityIds do
                    local componentIds = EntityGetComponentIncludingDisabled(entityIds[i], NetworkVscUtils.variableStorageComponentName) or {}
                    for i = 1, #componentIds do
                        local name = ComponentGetValue(componentIds[i], "name")
                        if name == NetworkVscUtils.componentNameOfOwnersName then
                            local value = ComponentGetValue2(componentIds[i], "value_string")
                            if value == oldMina.name then
                                ComponentSetValue2(componentIds[i], "value_string", MinaUtils.getLocalMinaName())
                            end
                        end
                        if name == NetworkVscUtils.componentNameOfOwnersGuid then
                            local value = ComponentGetValue2(componentIds[i], "value_string")
                            if value == oldMina.guid then
                                ComponentSetValue2(componentIds[i], "value_string", MinaUtils.getLocalMinaGuid())
                            end
                        end
                    end
                end

                NetworkVscUtils.addOrUpdateAllVscs(MinaUtils.getLocalMinaEntityId(), MinaUtils.getLocalMinaName(), MinaUtils.getLocalMinaGuid(),
                    MinaUtils.getLocalMinaNuid())

                GlobalsUtils.setUpdateGui(true)
            end
            if self.showSettingsSaved then
                imGui.SameLine()
                imGui.Text(("Saved into '%s'!"):format(FileUtils.GetRelativePathOfNoitaMpSettingsDirectory()))
                if GameGetRealWorldTimeSinceStarted() >= showSettingsSavedTimer + 10 then
                    self.showSettingsSaved = false
                    showSettingsSavedTimer = GameGetRealWorldTimeSinceStarted()
                end
            end
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

    function self.drawPlayerList()
        local cpc = CustomProfiler.start("Gui.drawPlayerList")

        local windowFlags = bit.bor(
        -- imGui.WindowFlags.MenuBar,
        -- imGui.WindowFlags.NoDocking,
        -- imGui.WindowFlags.NoSavedSettings,
        -- imGui.WindowFlags.NoFocusOnAppearing,
        -- imGui.WindowFlags.NoMove,
        -- imGui.WindowFlags.NoDecoration,
            imGui.WindowFlags.NoBackground,
            imGui.WindowFlags.AlwaysAutoResize
        )

        -- imGui.SetNextWindowViewport(imGui.GetMainViewportID())
        -- imGui.SetNextWindowPos(getMenuBarPosition())
        -- imGui.SetNextWindowSize(0, 0)

        local isCollapsed
        isCollapsed, self.showPlayerList = imGui.Begin(self.playerListLabel, self.showPlayerList, windowFlags)
        if isCollapsed then
            imGui.Text("NoitaMP is a multiplayer mod for Noita.")

            local tableFlags = bit.bor(
                imGui.TableFlags.Resizable,
                --     --imGui.TableFlags.ScrollY,
                --     imGui.TableFlags.Sortable,
                --     imGui.TableFlags.ContextMenuInBody,
                --     --imGui.TableFlags.RowBg,
                imGui.TableFlags.Borders
            )

            local minas = MinaUtils.getAllMinas()
            if imGui.BeginTable("PlayerList", #minas, tableFlags) then
                for i, mina in pairs(minas) do
                    --for headerName, value in pairs(mina) do
                    imGui.TableNextRow()
                    imGui.TableNextColumn()
                    imGui.Text(("%s"):format(mina.name))
                    imGui.TableNextColumn()
                    imGui.Text(("%s"):format(mina.guid))
                    imGui.TableNextColumn()
                    imGui.Text(("%s"):format(mina.nuid))
                    --end
                end
                imGui.EndTable()
            end

            imGui.End()
        end

        CustomProfiler.stop("Gui.drawPlayerList", cpc)
    end

    function self.checkShortcuts()
        local cpc = CustomProfiler.start("Gui.checkShortcuts")

        if imGui.IsKeyDown(imGui.Key.LeftShift) then
            -- make sure that there are no ComponentExplorer shortcut conflicts
            return
        end

        if not imGui.IsKeyDown(imGui.Key.LeftCtrl) then
            return
        end

        if not imGui.IsKeyDown(imGui.Key.LeftAlt) then
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

        if imGui.IsKeyPressed(imGui.Key.L) then
            self.showPlayerList = not self.showPlayerList
        end

        CustomProfiler.stop("Gui.checkShortcuts", cpc)
    end

    CustomProfiler.stop("Gui.new", cpc)
    return self
end

return Gui
