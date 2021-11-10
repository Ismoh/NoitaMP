dofile( "data/scripts/lib/utilities.lua" )

-- volatile - these must be kept in sync with the corresponding enum in modding.h
MOD_SETTING_SCOPE_NEW_GAME = 0			-- setting change (that is the value that's visible when calling ModSettingGet()) is applied after a new run is started
MOD_SETTING_SCOPE_RUNTIME_RESTART = 1	-- setting change is applied on next game exe restart
MOD_SETTING_SCOPE_RUNTIME = 2			-- setting change is applied immediately
MOD_SETTING_SCOPE_ONLY_SET_DEFAULT = 3	-- this tells us that no changes should be applied. shouldn't be used in mod setting definition.

mod_setting_group_x_offset = 0

function is_visible_string( str )
	return str ~= nil and str ~= ""
end

function mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value )
	if setting.change_fn then
		setting.change_fn( mod_id, gui, in_main_menu, setting, old_value, new_value )
	end
end

function mod_setting_get_id( mod_id, setting )
	return mod_id .. "." .. setting.id
end

function mod_settings_get_version( mod_id )
	return ModSettingGet( mod_setting_get_id(mod_id,{id="_version"}) ) or 0
end

function mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
	local setting_id = mod_setting_get_id(mod_id,setting)
	local value = ModSettingGetNextValue( setting_id )
	local value_now = ModSettingGet( setting_id )

	local displayed = false
	if value ~= value_now then
		if setting.scope == MOD_SETTING_SCOPE_RUNTIME_RESTART and (not in_main_menu) then
			if is_visible_string( setting.ui_description ) then
				GuiTooltip( gui, setting.ui_description, "$menu_modsettings_changes_restart" )
			else
				GuiTooltip( gui, "$menu_modsettings_changes_restart", "" )
			end
			displayed = true
		elseif setting.scope == MOD_SETTING_SCOPE_NEW_GAME then
			if is_visible_string( setting.ui_description ) then
				GuiTooltip( gui, setting.ui_description, "$menu_modsettings_changes_worldgen" )
			else
				GuiTooltip( gui, "$menu_modsettings_changes_worldgen", "" )
			end
			displayed = true
		end
	end

	if not displayed and is_visible_string( setting.ui_description ) then
		GuiTooltip( gui, setting.ui_description, "" )
	end
end

function mod_setting_bool( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	if type(value) ~= "boolean" then value = setting.value_default or false end

	local text = setting.ui_name .. ": " .. GameTextGet( value and "$option_on" or "$option_off" )

	local clicked,right_clicked = GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text )
	if clicked then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
		mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value, not value )
	end
	if right_clicked then
		local new_value = setting.value_default or false
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), new_value, false )
		mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value, new_value )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_number( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	if type(value) ~= "number" then value = setting.value_default or 0.0 end

	if setting.value_min == nil or setting.value_max == nil or setting.value_default == nil then
		GuiText( setting.ui_name .. " - not all required values are defined in setting definition" )
		return
	end

	local value_new = GuiSlider( gui, im_id, mod_setting_group_x_offset, 0, setting.ui_name, value, setting.value_min, setting.value_max, setting.value_default, setting.value_display_multiplier or 1, setting.value_display_formatting or "", 64 )
	if value ~= value_new then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), value_new, false )
		mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value, value_new )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_enum( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	if type(value) ~= "string" then value = setting.value_default or "" end

	local value_id = 1
	for i,val in ipairs(setting.values) do
		if val[1] == value then
			value_id = i
			break
		end
	end

	local text = setting.ui_name .. ": " .. setting.values[value_id][2]

	local clicked,right_clicked = GuiButton( gui, im_id, mod_setting_group_x_offset, 0, text )
	if clicked then
		local value_old = value
		value_id = value_id + 1
		if value_id > #(setting.values) then
			value_id = 1
		end
		value = setting.values[value_id][1]
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), value, false  )
		mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value_old, value )
	end
	if right_clicked and setting.value_default then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), setting.value_default, false  )
		mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value, setting.value_default )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_text( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	if type(value) ~= "string" then value = setting.value_default or "" end

	GuiLayoutBeginHorizontal( gui, 0, 0 )
	GuiText( gui, mod_setting_group_x_offset, 0, setting.ui_name )
	local value_new = GuiTextInput( gui, im_id, 0, 0, value, 100, setting.text_max_length or 25, setting.allowed_characters or "" )
	GuiLayoutEnd( gui )
	if value ~= value_new then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), value_new, false )
		mod_setting_handle_change_callback( mod_id, gui, in_main_menu, setting, value, value_new )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_title( mod_id, gui, in_main_menu, im_id, setting )
	GuiText( gui, mod_setting_group_x_offset, 0, setting.ui_name )
end

function mod_setting_image( mod_id, gui, in_main_menu, im_id, setting )
	GuiImage( gui, im_id, mod_setting_group_x_offset, 0, setting.image_filename, 1, 1, 0 )

	if is_visible_string( setting.ui_description ) then
		GuiTooltip( gui, setting.ui_description, "" )
	end
end

function mod_setting_vertical_spacing( mod_id, gui, in_main_menu, im_id, setting )
	GuiLayoutAddVerticalSpacing( gui, 4 )
end

