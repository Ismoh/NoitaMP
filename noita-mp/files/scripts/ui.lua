local util = require("util")
local fu = require("file_util")

if initialized == nil then
    initialized = false
end

if not initialized then
    print("initializing ui..")
    initialized = true
    local gui_id = 2
    local gui = gui or GuiCreate()

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

    function draw_gui()
        local server_ip = tostring(ModSettingGet("noita-mp.server_ip"))
        local server_port = tostring(ModSettingGet("noita-mp.server_port"))
        local connect_to_ip = tostring(ModSettingGet("noita-mp.connect_server_ip"))
        local connect_to_port = tostring(ModSettingGet("noita-mp.connect_server_port"))

        reset_id()
        GuiStartFrame(gui)

        ------------ ------------ Start server ui
        local width, height = GuiGetScreenDimensions(gui) -- width = 640, height = 360
        local bg_width, bg_height = GuiGetImageDimensions(gui, "mods/noita-mp/files/data/ui_gfx/in_game/mp_menu_200x150.png", 1)

        local x = width / 2 - bg_width / 2
        local y = height - bg_height

        GuiImage(gui, next_id(), x, y, "mods/noita-mp/files/data/ui_gfx/in_game/mp_menu_200x150.png", 1, 1, 1)

        GuiLayoutBeginHorizontal(gui, x, y, true, 0, 0)
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
        GuiLayoutBeginHorizontal(gui, x, y, true, 5, 5)
        ------------ Not allowed to connect to a server while your own server is running
        if _G.Server ~= nil and next(_G.Server) ~= nil and _G.Server.super ~= nil and next(_G.Server.super) ~= nil then
            GuiText(gui, 0, 0, "Not allowed to connect..")
            GuiTooltip(
                gui,
                "Not allowed to connect..",
                "Stop your server first, before connecting to another server. Thanks!"
            )
        else
            ------------ Connect
            if
                _G.Client == nil or next(_G.Client) == nil or
                    _G.Client.super:isDisconnected() and not _G.Client.super:isConnecting()
             then
                GuiColorSetForNextWidget(gui, 0, 1, 0, 1)
                if GuiButton(gui, next_id(), 0, 0, "Connect to " .. connect_to_ip .. ":" .. connect_to_port) then
                    _G.Client:connect()
                end
            else
                ------------- Disconnect
                GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
                if GuiButton(gui, next_id(), 0, 0, "Disconnect from " .. connect_to_ip .. ":" .. connect_to_port) then
                    _G.Client:disconnect()
                end
            end
        end
        GuiLayoutEnd(gui)

        ------------ ------------ Player list header
        local string_length = 12
        x = x
        y = y + 3
        GuiLayoutBeginHorizontal(gui, x, y, true, 5, 5)
        GuiText(gui, 0, 0, util.ExtendAndCutStringToLength("Name", string_length, " "))
        GuiText(gui, 0, 0, util.ExtendAndCutStringToLength("Ping", string_length, " "))
        GuiText(gui, 0, 0, util.ExtendAndCutStringToLength("Map received", string_length, " "))
        GuiText(gui, 0, 0, util.ExtendAndCutStringToLength("Allow", string_length, " "))
        GuiText(gui, 0, 0, util.ExtendAndCutStringToLength("Kick", string_length, " "))
        GuiLayoutEnd(gui)

        ------------ ------------ Player list content
        x = x
        y = y + 3
        GuiLayoutBeginHorizontal(gui, x, y, true, 5, 5)
        ------------- Player list when server
        if _G.Server ~= nil and next(_G.Server) ~= nil and _G.Server.super ~= nil and next(_G.Server.super) ~= nil then
            for i, client in pairs(_G.Server.super:getClients()) do
                i = (i - 1) * 3 -- 1-1*5=0 | 2-1*5=5 | 3-1*5=10
                GuiText(gui, 0, i, util.ExtendAndCutStringToLength(client.username, string_length, " "))
                GuiText(
                    gui,
                    0,
                    i,
                    util.ExtendAndCutStringToLength(client:getRoundTripTime() .. "ms", string_length, " ")
                )
                -- Map received
                if client.isMapReceived then
                    GuiImage(
                        gui,
                        next_id(),
                        10,
                        i,
                        "mods/noita-mp/files/data/ui_gfx/in_game/green_tik_8x8.png",
                        1,
                        1,
                        1
                    )
                else
                    GuiImage(gui, next_id(), 10, i, "mods/noita-mp/files/data/ui_gfx/in_game/red_tik_8x8.png", 1, 1, 1)
                end

                -- Allow Button
                if
                    GuiImageButton(
                        gui,
                        next_id(),
                        15,
                        i,
                        "",
                        "mods/noita-mp/files/data/ui_gfx/in_game/green_tik_8x8.png"
                    )
                 then
                    if _G.Server:checkIsAllowed(client) then
                        -- Send map, if already allowed to join
                        _G.Server:sendMap(client)
                    else
                        -- Save map and restart, if not already allowed and set allowed to true
                        GamePrintImportant(
                            "Noita Restart for saving world",
                            "Noita will be restarted to fully save the world.\nUnfortunatelly this is due to no/less access to Noita save functions."
                        )
                        _G.Server:setIsAllowed(client, true)
                        _G.Server:storeClients()
                        -- remeber to zip the savegame, when restarting server
                        ModSettingSetNextValue("noita-mp.server_start_7zip_savegame", true, false)
                        local make_zip = ModSettingGet("noita-mp.server_start_7zip_savegame")
                        print("server_class.lua | make_zip = " .. tostring(make_zip))

                        util.Sleep(2)
                        fu.StopSaveAndStartNoita()
                    end
                end
                GuiTooltip(
                    gui,
                    "Allow: You need to allow the client to connect, because Noita will be restarted to fully save the world.",
                    "Unfortunatelly this is due to no/less access to Noita save functions."
                )
                -- Kick Button
                if GuiImageButton(gui, next_id(), 15, i, "", "mods/noita-mp/files/data/ui_gfx/in_game/red_tik_8x8.png") then
                    client:disconnect()
                end
            end
        end

        -- GuiImage(gui, next_id(), 0, 0, "noita-mp/files/data/ui_gfx/in_game/green_tik_8x8.png" , 1,1,1)
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
