NULL_ENTITY = 0
ORB_COUNT_IN_WORLD = 11

----------------------------------------------------------------------------------------

function rand( low, high )
    if low > high then
        local t = low
        low = high
        high = t
    end
    
    return low + Random() * (high - low)
end

----------------------------------------------------------------------------------------

function random_from_array( varray )
	local r = Random( 1, #varray )
	return varray[ r ]
end

----------------------------------------------------------------------------------------

function random_create( x, y )
	local result = {}
	result.x = x
	result.y = y
	return result
end

function random_next( rnd, min, max )
	local result = ProceduralRandomf( rnd.x, rnd.y, min, max )
	rnd.y = rnd.y + 1
	return result
end

function random_nexti( rnd, min, max )
	local result = ProceduralRandomi( rnd.x, rnd.y, min, max )
	rnd.y = rnd.y + 1
	return result
end

function pick_random_from_table_backwards( t, rnd )
	local result = nil
	local len = #t

	for i=len,1, -1 do
		if random_next( rnd, 0.0, 1.0 ) <= t[i].chance then
			result = t[i]
			break
		end
	end

	if result == nil then
		result = t[1]
	end

	return result
end

function pick_random_from_table_weighted( rnd, t )
	if #t == 0 then return nil end
	
	local weight_sum = 0.0
	for _,it in ipairs(t) do
		it.weight_min = weight_sum
		it.weight_max = weight_sum + it.probability
		weight_sum = it.weight_max
	end

	local val = random_next( rnd, 0.0, weight_sum )
	local result = t[1]
	for _,it in ipairs(t) do
		if val >= it.weight_min and val <= it.weight_max then
			result = it
			break
		end
	end

	return result
end

----------------------------------------------------------------------------------------

function string_isempty(s)
  return s == nil or s == ''
end

----------------------------------------------------------------------------------------

function for_comps( name, do_what )
	local this  = GetUpdatedEntityID()
	local comps = EntityGetComponent( this, name )
	if( comps ~= nil ) then
		for index,comp in ipairs(comps) do
			do_what( index, comp )
		end 
	end
end

----------------------------------------------------------------------------------------

function to_string( value )
	if value == true  then return "1" end
	if value == false then return "0" end
	return tostring(value)
end

----------------------------------------------------------------------------------------

function is_valid_entity( entity_id )
	return entity_id ~= nil and entity_id ~= 0
end

----------------------------------------------------------------------------------------

function edit_component( entity_id, type_name, do_what )
	if not is_valid_entity( entity_id ) then
		return  
	end

	local comp = EntityGetFirstComponent( entity_id, type_name )
	if comp ~= nil then
		local modified_vars = { }
		do_what( comp, modified_vars )
		for key,value in pairs( modified_vars ) do 
			ComponentSetValue( comp, key, to_string(value) )
		end
	end
end

----------------------------------------------------------------------------------------

function edit_component_with_tag( entity_id, type_name, tag, do_what )
	if not is_valid_entity( entity_id ) then
		return  
	end

	local comp = EntityGetFirstComponent( entity_id, type_name, tag )
	if comp ~= nil then
		local modified_vars = { }
		do_what( comp, modified_vars )
		for key,value in pairs( modified_vars ) do 
			ComponentSetValue( comp, key, to_string(value) )
		end
	end
end

----------------------------------------------------------------------------------------

function edit_all_components( entity_id, type_name, do_what )
	if not is_valid_entity( entity_id ) then  
		return  
	end

	local comps = EntityGetComponent( entity_id, type_name )
	if comps ~= nil then
		for i,comp in ipairs(comps) do
			local modified_vars = { }
			do_what( comp, modified_vars )
			for key,value in pairs( modified_vars ) do
				ComponentSetValue( comp, key, to_string(value) )
			end
		end
	end
end

----------------------------------------------------------------------------------------

function edit_nth_component( entity_id, type_name, n, do_what )
	if not is_valid_entity( entity_id ) then  
		return  
	end

	local nn = 0
	local comps = EntityGetComponent( entity_id, type_name )
	if comps ~= nil then
		for i,comp in ipairs(comps) do
			if nn == n then
				local modified_vars = { }
				do_what( comp, modified_vars )
				for key,value in pairs( modified_vars ) do
					ComponentSetValue( comp, key, to_string(value) )
				end
				break
			end
			nn = nn + 1
		end
	end
end

----------------------------------------------------------------------------------------

function component_get_value( entity_id, type_name, value_name, default )
	if not is_valid_entity( entity_id ) then  
		return default
	end

	local comp = EntityGetFirstComponent( entity_id, type_name )
	if comp ~= nil then
		return ComponentGetValue( comp, value_name )
	end

	return default
end

----------------------------------------------------------------------------------------

function component_get_value_int( entity_id, type_name, value_name, default )
	if not is_valid_entity( entity_id ) then  
		return default
	end

	local comp = EntityGetFirstComponent( entity_id, type_name )
	if comp ~= nil then
		return ComponentGetValueInt( comp, value_name )
	end

	return default
end

----------------------------------------------------------------------------------------

function component_get_value_float( entity_id, type_name, value_name, default )
	if not is_valid_entity( entity_id ) then  
		return default
	end

	local comp = EntityGetFirstComponent( entity_id, type_name )
	if comp ~= nil then
		return ComponentGetValueFloat( comp, value_name )
	end

	return default
end

----------------------------------------------------------------------------------------

function component_get_value_vector2( entity_id, type_name, value_name, default_x, default_y )
	if not is_valid_entity( entity_id ) then  
		return default_x, default_y
	end

	local comp = EntityGetFirstComponent( entity_id, type_name )
	if comp ~= nil then
		return ComponentGetValueVector2( comp, value_name, default_x, default_y )
	end

	return default_x, default_y
end

----------------------------------------------------------------------------------------

function get_variable_storage_component( entity_id, name )
	if not is_valid_entity( entity_id ) then  
		return nil
	end

	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if( components ~= nil ) then
		for _,comp_id in pairs(components) do 
			local var_name = ComponentGetValue( comp_id, "name" )
			if( var_name == name) then
				return comp_id
			end
		end
	end

	return nil
end

function get_stored_perk_pickup_count( entity_id )
	if not is_valid_entity( entity_id ) then  
		return nil
	end

	local value = nil
	local storage_comp = get_variable_storage_component(entity_id, "perk_pickup_count")
	if storage_comp ~= nil then
		component_read(storage_comp, { value_int = 0 }, function(comp)
			value = comp.value_int
		end)
	else
		value = 1
		EntityAddComponent( entity_id, "VariableStorageComponent", 
		{ 
			name = "perk_pickup_count",
			value_int = value,
		})
	end

	return value
end

-- component API v2 --------------------------------------------------------------------

function edit_component2( entity_id, type_name, do_what )
	if not is_valid_entity( entity_id ) then
		return  
	end

	local comp = EntityGetFirstComponent( entity_id, type_name )
	if comp ~= nil then
		local modified_vars = { }
		do_what( comp, modified_vars )
		for key,value in pairs( modified_vars ) do 
			ComponentSetValue2( comp, key, value )
		end
	end
end

-- For example:
-- component_readwrite( EntityGetFirstComponent( GetUpdatedEntityID(), "DamageModelComponent" ), { hp = 0, max_hp = 0 }, function(comp)
--   comp.max_hp = comp.max_hp * 1.5
--   comp.hp = comp.max_hp
-- end)
function component_readwrite( comp, component_prototype, do_what )
	if comp ~= nil then
		for key,value in pairs( component_prototype ) do 
			component_prototype[key] = ComponentGetValue2( comp, key )
		end
		do_what( component_prototype )
		for key,value in pairs( component_prototype ) do 
			ComponentSetValue2( comp, key, value )
		end
	end
end

-- For example:
-- component_read( EntityGetFirstComponent( GetUpdatedEntityID(), "DamageModelComponent" ), { max_hp = 0 }, function(comp)
--   print( comp.max_hp )
--   comp.max_hp = 100 -- this has no effect
-- end)
function component_read( comp, component_prototype, do_what )
	if comp ~= nil then
		for key,value in pairs( component_prototype ) do 
			component_prototype[key] = ComponentGetValue2( comp, key )
		end
		do_what( component_prototype )
	end
end

-- For example:
-- component_write( EntityGetFirstComponent( GetUpdatedEntityID(), "DamageModelComponent" ), { max_hp = 100 } )
function component_write( comp, component_keys_and_values )
	if comp ~= nil then
		for key,value in pairs( component_keys_and_values ) do 
			ComponentSetValue2( comp, key, value )
		end
	end
end

----------------------------------------------------------------------------------------

function edit_component_with_tag2( entity_id, type_name, tag, do_what )
	if not is_valid_entity( entity_id ) then
		return  
	end

	local comp = EntityGetFirstComponent( entity_id, type_name, tag )
	if comp ~= nil then
		local modified_vars = { }
		do_what( comp, modified_vars )
		for key,value in pairs( modified_vars ) do 
			ComponentSetValue2( comp, key, value )
		end
	end
end

----------------------------------------------------------------------------------------

function edit_all_components2( entity_id, type_name, do_what )
	if not is_valid_entity( entity_id ) then  
		return  
	end

	local comps = EntityGetComponent( entity_id, type_name )
	if comps ~= nil then
		for i,comp in ipairs(comps) do
			local modified_vars = { }
			do_what( comp, modified_vars )
			for key,value in pairs( modified_vars ) do
				ComponentSetValue2( comp, key, value )
			end
		end
	end
end

----------------------------------------------------------------------------------------

function edit_nth_component2( entity_id, type_name, n, do_what )
	if not is_valid_entity( entity_id ) then  
		return  
	end

	local nn = 0
	local comps = EntityGetComponent( entity_id, type_name )
	if comps ~= nil then
		for i,comp in ipairs(comps) do
			if nn == n then
				local modified_vars = { }
				do_what( comp, modified_vars )
				for key,value in pairs( modified_vars ) do
					ComponentSetValue2( comp, key, value )
				end
				break
			end
			nn = nn + 1
		end
	end
end

----------------------------------------------------------------------------------------

function component_get_value2( entity_id, type_name, value_name, default )
	if not is_valid_entity( entity_id ) then  
		return default
	end

	local comp = EntityGetFirstComponent( entity_id, type_name )
	if comp ~= nil then
		return ComponentGetValue2( comp, value_name )
	end

	return default
end

-- =====================================================================================

function get_players()
	return EntityGetWithTag( "player_unit" )
end

function get_herd_id( entity_id )
	return component_get_value_int( entity_id, "GenomeDataComponent", "herd_id", -1 )
end

----------------------------------------------------------------------------------------

function shoot_projectile( who_shot, entity_file, x, y, vel_x, vel_y, send_message )
	local entity_id = EntityLoad( entity_file, x, y )
	local herd_id   = get_herd_id( who_shot )
	if( send_message == nil ) then send_message = true end

	GameShootProjectile( who_shot, x, y, x+vel_x, y+vel_y, entity_id, send_message )

	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		vars.mWhoShot       = who_shot
		vars.mShooterHerdId = herd_id
	end)

	edit_component( entity_id, "VelocityComponent", function(comp,vars)
		ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y )
	end)

	return entity_id
