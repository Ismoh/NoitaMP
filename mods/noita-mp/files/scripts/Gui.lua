---Everything regarding ImGui: Credits to @dextercd
--- @class Gui
local Gui = {
    --[[ Attributes ]]

    aboutLabel = "NoitaMp - About",
    entityDetectionRadius = nil,
    firstTime = true,
    menuBarLabel = "NoitaMP",
    menuBarPosition = "top-left",
    ---Can't know the width before creating the window.. Just an initial value, it's updated to the real value once we can call imgui.GetWindowWidth()
    menuBarWidth = 100,
    playerListIsBorder = nil,
    playerListIsClickable = nil,
    playerListLabel = "NoitaMp - Player List",
    playerListTransparency = nil,
    playLabel = "NoitaMp - Play",
    settingsLabel = "NoitaMp - Settings",
    shortcuts = {
        about      = "CTRL + ALT + A",
        bugReport  = "CTRL + ALT + B",
        playerList = "CTRL + ALT + L",
        play       = "CTRL + ALT + P",
        settings   = "CTRL + ALT + S",
    },
    showAbout = false,
    showFirstTime = true,
    showMissingSettings = false,
    showPlayerList = false,
    showPlayMenu = false,
    showSettings = false,
    showSettingsSaved = false,
    showSettingsSavedTimer = 10,
}

if not load_imgui then
    function OnWorldInitialized()
        local noitaMpSettings = require("NoitaMpSettings")
            :new(nil, nil, {}, nil, nil, nil, nil, nil, nil)
        local fileUtils = noitaMpSettings.fileUtils or require("FileUtils")
            :new(nil, nil, nil, noitaMpSettings, nil, nil)

        local defaultFile = "mods/component-explorer/entities/imgui_warning.xml"
        if not fileUtils:Exists(defaultFile) then
            defaultFile = "mods/noita-mp/files/data/entities/imgui_warning.xml"
        end
        EntityLoad(defaultFile, 0, 0)
    end

    error("Missing ImGui.", 2)
end

---comment
---@private
---@param self Gui
---@param position string "bottom-left" | "bottom-right" | "top-left" | "top-right"
---@return unknown
---@return unknown
local getMenuBarPosition = function(self, position)
    local cpc = self.customProfiler:start("Gui.getMenuBarPosition")

    local menuBarHeight = self.imGui.GetFontSize() + 2 * self.imGui.GetStyle().FramePadding_y

    -- Available space
    local aw, ah = self.imGui.GetMainViewportSize()
    aw = aw - self.menuBarWidth
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

    local vx, vy = self.imGui.GetMainViewportWorkPos()

    self.customProfiler:stop("Gui.getMenuBarPosition", cpc)
    return vx + aw * rx - 2, vy + ah * ry + 20
end

---Creates a simple tooltip for the previous gui element.
---@private
---@param self Gui Gui ojbect, most cases 'self'
---@param tooltip string Tooltip text
local tooltipHelper = function(self, tooltip)
    local cpc = self.customProfiler:start("Gui.tooltipHelper")

    if not self.utils:isEmpty(tooltip) then
        self.imGui.SameLine()
        self.imGui.TextDisabled("(?)")
        if self.imGui.IsItemHovered() then
            self.imGui.BeginTooltip()
            self.imGui.PushTextWrapPos(self.imGui.GetFontSize() * 35.0)
            self.imGui.TextUnformatted(tooltip)
            self.imGui.PopTextWrapPos()
            self.imGui.EndTooltip()
        end
    end

    self.customProfiler:stop("Gui.tooltipHelper", cpc)
end

---Setter for the 'showSettingsSaved' attribute to show the user that the settings were saved.
---@param show boolean
function Gui:setShowSettingsSaved(show)
    self.showSettingsSaved = show
    if show then
        self.showSettingsSavedTimer = GameGetRealWorldTimeSinceStarted()
    end
end

---Setter for the 'showMissingSettings' attribute to show the user that the settings are missing.
---@param show boolean
function Gui:setShowMissingSettings(show)
    self.showMissingSettings = show
end

