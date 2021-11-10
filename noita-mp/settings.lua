dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

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

function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	print( tostring(new_value) )
end

local mod_id = "noita-mp" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value. 
mod_settings = 
{
	{
		id = "_",
		ui_name = "NOTE: This is just an example of mod settings. These don't actually affect anything.",
		not_setting = true,
	},
	{
		category_id = "group_of_settings",
		ui_name = "GROUP",
		ui_description = "Multiple settings together",
		settings = {
			{
				id = "world_size",
				ui_name = "World size",
				ui_description = "How much world do you want?",
				value_default = "small",
				values = { {"small","Small"}, {"medium","Medium"}, {"huge","Huge"} },
				scope = MOD_SETTING_SCOPE_NEW_GAME,
				change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
			},
			{
				id = "difficulty",
				ui_name = "Difficulty",
				ui_description = "Challenge amount.",
				value_default = "easy",
				values = { {"easy","Easy"}, {"normal","Normal"}, {"hard","Hard"} },
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "minibosses_enabled",
				ui_name = "Minibosses",
				ui_description = "Minibosses spawn occasionally.",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				category_id = "sub_group_of_settings",
				ui_name = "SUB GROUP WITH FOLDING",
				ui_description = "Multiple settings together in a foldable group",
				foldable = true,
				_folded = true, -- this field will be automatically added to each gategory table to store the current folding state
				settings = {
					{
						id = "world_size2",
						ui_name = "World size 2",
						ui_description = "How much world do you want?",
						value_default = "small",
						values = { {"small","Small"}, {"medium","Medium"}, {"huge","Huge"} },
						scope = MOD_SETTING_SCOPE_NEW_GAME,
						change_fn = mod_setting_change_callback, -- Called when the user interact with the settings widget.
					},
					{
						id = "difficulty2",
						ui_name = "Difficulty 2",
						ui_description = "Challenge amount.",
						value_default = "easy",
						values = { {"easy","Easy"}, {"normal","Normal"}, {"hard","Hard"} },
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
					{
						id = "minibosses_enabled2",
						ui_name = "Minibosses 2",
						ui_description = "Minibosses spawn occasionally.",
						value_default = true,
						scope = MOD_SETTING_SCOPE_RUNTIME,
					},
				},
			},
		},
	},
	{
		category_id = "group_of_settings2",
		ui_name = "ANOTHER GROUP",
		ui_description = "Multiple settings together",
		settings = {
			{
				id = "custom_cape",
				ui_name = "Custom cape",
				ui_description = "",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME_RESTART,
			},
			{
				id = "extra_health",
				ui_name = "Extra starting health",
				ui_description = "Extra HP",
				value_default = 4,
				value_min = 0,
				value_max = 10,
				value_display_multiplier = 25,
				value_display_formatting = " $0 HP",
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "custom_events_enabled",
				ui_name = "Custom events",
				ui_description = "",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "password",
				ui_name = "Password",
				ui_description = "Textbox.",
				value_default = "root",
				text_max_length = 20,
				allowed_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789",
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "custom_ui",
				ui_name = "This setting has got some custom UI",
				ui_description = "",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				ui_fn = mod_setting_bool_custom, -- custom widget
			},
			{
				ui_fn = mod_setting_vertical_spacing,
				not_setting = true,
			},
			{
				id = "secret_setting",
				ui_name = "Secret setting",
				value_default = true,
				hidden = true,
			},
			{
				id = "Text, not a setting",
				ui_name = "Just a title, not a setting",
				not_setting = true,
			},
			{
				image_filename = "data/ui_gfx/game_over_menu/game_over.png",
				ui_fn = mod_setting_image,
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
function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

-- This function should return the number of visible setting UI elements.
-- Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
-- If your mod changes the displayed settings dynamically, you might need to implement custom logic.
-- The value will be used to determine whether or not to display various UI elements that link to mod settings.
-- At the moment it is fine to simply return 0 or 1 in a custom implementation, but we don't guarantee that will be the case in the future.
-- This function is called every frame when in the settings menu.
function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )

	--example usage:
	--[[
	local im_id = 124662 -- NOTE: ids should not be reused like we do below
	GuiLayoutBeginLayer( gui )

	GuiLayoutBeginHorizontal( gui, 10, 50 )
    GuiImage( gui, im_id + 12312535, 0, 0, "data/particles/shine_07.xml", 1, 1, 1, 0, GUI_RECT_ANIMATION_PLAYBACK.PlayToEndAndPause )
    GuiImage( gui, im_id + 123125351, 0, 0, "data/particles/shine_04.xml", 1, 1, 1, 0, GUI_RECT_ANIMATION_PLAYBACK.PlayToEndAndPause )
    GuiLayoutEnd( gui )

	GuiBeginAutoBox( gui )

	GuiZSet( gui, 10 )
	GuiZSetForNextWidget( gui, 11 )
	GuiText( gui, 50, 50, "Gui*AutoBox*")
	GuiImage( gui, im_id, 50, 60, "data/ui_gfx/game_over_menu/game_over.png", 1, 1, 0 )
	GuiZSetForNextWidget( gui, 13 )
	GuiImage( gui, im_id, 60, 150, "data/ui_gfx/game_over_menu/game_over.png", 1, 1, 0 )

	GuiZSetForNextWidget( gui, 12 )
	GuiEndAutoBoxNinePiece( gui )

	GuiZSetForNextWidget( gui, 11 )
	GuiImageNinePiece( gui, 12368912341, 10, 10, 80, 20 )
	GuiText( gui, 15, 15, "GuiImageNinePiece")

	GuiBeginScrollContainer( gui, 1233451, 500, 100, 100, 100 )
	GuiLayoutBeginVertical( gui, 0, 0 )
	GuiText( gui, 10, 0, "GuiScrollContainer")
	GuiImage( gui, im_id, 10, 0, "data/ui_gfx/game_over_menu/game_over.png", 1, 1, 0 )
	GuiImage( gui, im_id, 10, 0, "data/ui_gfx/game_over_menu/game_over.png", 1, 1, 0 )
	GuiImage( gui, im_id, 10, 0, "data/ui_gfx/game_over_menu/game_over.png", 1, 1, 0 )
	GuiImage( gui, im_id, 10, 0, "data/ui_gfx/game_over_menu/game_over.png", 1, 1, 0 )
	GuiLayoutEnd( gui )
	GuiEndScrollContainer( gui )

	local c,rc,hov,x,y,w,h = GuiGetPreviousWidgetInfo( gui )
	print( tostring(c) .. " " .. tostring(rc) .." " .. tostring(hov) .." " .. tostring(x) .." " .. tostring(y) .." " .. tostring(w) .." ".. tostring(h) )

	GuiLayoutEndLayer( gui )
	]]--
end