end

----------------------------------------------------------------------------------------

function shoot_projectile_from_projectile( who_shot, entity_file, x, y, vel_x, vel_y )
	local entity_id = EntityLoad( entity_file, x, y )
	local herd_id   = get_herd_id( who_shot )
	local entity_that_shot = GetUpdatedEntityID()

	local who_shot_creature = 0
	edit_component( who_shot, "ProjectileComponent", function(comp,vars)
		who_shot_creature = ComponentGetValue2( comp, "mWhoShot" )
		ComponentSetValue2( comp, "mEntityThatShot", entity_that_shot )
	end)


	GameShootProjectile( who_shot_creature, x, y, x+vel_x, y+vel_y, entity_id, true, who_shot )

	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		vars.mWhoShot       = component_get_value_int( who_shot, "ProjectileComponent", "mWhoShot", 0 )
		vars.mShooterHerdId = component_get_value_int( who_shot, "ProjectileComponent", "mShooterHerdId", 0 )
	end)

	edit_component( entity_id, "VelocityComponent", function(comp,vars)
		ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
	end)
	
	if EntityHasTag( who_shot, "friendly_fire_enabled" ) then
		EntityAddTag( entity_id, "friendly_fire_enabled" )
		
		edit_component( entity_id, "ProjectileComponent", function(comp,vars)
			ComponentSetValue2( comp, "friendly_fire", true )
			ComponentSetValue2( comp, "collide_with_shooter_frames", 6 )
		end)
	end

	return entity_id