---Guis update function, called every frame.
function Gui:update()
    local cpcUpdate = self.customProfiler:start("Gui.update")

    self:checkShortcuts()
    self:drawMenuBar()

    if self.firstTime then
        self:drawFirstTime()
    end

    if self.showPlayMenu then
        self:drawPlayMenu()
    else
        if not self.server:isRunning() then
            self.isServer = nil
        end
    end

    if self.showSettings or self.showMissingSettings then
        self:drawSettings()
    end

    if self.showAbout then
        self:drawAbout()
    end

    if self.showPlayerList then
        self:drawPlayerList()
    end

    -- TODO: Remove this before merging
    -- local imPlot = self.imGui.implot
    -- self.imGui.SetNextWindowSize(800, 400, self.imGui.Cond.Once)
    -- if self.imGui.Begin("Enemy Tracker") then
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
    --     self.imGui.End()
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

    self.customProfiler:stop("Gui.update", cpcUpdate)
end

---Function to draw the menu bar.
function Gui:drawMenuBar()
    local cpcDrawMenuBar = self.customProfiler:start("Gui.drawMenuBar")

    local windowFlags = bit.bor(
        self.imGui.WindowFlags.MenuBar,
        self.imGui.WindowFlags.NoDocking,
        self.imGui.WindowFlags.NoSavedSettings,
        self.imGui.WindowFlags.NoFocusOnAppearing,
        self.imGui.WindowFlags.NoMove,
        self.imGui.WindowFlags.NoDecoration,
        self.imGui.WindowFlags.NoBackground,
        self.imGui.WindowFlags.AlwaysAutoResize
    )

    self.imGui.SetNextWindowViewport(self.imGui.GetMainViewportID())
    self.imGui.SetNextWindowPos(getMenuBarPosition(self, self.menuBarPosition))
    self.imGui.SetNextWindowSize(0, 0)

    if self.imGui.Begin(self.menuBarLabel, nil, windowFlags) then
        tooltipHelper(self, ("CheatGui hidden? Press '%s'!"):format(self.shortcuts.settings))

        -- Save actual window width for next positioning
        self.menuBarWidth = self.imGui.GetWindowWidth()

        if self.imGui.BeginMenuBar() then
            if self.imGui.BeginMenu(self.menuBarLabel) then
                if self.imGui.MenuItem("Play!", self.shortcuts.play) then
                    self.showPlayMenu = not self.showPlayMenu
                end
                if self.imGui.MenuItem("Player List", self.shortcuts.playerList) then
                    self.showPlayerList = not self.showPlayerList
                end
                if self.imGui.MenuItem("Settings", self.shortcuts.settings) then
                    self.showSettings = not self.showSettings
                end
                if self.imGui.MenuItem("About", self.shortcuts.about) then
                    self.showAbout = not self.showAbout
                end
                self.imGui.Separator()
                if self.imGui.MenuItem("Found a bug?", self.shortcuts.bugReport) then
                    self.utils:openUrl("https://github.com/Ismoh/NoitaMP/issues/new/choose")
                end
                self.imGui.EndMenu()
            end
            self.imGui.EndMenuBar()
        end
        self.imGui.End()
    end
    self.customProfiler:stop("Gui.drawMenuBar", cpcDrawMenuBar)
end

---Function to draw the first time window.
function Gui:drawFirstTime()
    local cpc = self.customProfiler:start("Gui.drawFirstTime")

    local windowFlags = --bit.bor(
    -- self.imGui.WindowFlags.MenuBar,
    -- self.imGui.WindowFlags.NoDocking,
    -- self.imGui.WindowFlags.NoSavedSettings,
    -- self.imGui.WindowFlags.NoFocusOnAppearing,
    -- self.imGui.WindowFlags.NoMove,
    -- self.imGui.WindowFlags.NoDecoration,
    -- self.imGui.WindowFlags.NoBackground
        self.imGui.WindowFlags.AlwaysAutoResize
    --)

    local isCollapsed
    isCollapsed, self.showFirstTime = self.imGui.Begin("Welcome to NoitaMP!", self.showFirstTime, windowFlags)
    if isCollapsed then
        self.imGui.Text("This is the first time you're using NoitaMP, please set your name and press 'Let's go!'")
        self.imGui.End()
    end

    self.customProfiler:stop("Gui.drawFirstTime", cpc)
end

