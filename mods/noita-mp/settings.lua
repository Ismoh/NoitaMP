dofile("data/scripts/lib/mod_settings.lua")

-- This file can't access other files from this or other mods in all circumstances.
-- Settings will be automatically saved.
-- Settings don't have access unsafe lua APIs.

-- Use ModSettingGet() in the game to query settings.
-- For some settings (for example those that affect world generation) you might want to retain the current value until a certain point, even
-- if the player has changed the setting while playing.
-- To make it easy to define settings like that, each setting has a "scope" (e.g. MOD_SETTING_SCOPE_NEW_GAME) that will define when the changes
-- will actually become visible via ModSettingGet(). In the case of MOD_SETTING_SCOPE_NEW_GAME the value at the start of the run will be visible
-- until the player starts a new game.
-- ModSettingSetNextValue() will set the buffered value, that will later become visible via ModSettingGet(), unless the setting scope is MOD_SETTING_SCOPE_RUNTIME.

function mod_setting_change_callback(mod_id, gui, in_main_menu, setting, old_value, new_value)
    print(
            "settings.lua | Mod setting '" ..
                    setting.id .. "' was changed from '" .. tostring(old_value) .. "' to '" .. tostring(new_value) .. "'."
    )

    print(("Mod setting changed: mod_id = %s, gui = %s, in_main_menu = %s, setting = %s, old_value = %s, new_value = %s"):format(mod_id,
                                                                                                                                 gui,
                                                                                                                                 in_main_menu,
                                                                                                                                 setting,
                                                                                                                                 old_value,
                                                                                                                                 new_value))

    -- ChangeDebugUi(setting, new_value)
end

function mod_setting_readonly(mod_id, gui, in_main_menu, im_id, setting)
    local guid = ModSettingGetNextValue("noita-mp.guid")
    local text = setting.ui_name .. ": " .. tostring(guid)

    GuiText(gui, 0, 0, text)
    mod_setting_tooltip(mod_id, gui, in_main_menu, setting)
end

--- Get a specific settings table by its id.
--- @param idOrCategoryId string id of the settings table or category id
--- @return table settings The specific settings table found by the id.
function GetSettingById(idOrCategoryId)
    --- Recursive searching for an id in each mod settings tables.
    ---@param tbl table each setting table in mod settings.
    ---@return table settings
    local function getSetting(tbl)
        local settingsTable = tbl
        for index, entry in ipairs(settingsTable) do
            if entry.id then
                -- when there is a setting defined
                if idOrCategoryId == entry.id then
                    return entry
                end
            elseif entry.category_id then
                -- when there is a category grouping
                if idOrCategoryId == entry.category_id then
                    return entry
                end
            end
            if entry.settings then
                local settings = getSetting(entry.settings)
                if settings then
                    return settings
                end
            end
        end
        return nil, nil
    end

    return getSetting(mod_settings)
end

-- function ChangeDebugUi(currentSetting, newValue)
-- 	local settingLogLevel = GetSettingById("log_level")

-- 	-- Show or hide log level setting, if debug is on or off
-- 	if currentSetting.id == "toggle_debug" then
-- 		settingLogLevel.hidden = not newValue
-- 	end
-- end

