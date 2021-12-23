--local server = dofile_once("mods/noita-mp/files/scripts/net/server.lua")
--local client = dofile_once("mods/noita-mp/files/scripts/net/client.lua")
local fu = require("file_util")

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
        local server_ip = tostring(ModSettingGet("noita-mp.server_ip"))
        local server_port = tostring(ModSettingGet("noita-mp.server_port"))
        local connect_to_ip = tostring(ModSettingGet("noita-mp.connect_server_ip"))
        local connect_to_port = tostring(ModSettingGet("noita-mp.connect_server_port"))

        reset_id()
        GuiStartFrame(gui)

        ------------ ------------ Start server ui
        local x = 70
        local y = bottom_y
        GuiLayoutBeginHorizontal(gui, x, y, false, 5, 5)
            ------------ Start server
            if _G.Server == nil or next(_G.Server) == nil or _G.Server.super == nil or next(_G.Server.super) == nil then
                GuiColorSetForNextWidget(gui, 0, 1, 0, 1)
                if GuiButton(gui, next_id(), 0, 0, "Start server on " .. server_ip .. ":" .. server_port) then
                    _G.Server:create()
                end
            else
            ------------ Stop server
                GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
                if GuiButton(gui, next_id(), 0, 0, "Stop server on " .. server_ip .. ":" .. server_port) then
                    _G.Server:destroy()
                end
            end
        GuiLayoutEnd(gui)

        ------------ ------------ Connect to server ui
        x = x
        y = y + 3
        GuiLayoutBeginHorizontal(gui, x, y, false, 5, 5)
            ------------ Not allowed to connect to a server while your own server is running
            if _G.Server ~= nil and next(_G.Server) ~= nil and _G.Server.super ~= nil and next(_G.Server.super) ~= nil then
                GuiText(gui, 0, 0, "Not allowed to connect..")
                GuiTooltip(gui, "Not allowed to connect..", "Stop your server first, before connecting to another server. Thanks!")
            else
                ------------ Connect
                if _G.Client == nil or next(_G.Client) == nil or _G.Client.super:isDisconnected() and not _G.Client.super:isConnecting() then
                    GuiColorSetForNextWidget(gui, 0, 1, 0, 1)
                    if GuiButton(gui, next_id(), 0, 0, "Connect to " .. connect_to_ip .. ":" .. connect_to_port) then
                        _G.Client:connect()
                    end
                else
                ------------- Disconnect
                    GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
                    if GuiButton(gui, next_id(), 0, 0, "Disconnect from "  .. connect_to_ip .. ":" .. connect_to_port) then
                        _G.Client:disconnect()
                    end
                end
            end
        GuiLayoutEnd(gui)

        ------------ ------------ Player list header
        x = x
        y = y + 3
        GuiLayoutBeginHorizontal(gui, x, y, false, 5, 5)
            GuiText(gui, 0, 0, "Name")
            GuiText(gui, 5, 0, "Ping")
            GuiText(gui, 10, 0, "Map received")
            GuiText(gui, 15, 0, "Allow")
            GuiText(gui, 20, 0, "Kick")
        GuiLayoutEnd(gui)

        ------------ ------------ Player list content
        x = x
        y = y + 3
        GuiLayoutBeginHorizontal(gui, x, y, false, 5, 5)
            ------------- Player list when server
            if _G.Server ~= nil and next(_G.Server) ~= nil and _G.Server.super ~= nil and next(_G.Server.super) ~= nil then
                for i, client in pairs(_G.Server.super:getClients()) do
                    i = (i - 1) * 3 -- 1-1*5=0 | 2-1*5=5 | 3-1*5=10
                    GuiText(gui, 0,i, client.username)
                    GuiText(gui, 5,i, client:getRoundTripTime() .. "ms")
                    GuiImage(gui, next_id(), 10, i, "mods/noita-mp/files/data/ui/green_tik_8x8.png" , 1,1,1)
                    -- Allow Button
                    if GuiImageButton(gui, next_id(), 15, i, "", "mods/noita-mp/files/data/ui/green_tik_8x8.png") then
                        if _G.Server:checkIsAllowed(client) then
                            -- Send map, if already allowed to join
                            _G.Server:sendMap(client)
                        else
                            -- Save map and restart, if not already allowed and set allowed to true
                            GamePrintImportant("Noita Restart for saving world", "Noita will be restarted to fully save the world.\nUnfortunatelly this is due to no/less access to Noita save functions.")
                            _G.Server:setIsAllowed(client, true)
                            _G.Server:storeClients()
                            -- remeber to zip the savegame, when restarting server
                            ModSettingSetNextValue("noita-mp.server_start_7zip_savegame", true, false)
                            local make_zip = ModSettingGet("noita-mp.server_start_7zip_savegame")
                            print("server_class.lua | make_zip = " .. tostring(make_zip))

                            Sleep(2)
                            fu.StopSaveAndStartNoita()
                        end
                    end
                    GuiTooltip(gui, "Allow: You need to allow the client to connect, because Noita will be restarted to fully save the world.", "Unfortunatelly this is due to no/less access to Noita save functions.")
                    -- Kick Button
                    if GuiImageButton(gui, next_id(), 15, i, "", "mods/noita-mp/files/data/ui/red_tik_8x8.png") then

                    end
                end
            end

            -- GuiImage(gui, next_id(), 0, 0, "noita-mp/files/data/ui/green_tik.png" , 1,1,1)
            -- GuiTooltip(gui, "", "")

            -- if _G.Client ~= nil and next(_G.Client) ~= nil then
            --     local rtt = tonumber(_G.Client.super:getRoundTripTime())
            --     --GuiColorSetForNextWidget(gui, 1, 0, 0, 1) TODO rtt / ? = red
            --     GuiText(gui, 0, 0,  rtt .. "ms")
            -- end

        GuiLayoutEnd(gui)
    end
end

draw_gui()