---Function to draw the play menu.
function Gui:drawPlayMenu()
    local cpc = self.customProfiler:start("Gui.drawPlayMenu")

    local windowFlags = --bit.bor(
    -- self.imGui.WindowFlags.MenuBar,
    -- self.imGui.WindowFlags.NoDocking,
    -- self.imGui.WindowFlags.NoSavedSettings,
    -- self.imGui.WindowFlags.NoFocusOnAppearing,
    -- self.imGui.WindowFlags.NoMove,
    -- self.imGui.WindowFlags.NoDecoration,
    -- self.imGui.WindowFlags.NoBackground
        self.imGui.WindowFlags.AlwaysAutoResize
    --)

    local isCollapsed
    isCollapsed, self.showPlayMenu = self.imGui.Begin(self.playLabel, self.showPlayMenu, windowFlags)
    if isCollapsed then
        if self.utils:isEmpty(self.minaUtils.getLocalMinaName()) then
            self.imGui.Text(("Please set your name in the settings first! Simply press '%s'!"):format(self.shortcuts.settings))
            self.imGui.End()
            self.customProfiler:stop("Gui.drawPlayMenu", cpc)
            return
        end

        if self.utils:isEmpty(self.isServer) then
            self.imGui.Text("Do you want to host or join a server?")
            self.imGui.Separator()
            if self.imGui.SmallButton("Host!") then
                self.isServer = true
            end
            self.imGui.SameLine()
            if self.imGui.SmallButton("Join..") then
                self.isServer = false
            end
            self.imGui.End()
            self.customProfiler:stop("Gui.drawPlayMenu", cpc)
            return
        end

        if self.isServer then
            local serverIpText = self.server:getAddress()
            if StreamingGetIsConnected() then
                serverIpText = "Hidden Server IP, because streaming is enabled!"
            end

            self.imGui.LabelText("Server IP:", serverIpText)
            self.imGui.SameLine()
            if self.imGui.SmallButton("Copy IP to clipboard!") then
                self.imGui.SetClipboardText(self.server:getAddress())
            end

            local isPortChanged, port = self.imGui.InputTextWithHint("Server Port", "Type from 1 to max of 65535!", tostring(self.server:getPort()))
            if isPortChanged then
                self.server.port = port
            end

            self.imGui.Separator()
            if self.imGui.Button("Start Server!") then
                self.server.start(self.server:getAddress(), self.server:getPort())
                self.showPlayMenu = false
            end
        else
            local isServerIpChanged, serverIp = self.imGui.InputTextWithHint("Server IP", "Use '*', 'localhost' or 'whatismyip.com'!",
                Server:getAddress())
            if isServerIpChanged then
                self.server.address = serverIp
            end
            local isServerPortChanged, serverPort = self.imGui.InputTextWithHint("Server Port", "Use '1 - 65535'!", tostring(self.client:getPort()))
            if isServerPortChanged then
                self.client.port = serverPort
            end

            self.imGui.Separator()
            if self.imGui.Button("Join self.server..") then
                self.client:connect(serverIp, tonumber(serverPort))
                self.showPlayMenu = false
            end
        end
        self.imGui.End()
    end

    self.customProfiler:stop("Gui.drawPlayMenu", cpc)
end

local base = 1
local oldMina = nil