end

----------------------------------------------------------------------------------------

function script_wait_frames( entity_id, frames )
	local frame_now      = GameGetFrameNum()

	local last_execution = ComponentGetValueInt( GetUpdatedComponentID(),  "mLastExecutionFrame" )
	--print(last_execution)
	if( last_execution == nil ) then
		return false
	end

	if last_execution > -1 and (frame_now - last_execution) < frames then 
		return true
	end
	
	return false
end

----------------------------------------------------------------------------------------

function load_verlet_rope_with_two_joints( entity_filename, x1, y1, x2, y2 )
	local entity_id = EntityLoad( entity_filename, x1, y1 )

	if is_valid_entity( entity_id ) then
		EntityAddComponent( entity_id, "VerletWorldJointComponent" )
		EntityAddComponent( entity_id, "VerletWorldJointComponent" )
	end

	local verletphysics_comp_found = false
	local last_point_index = 0
	edit_component( entity_id, "VerletPhysicsComponent", function(comp,vars)
		verletphysics_comp_found = true
		last_point_index = ComponentGetValue( comp, "num_points" )
	end)

	if verletphysics_comp_found then
		------
		local index = 0

		edit_all_components( entity_id, "VerletWorldJointComponent", function(comp,vars)
			
			if index == 0 then
				ComponentSetValueVector2( comp, "world_position", x1, y1 )
			else
				ComponentSetValueVector2( comp, "world_position", x2, y2 )
				vars.verlet_point_index = last_point_index
			end

			index = index + 1
		end)

	else
		------
		print( "load_verlet_rope_with_two_joints() called for an entity with no VerletPhysicsComponent, or invalid entity file(name).")
	end
