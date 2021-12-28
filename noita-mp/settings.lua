dofile("data/scripts/lib/mod_settings.lua")
local Guid = dofile("mods/noita-mp/files/scripts/util/guid.lua")

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
end

local mod_id = "noita-mp" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings = {
	{
		id = "username",
		ui_name = "Username",
		ui_description = "Username displayed in game and necessary to set!",
		value_default = "noname",
		text_max_length = 20,
		scope = MOD_SETTING_SCOPE_RUNTIME,
		change_fn = mod_setting_change_callback -- Called when the user interact with the settings widget.
	},
	{
		id = "guid",
		ui_name = "Globally unique identifier",
		ui_description = "Cannot be changed manually. I suggest to keep it as it is.",
		value_default = "",
		text_max_length = 36,
		scope = MOD_SETTING_SCOPE_RUNTIME,
		change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
	},
	{
		id = "guid_readonly",
		ui_name = "Globally unique identifier",
		ui_description = "Cannot be changed manually. I suggest to keep it as it is.",
		ui_fn = mod_setting_readonly,
	},
	{
		category_id = "group_of_server_settings",
		ui_name = "Server",
		ui_description = "Multiple server settings",
		settings = {
			{
				id = "server_ip",
				ui_name = "Server IP",
				ui_description = "Your servers IP. (Max length: 15 - Allowed characters: .0123456789)",
				value_default = "localhost",
				text_max_length = 15,
				allowed_characters = ".0123456789abcdefghijklmnopqrstuvwxyz",
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "server_port",
				ui_name = "Server Port",
				ui_description = "Your servers port. (Max length: 5 - Allowed characters: 1234567890, but 65535 is max port)",
				value_default = "23476",
				text_max_length = 5,
				allowed_characters = "1234567890",
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "server_password",
				ui_name = "Server Password",
				ui_description = "Your servers password.",
				value_default = "",
				text_max_length = 20,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "server_start_when_world_loaded",
				ui_name = "Server start behaviour",
				ui_description = "Starts the server immediately, when world is loaded.",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "server_start_7zip_savegame",
				ui_name = "Savegame Slot 6",
				ui_description = "Savegame will be zipped next restart",
				value_default = false,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
				hidden = true,
			},
		},
	},
	{
		category_id = "group_of_client_settings",
		ui_name = "Client",
		ui_description = "Multiple client settings",
		settings = {
			{
				id = "connect_server_ip",
				ui_name = "Connect Server IP",
				ui_description = "Type the servers IP in, you want to connect. (Max length: 15 - Allowed characters: .0123456789)",
				value_default = "localhost",
				text_max_length = 15,
				allowed_characters = ".0123456789abcdefghijklmnopqrstuvwxyz",
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "connect_server_port",
				ui_name = "Connect Server Port",
				ui_description = "Type the servers port in, you want to connect. (Max length: 5 - Allowed characters: 1234567890, but 65535 is max port)",
				value_default = "23476",
				text_max_length = 5,
				allowed_characters = "1234567890",
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "connect_server_password",
				ui_name = "Connect Server Password",
				ui_description = "Type the servers password in, you want to connect.",
				value_default = "",
				text_max_length = 20,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "connect_server_seed",
				value_default = 0,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				hidden = true,
			},
		},
	},
	{
		category_id = "group_of_keybinding_settings",
		ui_name = "Key Bindings",
		ui_description = "Multiple key binding settings",
		settings = {
			{
				id = "toggle_multiplayer_menu",
				ui_name = "Toggle multiplayer menu",
				ui_description = "Key binding for showing and hiding mp menu",
				value_default = "M",
				text_max_length = 15,
				allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
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

function mod_setting_readonly(mod_id, gui, in_main_menu, im_id, setting)
	local guid = ModSettingGet("noita-mp.guid")
	local guid_value = ModSettingGetNextValue("noita-mp.guid")
	local text = setting.ui_name .. ": " .. guid_value .. ", " .. guid

	GuiText(gui, 0, 0, text)
	mod_setting_tooltip(mod_id, gui, in_main_menu, setting)
end