---Function to draw the settings window.
function Gui:drawSettings()
    local cpc = self.customProfiler:start("Gui.drawSettings")

    local windowFlags = --bit.bor(
    -- self.imGui.WindowFlags.MenuBar,
    -- self.imGui.WindowFlags.NoDocking,
    -- self.imGui.WindowFlags.NoSavedSettings,
    -- self.imGui.WindowFlags.NoFocusOnAppearing,
    -- self.imGui.WindowFlags.NoMove,
    -- self.imGui.WindowFlags.NoDecoration,
    -- self.imGui.WindowFlags.NoBackground
        self.imGui.WindowFlags.AlwaysAutoResize
    --)

    local isCollapsed
    isCollapsed, self.showSettings = self.imGui.Begin(self.settingsLabel, self.showSettings, windowFlags)
    if isCollapsed then
        -- store previous Mina settings for being able using multiple instances locally
        if self.utils:isEmpty(oldMina) then
            oldMina = {}
            oldMina.entityId = self.minaUtils:getLocalMinaEntityId()
            oldMina.guid = self.minaUtils:getLocalMinaGuid()
            oldMina.name = self.minaUtils:getLocalMinaName()
            oldMina.nuid = self.minaUtils:getLocalMinaNuid()
        end

        if self.showMissingSettings then
            self.imGui.PushStyleColor(self.imGui.Col.Text, 255, 0, 0)
            self.imGui.Text("Some of the 'Mandatory' settings are missing!\n Please set them first and *restart* your run! \n Thanks <3")
            self.imGui.PopStyleColor()
        end

        -- Basic settings
        self.imGui.Text("Mandatory:")

        -- Player name
        local isPlayerNameChanged, playerName = self.imGui.InputTextWithHint("Nickname", "Type in your Nickname!", self.minaUtils.getLocalMinaName())
        if isPlayerNameChanged then
            self.minaUtils:setLocalMinaName(playerName)
        end
        -- Guid
        self.imGui.LabelText("Guid", self.minaUtils:getLocalMinaGuid())

        -- Gui settings
        self.imGui.Separator()
        self.imGui.Text("Graphical user interface:")
        if self.imGui.BeginCombo("Position of 'NoitaMP' user interface", self.menuBarPosition) then
            if self.imGui.Selectable("Top left", self.menuBarPosition == "top-left") then
                self.menuBarPosition = "top-left"
                self.noitaMpSettings:set("noita-mp.gui.position", self.menuBarPosition)
            end
            if self.imGui.Selectable("Top right", self.menuBarPosition == "top-right") then
                self.menuBarPosition = "top-right"
                self.noitaMpSettings:set("noita-mp.gui.position", self.menuBarPosition)
            end
            if self.imGui.Selectable("Bottom left", self.menuBarPosition == "bottom-left") then
                self.menuBarPosition = "bottom-left"
                self.noitaMpSettings:set("noita-mp.gui.position", self.menuBarPosition)
            end
            if self.imGui.Selectable("Bottom right", self.menuBarPosition == "bottom-right") then
                self.menuBarPosition = "bottom-right"
                self.noitaMpSettings:set("noita-mp.gui.position", self.menuBarPosition)
            end
            self.imGui.EndCombo()
        end
        local isPlayerListBorderChanged, isBorderValue = self.imGui.Checkbox("Player list border", self.playerListIsBorder)
        if isPlayerListBorderChanged then
            self.noitaMpSettings:set("noita-mp.gui.player-list.border", isBorderValue)
            self.playerListIsBorder = isBorderValue
        end

        local sliderFlagsPlayerList =          --bit.bor(
            self.imGui.SliderFlags.AlwaysClamp --,
        --)
        local isPlayerListTransparencyChanged, transparency = self.imGui.SliderFloat("Player list transparency",
            self.playerListTransparency, 0, 1, "%.2f", sliderFlagsPlayerList);
        if isPlayerListTransparencyChanged then
            self.noitaMpSettings:set("noita-mp.gui.player-list.background-alpha", transparency)
            self.playerListTransparency = transparency
        end

        local isPlayerListClickableChanged, isClickableValue = self.imGui.Checkbox("Player list clickable",
            self.noitaMpSettings:get("noita-mp.gui.player-list.clickable", "boolean"))
        if isPlayerListClickableChanged then
            self.noitaMpSettings:set("noita-mp.gui.player-list.clickable", isClickableValue)
            self.playerListIsClickable = isClickableValue
        end

        -- Logger settings
        self.imGui.Separator()
        self.imGui.Text("Logger:")

        -- Advanced settings
        self.imGui.Separator()
        self.imGui.Text("Advanced:")

        -- Entity detection radius
        local sliderFlags = bit.bor(
            self.imGui.SliderFlags.AlwaysClamp,
            self.imGui.SliderFlags.Logarithmic,
            self.imGui.SliderFlags.NoRoundToFormat
        )
        local isEntityDetectionRadiusChanged, entityDetectionRadius = self.imGui.SliderInt("Entity detection radius",
            self.entityDetectionRadius, 350, 1024, "%d", sliderFlags);
        self.imGui.SameLine()
        tooltipHelper(self, "'CTRL + Click' to input value.");
        if isEntityDetectionRadiusChanged then
            self.noitaMpSettings:set("noita-mp.entity-detection-radius", entityDetectionRadius)
            self.entityDetectionRadius = entityDetectionRadius
        end
        -- Tick rate
        local tickRate = self.noitaMpSettings:get("noita-mp.tick-rate", "number")
        local isTickRateChanged, _base = self.imGui.SliderInt("Tick rate", base, 1, 8, "%d", sliderFlags);
        if isTickRateChanged then
            base = _base
            tickRate = math.pow(2, base - 1) -- https://www.wolframalpha.com/input?i2d=true&i=Power%5B2%2Cn-1%5D
            self.noitaMpSettings:set("noita-mp.tick-rate", tickRate)
        end
        self.imGui.SameLine()
        self.imGui.Text(("= %s"):format(tickRate))
        self.imGui.SameLine()
        tooltipHelper(self, "'CTRL + Click' to input value.");

        -- Save settings
        if self.imGui.Button("Save Settings") then
            if self.noitaMpSettings:isMoreThanOneNoitaProcessRunning() then
                local newGuid = self.guidUtils:generateNewGuid({ self.minaUtils.getLocalMinaGuid() })
                self.minaUtils.setLocalMinaGuid(newGuid)
            end

            self.noitaMpSettings:save()

            if not self.utils:isEmpty(self.minaUtils:getLocalMinaName()) and not self.utils:isEmpty(self.minaUtils:getLocalMinaGuid()) then
                self:setShowMissingSettings(false)
            end

            local x, y = EntityGetTransform(self.minaUtils:getLocalMinaEntityId())
            local entityIds = EntityGetInRadius(x, y, 2048) or {}
            for i = 1, #entityIds do
                local componentIds = EntityGetComponentIncludingDisabled(entityIds[i],
                    self.networkVscUtils.variableStorageComponentName) or {}
                for i = 1, #componentIds do
                    local name = ComponentGetValue(componentIds[i], "name")
                    if name == self.networkVscUtils.componentNameOfOwnersName then
                        local value = ComponentGetValue2(componentIds[i], "value_string")
                        if oldMina and value == oldMina.name then
                            ComponentSetValue2(componentIds[i], "value_string", self.minaUtils:getLocalMinaName())
                        end
                    end
                    if name == self.networkVscUtils.componentNameOfOwnersGuid then
                        local value = ComponentGetValue2(componentIds[i], "value_string")
                        if oldMina and value == oldMina.guid then
                            ComponentSetValue2(componentIds[i], "value_string", self.minaUtils:getLocalMinaGuid())
                        end
                    end
                end
            end

            self.networkVscUtils.addOrUpdateAllVscs(self.minaUtils:getLocalMinaEntityId(), self.minaUtils:getLocalMinaName(),
                self.minaUtils:getLocalMinaGuid(), self.minaUtils:getLocalMinaNuid())

            self.globalsUtils.setUpdateGui(true)
        end
        if self.showSettingsSaved then
            self.imGui.SameLine()
            self.imGui.Text(("Saved into '%s'!"):format(self.fileUtils:GetRelativePathOfNoitaMpSettingsDirectory()))
            if GameGetRealWorldTimeSinceStarted() >= self.showSettingsSavedTimer + 10 then
                self.showSettingsSaved = false
                self.showSettingsSavedTimer = GameGetRealWorldTimeSinceStarted()
            end
        end
        self.imGui.End()
    end

    self.customProfiler:stop("Gui.drawSettings", cpc)