end

----------------------------------------------------------------------------------------

function load_verlet_rope_with_one_joint( entity_filename, x1, y1 )
   -- print(entity_filename)
	local entity_id = EntityLoad( entity_filename, x1, y1 )

	if is_valid_entity( entity_id ) then
		EntityAddComponent( entity_id, "VerletWorldJointComponent" )
	end

	local verletphysics_comp_found = false

	edit_component( entity_id, "VerletPhysicsComponent", function(comp,vars)
		verletphysics_comp_found = true
	end)

	if verletphysics_comp_found then

		edit_component( entity_id, "VerletWorldJointComponent", function(comp,vars)
			ComponentSetValueVector2( comp, "world_position", x1, y1 )
		end)

	else
		------
		print( "load_verlet_rope_with_one_joint() called for an entity with no VerletPhysicsComponent, or invalid entity file(name).")
	end
end

----------------------------------------------------------------------------------------

function debug_start_trace()
	local trace = function(event, line)
	      local s = debug.getinfo(2).short_src
	      print(s .. ":" .. line)
	end
   
	debug.sethook(trace, "l")
end

----------------------------------------------------------------------------------------

function debug_print_table( table_to_print, table_depth, parent_table )
	local table_depth_ = table_depth or 1
	local parent_table_ = parent_table or "TABLE"
	local result = parent_table_ .. ": "
	
	if (table_depth_ > 1) then
		for i=1,table_depth_ - 1 do
			result = result .. " - "
		end
	end
	
	local subtables = {}
	
	if (table_to_print ~= nil) and (tostring(type(table_to_print)) == "table") then
		for i,v in pairs(table_to_print) do
			result = result .. tostring(i) .. "(" .. tostring(v) .. "), "
			
			if (tostring(type(v)) == "table") then
				table.insert(subtables, {i, v})
			end
		end
	end
	
	print( result )
	
	for i,v in ipairs( subtables ) do
		debug_print_table( v[2], table_depth_ + 1, "subtable " .. v[1] )
	end
