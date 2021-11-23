--local server = dofile_once("mods/noita-mp/files/scripts/net/server.lua")
--local client = dofile_once("mods/noita-mp/files/scripts/net/client.lua")

if initialized == nil then initialized = false; end

if not initialized then
    print("initializing ui..")
    initialized = true
    local gui_id = 2
    local gui = gui or GuiCreate();

    local max_y = 100
    local bottom_y = 72

    local function reset_id()
        gui_id = 2
    end

    local function next_id()
        local id = gui_id
        gui_id = gui_id + 1
        return id
    end

    local screen_width, screen_height = GuiGetScreenDimensions(gui)


    function draw_gui()
        reset_id()
        GuiStartFrame(gui)

        GuiLayoutBeginHorizontal(gui, 10, bottom_y, false, 4, 4)

            GuiImage(gui, next_id(), 10, bottom_y, "data/ui_gfx/button_fold_open.png" , 1,1,1)
            GuiTooltip(gui, "", "")

            ------------ Start server
            if _G.Server == nil or next(_G.Server) == nil or _G.Server.super == nil or next(_G.Server.super) == nil then
                GuiColorSetForNextWidget(gui, 0, 1, 0, 1)
                if GuiButton(gui, next_id(), 15, bottom_y, "Start server!") then
                    _G.Server:create()
                end
                GuiTooltip(gui, "", "Will connect to " .. tostring(ModSettingGet("noita-mp.server_ip")) .. tostring(ModSettingGet("noita-mp.server_port")))
            else
            ------------ Stop server
                GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
                if GuiButton(gui, next_id(), 15, bottom_y, "Stop server!") then
                    _G.Server.super:destroy()
                end
            end

            ------------ Connect
            if _G.Client == nil or next(_G.Client) == nil or _G.Client.super:isDisconnected() and not _G.Client.super:isConnecting() then
                GuiColorSetForNextWidget(gui, 0, 1, 0, 1)
                if GuiButton(gui, next_id(), 15, bottom_y, "Connect!") then
                    _G.Client:connect()
                end
                GuiTooltip(gui, "", "Will connect to " .. tostring(ModSettingGet("noita-mp.connect_server_ip")) .. tostring(ModSettingGet("noita-mp.connect_server_port")))
            else
            ------------- Disconnect
                GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
                if GuiButton(gui, next_id(), 15, bottom_y, "Disconnect!") then
                    _G.Client:connect()
                end
            end

            if _G.Client ~= nil and next(_G.Client) ~= nil then
                local rtt = tonumber(_G.Client.super:getRoundTripTime())
                --GuiColorSetForNextWidget(gui, 1, 0, 0, 1) TODO rtt / ? = red
                GuiText(gui, 15, bottom_y,  rtt .. "ms")
            end

        GuiLayoutEnd(gui)
    end
end

draw_gui()