end

---Function for drawing the about window.
function Gui:drawAbout()
    local cpc = self.customProfiler:start("Gui.drawAbout")

    local windowFlags = --bit.bor(
    -- self.imGui.WindowFlags.MenuBar,
    -- self.imGui.WindowFlags.NoDocking,
    -- self.imGui.WindowFlags.NoSavedSettings,
    -- self.imGui.WindowFlags.NoFocusOnAppearing,
    -- self.imGui.WindowFlags.NoMove,
    -- self.imGui.WindowFlags.NoDecoration,
    -- self.imGui.WindowFlags.NoBackground
        self.imGui.WindowFlags.AlwaysAutoResize
    --)

    -- self.imGui.SetNextWindowViewport(self.imGui.GetMainViewportID())
    -- self.imGui.SetNextWindowPos(getMenuBarPosition())
    -- self.imGui.SetNextWindowSize(0, 0)

    local isCollapsed
    isCollapsed, self.showAbout = self.imGui.Begin(self.aboutLabel, self.showAbout, windowFlags)
    if isCollapsed then
        self.imGui.Text("NoitaMP is a multiplayer mod for Noita.")
        self.imGui.Text("It's currently in early development, so expect bugs and crashes.")
        self.imGui.Text("If you find any bugs, please report them on the GitHub page. Just press on 'Found a bug?' in the menu bar or press " ..
            self.shortcuts.bugReport .. ".")

        self.imGui.Separator()
        self.imGui.Text("NoitaMP - Noita Multiplayer version " .. self.fileUtils:GetVersionByFile())
        self.imGui.Text("Made by Ismoh#0815 and many other awesome contributers!")
        self.imGui.Text("Homepage: https://github.com/Ismoh/NoitaMP")
        self.imGui.SameLine()
        if self.imGui.SmallButton("Open in Browser") then
            self.utils:openUrl("https://github.com/Ismoh/NoitaMP")
        end
        self.imGui.Text("Join 'Ismoh Games' Discord server!")
        self.imGui.SameLine()
        if self.imGui.SmallButton("Open in Browser") then
            self.utils:openUrl("https://discord.gg/DhMurdcw4k")
        end

        self.imGui.Separator()
        self.imGui.Text("If you want to help with the development, you can find the source code on GitHub.")
        self.imGui.Text("If you want to chat with other players, you can join the Discord server.")
        self.imGui.Text("If you want to support the development, you can donate on Patreon.")
        self.imGui.Text("If you want to contact me, you can find my contact info on GitHub.")

        self.imGui.End()
    end

    self.customProfiler:stop("Gui.drawAbout", cpc)