end

-----------------------------------------------------------------------------------------

function get_direction( x1, y1, x2, y2 )
	local result = math.pi - math.atan2( ( y2 - y1 ), ( x2 - x1 ) )
	return result
end

-----------------------------------------------------------------------------------------

function get_distance( x1, y1, x2, y2 )
	local result = math.sqrt( ( x2 - x1 ) ^ 2 + ( y2 - y1 ) ^ 2 )
	return result
end

-----------------------------------------------------------------------------------------

function get_distance2( x1, y1, x2, y2 )
	-- Distance squared. More performant but does not return accurate distance in actual pixels. Good for comparing relative distances.
	local result = ( x2 - x1 ) ^ 2 + ( y2 - y1 ) ^ 2
	return result
end

-----------------------------------------------------------------------------------------

function get_direction_difference( d1, d2 )
	local result = math.atan2( math.sin( d2 - d1 ), math.cos( d2 - d1 ) )
	return result
end

-----------------------------------------------------------------------------------------

function get_magnitude( x, y )
	local result = math.sqrt( x ^ 2 + y ^ 2 )
	return result
end

-----------------------------------------------------------------------------------------

function rad_to_vec( rad )
	local x = math.cos(-rad)
	local y = math.sin(rad)
	return x,y
end

-----------------------------------------------------------------------------------------

function clamp(value, min, max)
	value = math.max(value, min)
	value = math.min(value, max)
	return value
end

-----------------------------------------------------------------------------------------

function map(value, old_min, old_max, new_min, new_max)
	return (value - old_min) * (new_max - new_min) / (old_max - old_min) + new_min;
end

-----------------------------------------------------------------------------------------

function sign(value)
	if value > 0 then
		return 1
	elseif value < 0 then
		return -1
	else
		return 0
	end
end

-----------------------------------------------------------------------------------------

function lerp(a, b, weight)
	return a * weight + b * (1 - weight)
end

-----------------------------------------------------------------------------------------

-- interpolates between radian angles
function rot_lerp(a, b, weight)
    local pi2 = math.pi * 2
    local shortest = ((a-b) + math.pi) % pi2 - math.pi
    return b + (shortest * weight) % pi2
end

-----------------------------------------------------------------------------------------

function vec_add(x1, y1, x2, y2)
	x1 = x1 + x2
	y1 = y1 + y2
	return x1,y1
end

-----------------------------------------------------------------------------------------

function vec_sub(x1, y1, x2, y2)
	x1 = x1 - x2
	y1 = y1 - y2
	return x1,y1
end

-----------------------------------------------------------------------------------------

function vec_mult(x, y, multiplier)
	x = x * multiplier
	y = y * multiplier
	return x,y
end

-----------------------------------------------------------------------------------------

function vec_div(x, y, divider)
	x = x / divider
	y = y / divider
	return x,y
