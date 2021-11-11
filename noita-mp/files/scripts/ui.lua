if initialized == nil then initialized = false; end

if not initialized then
    initialized = true
    local gui_id = 6969
    local gui = gui or GuiCreate();

    local function reset_id()
        gui_id = 6969
    end

    local function nextId()
        local id = gui_id
        gui_id = gui_id + 1
        return id
    end

    local screen_width, screen_height = GuiGetScreenDimensions(gui)


    function draw_gui()
        --local frame = GameGetFrameNum()
        reset_id()
        GuiStartFrame(gui)
        GuiIdPushString( gui, "noita_multiplayer")

        --local inputText = GuiTextInput(gui, nextId(), 55, 105, "Server IP", 40, 15, "0123456789.:")
        --GuiTooltip(gui, "Insert servers IP here..", "Server IP")
        --print("GuiTextInput.text = " .. inputText)

        GuiZSetForNextWidget(gui, 8)
        GuiImage(gui, nextId(), 500, 500, "data/ui_gfx/button_fold_open.png" , 1,100,0)
        GuiTooltip(gui, "test image", "Testing image gui")

        -- controller stuff
        local player = GetPlayer()
        if (player) then
            -- local platform_shooter_player = EntityGetFirstComponentIncludingDisabled(player, "PlatformShooterPlayerComponent")
            -- if (platform_shooter_player) then
            --     local is_gamepad = ComponentGetValue2(platform_shooter_player, "mHasGamepadControlsPrev")
            --     if (is_gamepad) then
            --         GuiOptionsAdd(gui, GUI_OPTION.NonInteractive)
            --         GuiOptionsAdd(gui, GUI_OPTION.AlwaysClickable)
            --     end
            -- end
            -- --close on inventory change
            -- local inven_gui = EntityGetFirstComponent(player, "InventoryGuiComponent")
            -- if (inven_gui ~= nil) then
            --     local is_open = ComponentGetValue2(inven_gui, "mActive")

            --     if (is_open and not last_inven_is_open) then
            --         show_bank = false
            --     end
            --     last_inven_is_open = is_open
            -- end
        end
        -- -- close on escape (pause)
        -- if (show_bank and GamePaused) then
        --     show_bank = false
        -- end
        -- local ghost_button = HideGhosts and "hide_player_ghosts.png" or "player_ghosts.png"
        -- local chat_button = HideChat and "hide_chat.png" or "chat.png"
        -- local ghost_tooltip = HideGhosts and "No player ghosts" or "Showing player ghosts"
        -- local chat_tooltip = HideChat and "Ignoring chat messages" or "Showing chat messages"
        
        -- if (GuiImageButton(gui, next_id(), 80, 0, "", "mods/noita-together/files/ui/buttons/keyboard.png")) then
        --     show_message = not show_message
        --     if (not show_message) then
        --         player_msg = ""
        --     end
        -- end
        -- GuiTooltip(gui, "leave a message here", "")

        -- if (GuiImageButton(gui, next_id(), 100, 0, "", "mods/noita-together/files/ui/buttons/" .. ghost_button)) then
        --     HideGhosts = not HideGhosts
        --     if (HideGhosts) then
        --         DespawnPlayerGhosts()
        --     else
        --         SpawnPlayerGhosts(PlayerList)
        --     end
        -- end
        -- GuiTooltip(gui, ghost_tooltip, "")

        -- if (GuiImageButton(gui, next_id(), 120, 0, "", "mods/noita-together/files/ui/buttons/" .. chat_button)) then
        --     HideChat = not HideChat
        -- end
        -- GuiTooltip(gui, chat_tooltip, "")

        -- if (GuiImageButton(gui, next_id(), 140, 0, "", "mods/noita-together/files/ui/buttons/player_list.png")) then
        --     show_player_list = not show_player_list
        -- end
        -- GuiTooltip(gui, "Player List", "")

        -- if (GuiImageButton(gui, next_id(), 160, 0, "", "mods/noita-together/files/ui/buttons/bank.png")) then
        --     show_bank = not show_bank
        -- end
        -- GuiTooltip(gui, "Item Bank", "")

        -- if (show_message) then
        --     draw_player_message()
        -- end

        -- if (show_player_list) then
        --     draw_player_list(PlayerList)
        -- end

        -- if (show_bank) then
        --     draw_item_bank()
        --     if(GameHasFlagRun("send_gold")) then
        --         draw_gold_bank()
        --     end
        -- end
        
        -- local seed = ModSettingGet( "noita_together.seed" )
        -- local current_seed = tonumber(StatsGetValue("world_seed"))
        -- if (current_seed ~= seed and seed > 0) then
        --     GuiImageNinePiece(gui, next_id(), (screen_width / 2) - 90, 50, 180, 20, 0.8)
        --     GuiText(gui, (screen_width / 2) - 80, 55, "Host changed world seed, start a new game")
        -- end

        -- if (NT ~= nil and NT.run_ended) then
        --     GuiImageNinePiece(gui, next_id(), (screen_width / 2) - 90, 50, 180, 20, 0.8)
        --     GuiText(gui, (screen_width / 2) - 80, 55, NT.end_msg)
        -- end

        -- if (selected_player and PlayerList[selected_player] ~= nil) then
        --     GuiImageNinePiece(gui, next_id(), 5, 210, 90, 80, 0.5)
        --     if (GuiButton(gui, next_id(), 5, 210, "[x]")) then
        --         selected_player = ""
        --     end
        --     GuiText(gui, 5, 215, PlayerList[selected_player].name)
        -- end

        -- if (PlayerRadar) then
        --     local ghosts = EntityGetWithTag("nt_follow") or {}
        --     local ppos_x, ppos_y = GetPlayerOrCameraPos()
        --     local pos_x, pos_y = screen_width / 2, screen_height /2
        --     for _, ghost in ipairs(ghosts) do
        --         local var_comp = get_variable_storage_component(ghost, "userId")
        --         local user_id = ComponentGetValue2(var_comp, "value_string")
        --         local gx, gy = EntityGetTransform(ghost)
        --         local dir_x = (gx or 0) - ppos_x
        --         local dir_y = (gy or 0) - ppos_y
        --         local dist = math.sqrt(dir_x * dir_x + dir_y * dir_y)
        --         if (math.abs(dir_x) > 250 or math.abs(dir_y) > 150) then
        --             dir_x,dir_y = vec_normalize(dir_x,dir_y)
        --             local indicator_x = math.max(30, (pos_x - 30) + dir_x * 300)
        --             local indicator_y = pos_y + dir_y * 170
        --             GuiImage(gui, next_id(), indicator_x, indicator_y, "mods/noita-together/files/ui/player_ghost.png", 1, 1, 1)
        --             GuiTooltip(gui, (PlayerList[user_id].name or ""), string.format("%.0fm", math.floor(dist/10)))
        --         end
        --     end
        -- end

        GuiIdPop(gui)
    end
end

draw_gui()