end

---Function for drawing the player list window.
function Gui:drawPlayerList()
    local cpc = self.customProfiler:start("Gui.drawPlayerList")

    local windowFlags = 0 --bit.bor(
    -- self.imGui.WindowFlags.MenuBar,
    -- self.imGui.WindowFlags.NoDocking,
    -- self.imGui.WindowFlags.NoSavedSettings,
    -- self.imGui.WindowFlags.NoFocusOnAppearing,
    -- self.imGui.WindowFlags.NoMove,
    -- self.imGui.WindowFlags.NoDecoration,
    --    self.imGui.WindowFlags.NoBackground --,
    -- self.imGui.WindowFlags.AlwaysAutoResize
    --)

    -- self.imGui.SetNextWindowViewport(self.imGui.GetMainViewportID())
    -- self.imGui.SetNextWindowPos(getMenuBarPosition())
    -- self.imGui.SetNextWindowSize(0, 0)

    local isCollapsed
    if self.playerListBorder == true then --self.noitaMpSettings:get("noita-mp.gui.player-list.border", "boolean") == true then
        self.imGui.PushStyleVar(self.imGui.StyleVar.WindowBorderSize, 1)
    else
        self.imGui.PushStyleVar(self.imGui.StyleVar.WindowBorderSize, 0)
        windowFlags = bit.bor(windowFlags, self.imGui.WindowFlags.NoDecoration, self.imGui.WindowFlags.NoTitleBar, self.imGui.WindowFlags.NoNav)
    end
    self.imGui.SetNextWindowBgAlpha(self.playerListTransparency)
    isCollapsed, self.showPlayerList = self.imGui.Begin(self.playerListLabel, self.showPlayerList, windowFlags)
    self.imGui.PopStyleVar()
    if isCollapsed then
        self.imGui.Text("NoitaMP is a multiplayer mod for Noita.")

        local tableFlags = bit.bor(
            self.imGui.TableFlags.Resizable,
            --     --self.imGui.TableFlags.ScrollY,
            --     self.imGui.TableFlags.Sortable,
            --     self.imGui.TableFlags.ContextMenuInBody,
            --     --self.imGui.TableFlags.RowBg,
            self.imGui.TableFlags.Borders
        )

        local minas = self.minaUtils:getAllMinas()
        local columnCount = function()
            local count = 0
            for _ in pairs(minas[1]) do
                count = count + 1
            end
            return count
        end
        if self.imGui.BeginTable("PlayerList", columnCount(), tableFlags) then
            -- Set headers
            self.imGui.TableNextRow()
            local columnIndex = 0
            for headerName, value in pairs(minas[1]) do
                self.imGui.TableSetColumnIndex(columnIndex)
                self.imGui.TableHeader(("%s"):format(headerName))
                columnIndex = columnIndex + 1
            end

            -- Set values
            for rowIndex, mina in pairs(minas) do
                self.imGui.TableNextRow()
                columnIndex = 0
                for headerName, value in pairs(mina) do
                    self.imGui.TableSetColumnIndex(columnIndex)
                    self.imGui.Text(("%s"):format(value))
                    columnIndex = columnIndex + 1
                end
            end
            self.imGui.EndTable()
        end

        self.imGui.End()
    end

    self.customProfiler:stop("Gui.drawPlayerList", cpc)
end