end

-----------------------------------------------------------------------------------------

function vec_scale(x1, y1, x2, y2)
	x1 = x1 * x2
	y1 = y1 * y2
	return x1,y1
end

-----------------------------------------------------------------------------------------

function vec_equals(x1, y1, x2, y2)
	return x1 == x2 and y1 == y2
end

-----------------------------------------------------------------------------------------

function vec_normalize(x, y)
	local m = get_magnitude(x, y)
	if m == 0 then return 0,0 end
	x = x / m
	y = y / m
	return x,y
end

-----------------------------------------------------------------------------------------

function vec_lerp(x1, y1, x2, y2, weight)
	local x = lerp(x1, x2, weight)
	local y = lerp(y1, y2, weight)
	return x,y
end

-----------------------------------------------------------------------------------------

function vec_dot(x1, y1, x2, y2)
	return x1 * x2 + y1 * y2
end

-----------------------------------------------------------------------------------------

function vec_rotate(x, y, angle)
	local ca = math.cos(angle)
	local sa = math.sin(angle)
	local px = ca * x - sa * y
	local py = sa * x + ca * y
	return px,py
end

teststring = "abcdefghijklmnopqrstuvwxyzdsice_trual_fgoipucrs_sm_t_theme"

function get_flag_name( text )
	local result = ""
	for i=1,#text do
		result = result .. string.sub(teststring, 26 + string.find( teststring, string.sub( text, i, i ) ), 26 + string.find( teststring, string.sub( text, i, i ) ) )
	end
	
	return result
end

-----------------------------------------------------------------------------------------

function change_entity_ingame_name( entity_id, new_name, new_description )
	if ( entity_id ~= nil ) then
		local uiinfo_comps = EntityGetComponent( entity_id, "UIInfoComponent" )
		local uiicon_comps = EntityGetComponent( entity_id, "UIIconComponent" )
		local item_comps = EntityGetComponent( entity_id, "ItemComponent" )
		local ability_comps = EntityGetComponent( entity_id, "AbilityComponent" )
		
		if ( uiinfo_comps ~= nil ) then
			for i,comp in ipairs( uiinfo_comps ) do
				if ( new_name ~= nil ) then
					ComponentSetValue2( comp, "name", new_name )
				end
			end
		end
		
		if ( uiicon_comps ~= nil ) then
			for i,comp in ipairs( uiicon_comps ) do
				if ( new_name ~= nil ) then
					ComponentSetValue2( comp, "name", new_name )
				end
				
				if ( new_description ~= nil ) then
					ComponentSetValue2( comp, "description", new_description )
				end
			end
		end
		
		if ( item_comps ~= nil ) then
			for i,comp in ipairs( item_comps ) do
				if ( new_name ~= nil ) then
					ComponentSetValue2( comp, "item_name", new_name )
				end
				
				if ( new_description ~= nil ) then
					ComponentSetValue2( comp, "ui_description", new_description )
				end
			end
		end
		
		if ( ability_comps ~= nil ) then
			for i,comp in ipairs( ability_comps ) do
				if ( new_name ~= nil ) then
					ComponentSetValue2( comp, "ui_name", new_name )
				end
			end
		end
	end
end

--

function check_parallel_pos( x )
	local pw = GetParallelWorldPosition( x, 0 )
	
	local mapwidth = BiomeMapGetSize() * 512
	local half = mapwidth * 0.5
	
	local mx = ( ( x + half ) % mapwidth ) - half
	
	return pw,mx
end

-- Used for secrets

alt_notes = {
a = "f",
b = "a2",
c = "a",
d = "c",
dis = "b",
e = "gsharp",
f = "g",
g = "dis",
gsharp = "d",
a2 = "e",
}

orb_list =
{
	{8,1},
	{1,-3},
	{-9,7},
	{-8,19},
	{-18,28},
	{-20,5},
	{-1,31},
	{20,31},
	{19,5},
	{6,3},
	{19,-3},
}