function mod_setting_category_button( mod_id, gui, im_id, im_id2, category )
	local image_file = "data/ui_gfx/button_fold_close.png"
	if category._folded then
		image_file = "data/ui_gfx/button_fold_open.png"
	end

	GuiLayoutBeginHorizontal( gui, 0, 0 )
	GuiIdPush( gui, 892304589 )

	GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawSemiTransparent )
	local clicked1 = GuiButton( gui, im_id, mod_setting_group_x_offset, 0, category.ui_name )
	if is_visible_string( category.ui_description ) then
		GuiTooltip( gui, category.ui_description, "" )
	end

	GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawActiveWidgetCursorOff )
	GuiOptionsAddForNextWidget( gui, GUI_OPTION.NoPositionTween )
	local clicked2 = GuiImageButton( gui, im_id2, 0, 0, "", image_file )
	if is_visible_string( category.ui_description ) then
		GuiTooltip( gui, category.ui_description, "" )
	end

	local clicked = clicked1 or clicked2
	if clicked then
		category._folded = not category._folded
	end

	GuiIdPop( gui )
	GuiLayoutEnd( gui )

	return clicked
end


function mod_settings_gui( mod_id, settings, gui, in_main_menu )
	local im_id = 1

	for i,setting in ipairs(settings) do
		if setting.category_id ~= nil then
			-- setting category
			GuiIdPush( gui, im_id )
			if setting.foldable then
				local im_id2 = im_id
				im_id = im_id + 1
				local clicked_category_heading = mod_setting_category_button( mod_id, gui, im_id, im_id2, setting )
				if not setting._folded then
					GuiAnimateBegin( gui )
					GuiAnimateAlphaFadeIn( gui, 3458923234, 0.1, 0.0, clicked_category_heading )
					mod_setting_group_x_offset = mod_setting_group_x_offset + 6
					mod_settings_gui( mod_id, setting.settings, gui, in_main_menu )
					mod_setting_group_x_offset = mod_setting_group_x_offset - 6
					GuiAnimateEnd( gui )
					GuiLayoutAddVerticalSpacing( gui, 4 )
				end
			else
				GuiOptionsAddForNextWidget( gui, GUI_OPTION.DrawSemiTransparent )
				GuiText( gui, mod_setting_group_x_offset, 0, setting.ui_name )
				if is_visible_string( setting.ui_description ) then
					GuiTooltip( gui, setting.ui_description, "" )
				end
				mod_setting_group_x_offset = mod_setting_group_x_offset + 2
				mod_settings_gui( mod_id, setting.settings, gui, in_main_menu )
				mod_setting_group_x_offset = mod_setting_group_x_offset - 2
				GuiLayoutAddVerticalSpacing( gui, 4 )
			end
			GuiIdPop( gui )
		else
			-- setting
			local auto_gui = setting.ui_fn == nil
			local visible = (setting.hidden == nil or not setting.hidden)
			if auto_gui and visible then
				local value_type = type(setting.value_default)
				if setting.not_setting then
					mod_setting_title( mod_id, gui, in_main_menu, im_id, setting )
				elseif value_type == "boolean" then
					mod_setting_bool( mod_id, gui, in_main_menu, im_id, setting )
				elseif value_type == "number" then
					mod_setting_number( mod_id, gui, in_main_menu, im_id, setting )
				elseif value_type == "string" and setting.values ~= nil then
					mod_setting_enum( mod_id, gui, in_main_menu, im_id, setting )
				elseif value_type == "string" then
					mod_setting_text( mod_id, gui, in_main_menu, im_id, setting )
				end
			elseif visible then
				setting.ui_fn( mod_id, gui, in_main_menu, im_id, setting )
			end
		end

		im_id = im_id+1
	end
end

function mod_settings_gui_count( mod_id, settings )
	local result = 0

	for i,setting in ipairs(settings) do
		if setting.category_id ~= nil then
			result = result + mod_settings_gui_count( mod_id, setting.settings )
		else
			local visible = (setting.hidden == nil or not setting.hidden)
			if visible then
				result = result + 1
			end
		end
	end

	return result
end

-- this is called on init, new game, unpause and so on.
-- this function will take care of setting the settings visible to the game to correct values.
function mod_settings_update( mod_id, settings, init_scope )
	-- init any unset settings to default values
	for i,setting in ipairs(settings) do
		if setting.category_id ~= nil then
			mod_settings_update( mod_id, setting.settings, init_scope )
		else
			if setting.id and setting.value_default and (setting.not_setting == nil or setting.not_setting == false) then
				ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), setting.value_default, true ) --the last parameter will tell the game that this is a default value, and should not override any existing value.
			end
		end
	end

	-- set settings to new value if the update scope is correct
	for i,setting in ipairs(settings) do
		if setting.category_id ~= nil then
			mod_settings_update( mod_id, setting.settings, init_scope )
		else
			if setting.id ~= nil and setting.scope ~= nil and setting.scope >= init_scope and (setting.not_setting == nil or setting.not_setting == false) then
				local next_value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
				if next_value ~= nil then
					ModSettingSet( mod_setting_get_id(mod_id,setting), next_value )
				end
			end
		end
	end

	-- update mod settings version
	if type(mod_settings_version) == "number" then
		ModSettingSet( mod_setting_get_id(mod_id,{id="_version"}), mod_settings_version )
	end
end