---Function to check if the user pressed a shortcut.
function Gui:checkShortcuts()
    local cpc = self.customProfiler:start("Gui.checkShortcuts")

    if self.imGui.IsKeyDown(self.imGui.Key.LeftShift) then
        -- make sure that there are no ComponentExplorer shortcut conflicts
        return
    end

    if not self.imGui.IsKeyDown(self.imGui.Key.LeftCtrl) then
        return
    end

    if not self.imGui.IsKeyDown(self.imGui.Key.LeftAlt) then
        return
    end

    if self.imGui.IsKeyPressed(self.imGui.Key.A) then
        self.showAbout = not self.showAbout
    end

    if self.imGui.IsKeyPressed(self.imGui.Key.B) then
        self.utils:openUrl("https://github.com/Ismoh/NoitaMP/issues/new/choose")
    end

    if self.imGui.IsKeyPressed(self.imGui.Key.P) then
        self.showPlayMenu = not self.showPlayMenu
    end

    if self.imGui.IsKeyPressed(self.imGui.Key.S) then
        self.showSettings = not self.showSettings
    end

    if self.imGui.IsKeyPressed(self.imGui.Key.L) then
        self.showPlayerList = not self.showPlayerList
    end

    self.customProfiler:stop("Gui.checkShortcuts", cpc)
end

---Gui constructor.
---@param guiObject Gui|nil optional
---@param server Server required
---@param client Client required
---@param customProfiler CustomProfiler|nil optional
---@param guidUtils GuidUtils|nil optional
---@param minaUtils MinaUtils|nil optional
---@param noitaMpSettings NoitaMpSettings|nil optional
---@return Gui
function Gui:new(guiObject, server, client, customProfiler, guidUtils, minaUtils, noitaMpSettings)
    ---@class Gui
    guiObject = setmetatable(guiObject or self, Gui)

    local cpc = server.customProfiler:start("Gui:new")

    --[[ Imports ]]
    -- Initialize all imports to avoid recursive imports

    if not guiObject.server then
        ---@type Server
        ---@see Server
        guiObject.server = server or error("Server is required!", 2)
    end

    if not guiObject.client then
        ---@type Client
        ---@see Client
        guiObject.client = client or error("Client is required!", 2)
    end

    if not guiObject.noitaMpSettings then
        ---@type NoitaMpSettings
        ---@see NoitaMpSettings
        guiObject.noitaMpSettings = noitaMpSettings or server.noitaMpSettings or require("NoitaMpSettings")
            :new(nil, customProfiler, self, nil, nil, nil, nil, nil, nil)
    end

    if not guiObject.customProfiler then
        ---@type CustomProfiler
        ---@see CustomProfiler
        guiObject.customProfiler = customProfiler or server.customProfiler or require("CustomProfiler")
            :new(nil, nil, server.noitaMpSettings, nil, nil, nil, nil)
    end

    if not guiObject.guidUtils then
        ---@type GuidUtils
        ---@see GuidUtils
        guiObject.guidUtils = guidUtils or require("GuidUtils")
            :new(nil, guiObject.customProfiler, server.fileUtils, server.logger, nil, nil,
                server.utils, nil)
    end

    if not guiObject.imGui then
        ---@type ImGui
        ---@see ImGui
        guiObject.imGui = load_imgui({ version = "1.11.0", mod = "noita-mp" })
    end

    if not guiObject.minaUtils then
        ---@type MinaUtils
        ---@see MinaUtils
        guiObject.minaUtils = minaUtils or require("MinaUtils")
            :new(nil, guiObject.customProfiler, server.noitaComponentUtils.globalsUtils, noitaMpSettings.logger,
                server.networkVscUtils, noitaMpSettings, noitaMpSettings.utils)
    end

    if not guiObject.utils then
        ---@type Utils
        ---@see Utils
        guiObject.utils = noitaMpSettings.utils or require("Utils")
        --:new()
    end

    --[[ Attributes ]]
    guiObject.entityDetectionRadius = guiObject.noitaMpSettings:get("noita-mp.entity-detection-radius", "number")
    guiObject.playerListIsBorder = guiObject.noitaMpSettings:get("noita-mp.gui.player-list.border", "boolean")
    guiObject.playerListIsClickable = guiObject.noitaMpSettings:get("noita-mp.gui.player-list.clickable", "boolean")
    guiObject.playerListTransparency = guiObject.noitaMpSettings:get("noita-mp.gui.player-list.background-alpha", "number")

    guiObject.customProfiler:stop("ExampleClass:new", cpc)
    return guiObject
end

return Gui