local mod_id         = "noita-mp" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings         = {
    {
        id              = "name",
        ui_name         = "Name",
        ui_description  = "Name displayed in game and necessary to set!",
        value_default   = "noname",
        text_max_length = 20,
        scope           = MOD_SETTING_SCOPE_RUNTIME,
        change_fn       = mod_setting_change_callback -- Called when the user interact with the settings widget.
    },
    {
        id              = "guid",
        value_default   = "",
        text_max_length = 36,
        scope           = MOD_SETTING_SCOPE_RUNTIME,
        change_fn       = mod_setting_change_callback, -- Called when the user interact with the settings widget.
        hidden          = true,
    },
    {
        id             = "guid_readonly",
        ui_name        = "GUID",
        ui_description = "Will be the same as long as you install a new CPU in your computer :).",
        ui_fn          = mod_setting_readonly,
    },
    {
        id     = "saveSlotMetaDirectory",
        ui_fn  = mod_setting_readonly,
        hidden = true,
    },
    {
        category_id    = "group_of_server_settings",
        ui_name        = "Server",
        ui_description = "Multiple server settings",
        settings       = {
            {
                id                 = "server_ip",
                ui_name            = "Server IP",
                ui_description     = [[Your servers IP or * for your global ip.
(Max length: 15 - Allowed characters:*.0123456789localhost)]],
                value_default      = "*",
                text_max_length    = 15,
                allowed_characters = "*.-0123456789abcdefghijklmnopqrstuvwxyz",
                scope              = MOD_SETTING_SCOPE_RUNTIME,
                change_fn          = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id                 = "server_port",
                ui_name            = "Server Port",
                ui_description     = "Your servers port. (Max length: 5 - Allowed characters: 1234567890, but 65535 is max port)",
                value_default      = "23476",
                text_max_length    = 5,
                allowed_characters = "1234567890",
                scope              = MOD_SETTING_SCOPE_RUNTIME,
                change_fn          = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id              = "server_password",
                ui_name         = "Server Password",
                ui_description  = "Your servers password.",
                value_default   = "",
                text_max_length = 20,
                scope           = MOD_SETTING_SCOPE_RUNTIME,
                change_fn       = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id             = "server_start_when_world_loaded",
                ui_name        = "Server start behaviour",
                ui_description = "Starts the server immediately, when world is loaded.",
                value_default  = true,
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id             = "server_start_7zip_savegame",
                ui_name        = "Savegame Slot 6",
                ui_description = "Savegame will be zipped next restart",
                value_default  = false,
                scope          = MOD_SETTING_SCOPE_RUNTIME_RESTART,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
                hidden         = true,
            },
            {
                id                 = "radius_include_entities",
                ui_name            = "Radius to detect entities",
                ui_description     = "Higher value = lower fps + small freezes. Value to low = DEsync! Default = 500",
                allowed_characters = "1234567890",
                value_default      = "350",
                scope              = MOD_SETTING_SCOPE_RUNTIME,
                change_fn          = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
        },
    },
    {
        category_id    = "group_of_client_settings",
        ui_name        = "Client",
        ui_description = "Multiple client settings",
        settings       = {
            {
                id                 = "connect_server_ip",
                ui_name            = "Connect Server IP",
                ui_description     = "Type the servers IP in, you want to connect. (Max length: 15 - Allowed characters: .0123456789)",
                value_default      = "localhost",
                text_max_length    = 15,
                allowed_characters = "*.-0123456789abcdefghijklmnopqrstuvwxyz",
                scope              = MOD_SETTING_SCOPE_RUNTIME,
                change_fn          = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id                 = "connect_server_port",
                ui_name            = "Connect Server Port",
                ui_description     = "Type the servers port in, you want to connect. (Max length: 5 - Allowed characters: 1234567890, but 65535 is max port)",
                value_default      = "23476",
                text_max_length    = 5,
                allowed_characters = "1234567890",
                scope              = MOD_SETTING_SCOPE_RUNTIME,
                change_fn          = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id              = "connect_server_password",
                ui_name         = "Connect Server Password",
                ui_description  = "Type the servers password in, you want to connect.",
                value_default   = "",
                text_max_length = 20,
                scope           = MOD_SETTING_SCOPE_RUNTIME,
                change_fn       = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id            = "connect_server_seed",
                value_default = 0,
                scope         = MOD_SETTING_SCOPE_RUNTIME,
                hidden        = true,
            },
            {
                id                 = "radius_exclude_entities",
                ui_name            = "Radius to remove entities on clients",
                ui_description     = "Higher value = better sync. Value to low = strange behaviour! Default = 500",
                allowed_characters = "1234567890",
                value_default      = "350",
                scope              = MOD_SETTING_SCOPE_RUNTIME,
                change_fn          = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
        },
    },
    {
        category_id    = "group_of_keybinding_settings",
        ui_name        = "Key Bindings",
        ui_description = "Multiple key binding settings",
        settings       = {
            {
                id                 = "toggle_multiplayer_menu",
                ui_name            = "Toggle multiplayer menu",
                ui_description     = "Key binding for showing and hiding mp menu",
                value_default      = "M",
                text_max_length    = 15,
                allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                scope              = MOD_SETTING_SCOPE_RUNTIME,
                change_fn          = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
        },
    },
    {
        category_id    = "group_of_performance_settings",
        ui_name        = "Performance issues? Take a look!",
        ui_description = "When it comes to FPS drops, you can tweak these settings to keep NoitaMP running on your system.",
        settings       = {
            {
                id             = "tick_rate",
                ui_name        = "Change tick rate for sync network messages.",
                ui_description = [[x-message per second = tick rate x.
Lower value = higher performance, but less sync.
Default = 16. 128 tick rate = 128 messages a second.]],
                value_default  = 16,
                value_min      = 1,
                value_max      = 128,
                scope          = MOD_SETTING_SCOPE_RUNTIME,
            },
            {
                id             = "change_detection",
                ui_name        = "Define when something changed related to position and velocity.",
                ui_description = [[Higher value = higher performance, but less sync.
Default = 0.5. Think of 0.5 on x then a change was detected.]],
                value_default  = 0.5,
                value_min      = 0.1,
                value_max      = 1,
                scope          = MOD_SETTING_SCOPE_RUNTIME,
            },
        },
    },
    {
        category_id    = "debug",
        ui_name        = "Debug settings",
        ui_description = "Multiple debug settings",
        settings       = {
            {
                id             = "toggle_debug",
                ui_name        = "Toggle debug (gui in game)",
                ui_description = "Toggle network debug information on or off in running world.",
                value_default  = false,
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id             = "toggle_radius",
                ui_name        = "Toggle detection radius",
                ui_description = "Toggle detection radius for entities ON or OFF.",
                value_default  = false,
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id             = "toggle_profiler",
                ui_name        = "Dis-/Enable profiler",
                ui_description = "Dis-/Enable the profiler.",
                value_default  = false,
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id             = "toggle_logger",
                ui_name        = "Dis-/Enable logger",
                ui_description = "Dis-/Enable the logger, doesn't matter what is set below.",
                value_default  = true,
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id             = "log_level_entity",
                ui_name        = "Log level related to Entities",
                ui_description = [[Set the current log level, for printing messages into console.
Debug:   You will see debug, warning, info and errors.
Warning: You will see warnings, info and errors.
Info:     You will see info and errors.
Error:   You will only see errors.]],
                value_default  = "error",
                values         = {
                    { "debug, warn, info, error", "Debug" }, { "warn, info, error", "Warning" }, { "info, error", "Info" }, { "error", "Error" }
                },
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id             = "log_level_globals",
                ui_name        = "Log level  related to Globals",
                ui_description = [[Set the current log level, for printing messages into console.
Debug:   You will see debug, warning, info and errors.
Warning: You will see warnings, info and errors.
Info:     You will see info and errors.
Error:   You will only see errors.]],
                value_default  = "error",
                values         = {
                    { "debug, warn, info, error", "Debug" }, { "warn, info, error", "Warning" }, { "info, error", "Info" }, { "error", "Error" }
                },
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id             = "log_level_guid",
                ui_name        = "Log level  related to Guids",
                ui_description = [[Set the current log level, for printing messages into console.
Debug:   You will see debug, warning, info and errors.
Warning: You will see warnings, info and errors.
Info:     You will see info and errors.
Error:   You will only see errors.]],
                value_default  = "error",
                values         = {
                    { "debug, warn, info, error", "Debug" }, { "warn, info, error", "Warning" }, { "info, error", "Info" }, { "error", "Error" }
                },
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id             = "log_level_network",
                ui_name        = "Log level related to Client and Server",
                ui_description = [[Set the current log level, for printing messages into console.
Debug:   You will see debug, warning, info and errors.
Warning: You will see warnings, info and errors.
Info:     You will see info and errors.
Error:   You will only see errors.]],
                value_default  = "error",
                values         = {
                    { "debug, warn, info, error", "Debug" }, { "warn, info, error", "Warning" }, { "info, error", "Info" }, { "error", "Error" }
                },
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
            {
                id             = "log_level_nuid",
                ui_name        = "Log level related to Nuids",
                ui_description = [[Set the current log level, for printing messages into console.
Debug:   You will see debug, warning, info and errors.
Warning: You will see warnings, info and errors.
Info:     You will see info and errors.
Error:   You will only see errors.]],
                value_default  = "error",
                values         = {
                    { "debug, warn, info, error", "Debug" }, { "warn, info, error", "Warning" }, { "info, error", "Info" }, { "error", "Error" }
                },
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            }, {
                id             = "log_level_vsc",
                ui_name        = "Log level related to Network VariableStorageComponents",
                ui_description = [[Set the current log level, for printing messages into console.
Debug:   You will see debug, warning, info and errors.
Warning: You will see warnings, info and errors.
Info:     You will see info and errors.
Error:   You will only see errors.]],
                value_default  = "error",
                values         = {
                    { "debug, warn, info, error", "Debug" }, { "warn, info, error", "Warning" }, { "info, error", "Info" }, { "error", "Error" }
                },
                scope          = MOD_SETTING_SCOPE_RUNTIME,
                change_fn      = mod_setting_change_callback, -- Called when the user interact with the settings widget.
            },
        },
    },
}


-- This function is called to ensure the correct setting values are visible to the game via ModSettingGet(). your mod's settings don't work if you don't have a function like this defined in settings.lua.
-- This function is called:
--		- when entering the mod settings menu (init_scope will be MOD_SETTINGS_SCOPE_ONLY_SET_DEFAULT)
-- 		- before mod initialization when starting a new game (init_scope will be MOD_SETTING_SCOPE_NEW_GAME)
--		- when entering the game after a restart (init_scope will be MOD_SETTING_SCOPE_RESTART)
--		- at the end of an update when mod settings have been changed via ModSettingsSetNextValue() and the game is unpaused (init_scope will be MOD_SETTINGS_SCOPE_RUNTIME)
function ModSettingsUpdate(init_scope)
    local old_version = mod_settings_get_version(mod_id) -- This can be used to migrate some settings between mod versions.
    mod_settings_update(mod_id, mod_settings, init_scope)
end

-- This function should return the number of visible setting UI elements.
-- Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
-- If your mod changes the displayed settings dynamically, you might need to implement custom logic.
-- The value will be used to determine whether or not to display various UI elements that link to mod settings.
-- At the moment it is fine to simply return 0 or 1 in a custom implementation, but we don't guarantee that will be the case in the future.
-- This function is called every frame when in the settings menu.
function ModSettingsGuiCount()
    return mod_settings_gui_count(mod_id, mod_settings)
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui(gui, in_main_menu)
    mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end