function orb_map_update()
	local result = ""
	
	for i,v in ipairs( orb_list ) do
		local part = tostring(v[1]) .. "," .. tostring(v[2])
		result = result .. part
		
		if ( i < #orb_list ) then
			result = result .. " "
		end
	end
	
	print( result )
	
	GlobalsSetValue( "ORB_MAP_STRING", result )
end

function orb_map_get()
	local result = {}
	
	local data = GlobalsGetValue( "ORB_MAP_STRING", "" )
	
	if ( #data > 0 ) then
		for word in string.gmatch( data, "%S+" ) do
			local n1,n2
			local i = 1
			for num in string.gmatch( word, "[^,]+" ) do
				if ( i == 1 ) then
					n1 = tonumber( num )
				elseif ( i == 2 ) then
					n2 = tonumber( num )
				end
				
				i = i + 1
			end
			
			if ( n1 ~= nil ) and ( n2 ~= nil ) then
				table.insert( result, {n1,n2})
			end
		end
	end
	
	return result
end

function is_in_camera_bounds(x, y, padding)
	local left, up, w, h = GameGetCameraBounds()
	return x >= left - padding and y >= up - padding and x <= left + w + padding and y <= up + h + padding
end

-----------------------------------------------------------------------------------------
-- gui

-- These options are exposed to the modding API due to public demand but are completely unsupported.
-- They don't work and haven't been tested with all widgets.
-- We're aware of many bugs that occur when using these in uninteded ways,
-- but we also probably never have time to fix them (and all the code that has various workarounds to get around the bugs :) ).
-- You just have to live with the fact that the gui library exists mainly to support the game, and we have limited time to work on it.

-- volatile: must be kept in sync with the ImGuiWidgetOptions enum in imgui.h
GUI_OPTION = {
	None = 0,

	IsDraggable = 1, -- you might not want to use this, because there will be various corner cases and bugs, but feel free to try anyway.
	NonInteractive = 2, -- works with GuiButton
	AlwaysClickable = 3,
	ClickCancelsDoubleClick = 4,
	IgnoreContainer = 5,
	NoPositionTween = 6,
	ForceFocusable = 7,
	HandleDoubleClickAsClick = 8,
	GamepadDefaultWidget = 9, -- it's recommended you use this to communicate the widget where gamepad input will focus when entering a new menu

	-- these work as intended (mostly)
	Layout_InsertOutsideLeft = 10,
	Layout_InsertOutsideRight = 11,
	Layout_InsertOutsideAbove = 12,
	Layout_ForceCalculate = 13,
	Layout_NextSameLine = 14,
	Layout_NoLayouting = 15,

	-- these work as intended (mostly)
	Align_HorizontalCenter = 16,
	Align_Left = 17,

	FocusSnapToRightEdge = 18,

	NoPixelSnapY = 19,

	DrawAlwaysVisible = 20,
	DrawNoHoverAnimation = 21,
	DrawWobble = 22,
	DrawFadeIn = 23,
	DrawScaleIn = 24,
	DrawWaveAnimateOpacity = 25,
	DrawSemiTransparent = 26,
	DrawActiveWidgetCursorOnBothSides = 27,
	DrawActiveWidgetCursorOff = 28,

	TextRichRendering = 29,

	NoSound = 47,
	Hack_ForceClick = 48,
	Hack_AllowDuplicateIds = 49,

	ScrollContainer_Smooth = 50,
	IsExtraDraggable = 51,

	_SnapToCenter = 62,
	Disabled = 63,
}

-- volatile: must be kept in sync with the ImGuiRectAnimationPlaybackType enum in imgui.h
GUI_RECT_ANIMATION_PLAYBACK = {
	PlayToEndAndHide = 0,
	PlayToEndAndPause = 1,
	Loop = 2,
}