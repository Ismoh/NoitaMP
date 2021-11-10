-- default biome functions that get called if we can't find a a specific biome that works for us

function check_newgame_plus_level( level )
	local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") ) or 0
	
	return ( newgame_n >= level )
end

function check_parallel( status, x )
	if status then
		local pw = GetParallelWorldPosition( x, 0 )
		
		return ( pw ~= 0 )
	end
	
	return false
end

function init_total_prob( value, x )
	value.total_prob = 0
	for i,v in ipairs(value) do
		if ( v.prob ~= nil and ( v.spawn_check == nil or v.spawn_check() ) and ( v.ngpluslevel == nil or check_newgame_plus_level( v.ngpluslevel ) ) and ( v.parallel == nil or check_parallel( v.parallel, x ) ) ) then
			value.total_prob = value.total_prob + v.prob
		end
	end
end

function random_from_table( what, x, y )
	if ( what.total_prob == 0 ) then
		init_total_prob( what, x )
	end

	local r = ProceduralRandom(x,y) * what.total_prob
	for i,v in ipairs(what) do
		if( v.prob ~= nil and ( v.spawn_check == nil or v.spawn_check() ) and ( v.ngpluslevel == nil or check_newgame_plus_level( v.ngpluslevel ) ) and ( v.parallel == nil or check_parallel( v.parallel, x ) ) ) then
			if( r <= v.prob ) then
				return v
			end
			r = r - v.prob
		end
	end

	return nil
end

-- helper function for loading the entity

function entity_load_camera_bound(entity_data, x, y, rand_x, rand_y)
	-- if true then return nil end  -- enable 2 disable spawns
	if rand_x == nil then rand_x = 4 end
	if rand_y == nil then rand_y = 4 end

	-- load groups
	if( entity_data.entities ~= nil ) then
		for j,ev in ipairs(entity_data.entities) do
			if( type( ev ) == 'table' ) then
				local count = 1
				if( ev.min_count ~= nil ) then
					count = ev.min_count
					if( ev.max_count ~= nil ) then
						count = ProceduralRandom( x+j, y, ev.min_count, ev.max_count )
					end
				end

				for i = 1,count do
					local pos_x = x + ProceduralRandom(x+j, y+i, -rand_x, rand_x)
					local pos_y = y + ProceduralRandom(x+j, y+i, -rand_y, rand_y)
					if( ev.offset_y ~= nil ) then pos_y = pos_y + ev.offset_y end
					if( ev.offset_x ~= nil ) then pos_x = pos_x + ev.offset_x end
					EntityLoadCameraBound( ev.entity, pos_x, pos_y )
				end
			else
				if( ev ~= nil ) then
					local pos_x = x + ProceduralRandom(x+j, y, -rand_x, rand_x)
					local pos_y = y + ProceduralRandom(x+j, y, -rand_y, rand_y)
					if( ev.offset_y ~= nil ) then pos_y = pos_y + ev.offset_y end
					if( ev.offset_x ~= nil ) then pos_x = pos_x + ev.offset_x end

					EntityLoadCameraBound( ev, pos_x, pos_y )
				end
			end
		end
	end

	if( entity_data.entity == nil or  entity_data.entity == '' ) then
		return 0
	end

	local how_many = ProceduralRandom(x,y,entity_data.min_count,entity_data.max_count)
	if( how_many <= 0 ) then
		return 0
	end
	
	local pos_x = x
	local pos_y = y

	for i = 1,how_many do
		pos_x = x + ProceduralRandom(x+i,y,-rand_x, rand_x)
		pos_y = y + ProceduralRandom(x+i,y,-rand_y, rand_y)
		if( entity_data.offset_y ~= nil ) then pos_y = pos_y + entity_data.offset_y end
		if( entity_data.offset_x ~= nil ) then pos_x = pos_x + entity_data.offset_x end

		EntityLoadCameraBound( entity_data.entity, pos_x, pos_y )
	end

	return 1
end

function entity_load_chest( x, y, chest_type, force_level )
	local chest = "chest"
	if chest_type ~= nil then
		chest = chest_type
		-- print("chest type is " .. chest)
	end
	
	local level = tostring(CHEST_LEVEL)
	if force_level ~= nil then
		level = tostring(force_level)
	end
	
	local path = "data/entities/items/" .. chest .. ".xml"
	
	local entity = EntityLoad( path, x, y)
	local components_item_chest = EntityGetComponent( entity, "ItemChestComponent" )
	if components_item_chest ~= nil then
		--[[if (math.random(0, 5) == 1) then
			ComponentSetValue( components_item_chest[1], "other_entities_to_spawn", "data/entities/items/textlog_persistent_teleport.xml" )
		else]]--
			ComponentSetValue( components_item_chest[1], "level", level )
		--end
		-- IF WE WANT TO SPAWN OTHER ITEMS:
		-- ComponentSetValue( components_item_chest[1], "other_entities_to_spawn", "data/entities/items/textlog_persistent_teleport.xml" )
	end
	return entity
end

function entity_load_stash( x, y )
	--[[SetRandomSeed( x, y )
	local stash = SpawnStash( x, y, CHEST_LEVEL, Random(3,5) )
	-- LoadEntityToStash( "data/entities/items/poisonwand.xml", stash )
	return stash]]--

	local entity = EntityLoad( "data/entities/items/pickup/heart.xml", x, y)
	-- return entity_load_chest( x, y, "chest_stash" )
end

-- actual functions that get called from the wang generator

function spawn(what, x, y, rand_x, rand_y)
	local x_offset,y_offset = 5,5
	-- if( what == nil ) then print( "ERROR - director_helpers - spawn() ... what = nil") end
	local v = random_from_table( what, x, y )
	if ( v ~= nil ) then
		entity_load_camera_bound( v, x + x_offset, y + y_offset, rand_x, rand_y)
	end
end

-- use this function to spawn without applying the hacky 5,5 offset

function spawn2(what, x, y, rand_x, rand_y)
	-- if( what == nil ) then print( "ERROR - director_helpers - spawn() ... what = nil") end
	local v = random_from_table( what, x, y )
	if ( v ~= nil ) then
		entity_load_camera_bound( v, x, y, rand_x, rand_y)
	end
end

function DEBUG_spawn_all( what, x, y, width )
	for i,v in ipairs(what) do
		if( v.prob ~= nil and v.prob > 0 ) then
			entity_load_camera_bound( v, x, y, 0, 0)
			x = x + width
		end
	end
end

function is_empty( what )
	if( what == nil ) then return true end
	if( what == "" ) then return true end
	return false
end

function is_table(t) 
	return type(t) == 'table' 
end

function load_random_pixel_scene( what, x, y )
	if( what.total_prob == 0 ) then
		init_total_prob( what, x )
	end

	local r = ProceduralRandom(x,y) * what.total_prob
	local last_element = nil
	for i,v in ipairs(what) do
		if( v.prob ~= nil ) then
			if( v.prob ~= 0 and r <= v.prob ) then
				if( is_empty( v.material_file ) and is_empty( v.visual_file ) and is_empty( v.background_file ) ) then
					-- loading empty pixelscene, don't do anything
					return
				else
					local color_material_table = {}
					-- Note( Petri ): I couldn't get this to work from lua... I don't know why. Lua is not really being all that helpful
					if( v.color_material ~= nil ) then
						SetRandomSeed( x + 11, y - 21 )

						for color,material in pairs(v.color_material) do
							if( is_table(material) ) then
								material = material[ math.ceil( ProceduralRandom( x + 11, y - 21 ) * (#material ) ) ]
							end 
							color_material_table[ color ] = material
						end
					end

					-- Lua_LoadPixelScene( string materials_filename, string colors_filename, x, y, string background_file, skip_biome_checks = false, skip_edge_textures = false, color_to_material_table = {} )";
					local z_index = 50
					if( v.z_index ) then z_index = v.z_index end

					LoadPixelScene( v.material_file, v.visual_file, x, y, v.background_file, false, false, color_material_table, z_index )
					if( v.is_unique == 1 ) then
						what[i].prob = 0
						init_total_prob( what, x )
					end
					return
				end
			else
				r = r - v.prob
				if( v.is_unique ~= 1 ) then
					last_element = v
				end
			end
		end
	end

	print_error( "ERROR " .. tostring(#what) .. ", " .. tostring(what[1]["visual_file"]))
	print_error( "ERROR - director_helpers.lua - load_random_pixel_scene() shouldn't reach here")

	if( last_element ~= nil ) then
		if( is_empty( last_element.material_file ) and is_empty( last_element.visual_file ) and is_empty( last_element.background_file ) ) then
			LoadPixelScene( last_element.material_file, last_element.visual_file, x, y )
		else
			print_error( "ERROR " .. #what )
			print_error( "ERROR - director_helpers.lua - load_random_pixel_scene() should it be loading a scene? ")
		end
	else
		print_error( "ERROR " .. #what )
		print_error( "ERROR - director_helpers.lua - load_random_pixel_scene() shouldn't reach here")
	end
end

function load_random_background_sprite( what, x, y )
	if( what.total_prob == 0 ) then
		init_total_prob( what, x )
	end

	local r = ProceduralRandom(x,y) * what.total_prob
	for i,v in ipairs(what) do
		if( v.prob ~= nil ) then
			if( v.prob ~= 0 and r <= v.prob ) then
				if( is_empty( v.sprite_file) ) then
					-- loading empty sprite, don't do anything
					return
				else
					-- LoadBackgroundSprite( string background_file, x, y, int background_z_index = 40 )
					local z_index = 40
					if( v.z_index ) then z_index = v.z_index end

					LoadBackgroundSprite( v.sprite_file, x, y, z_index, true )
					return
				end
			else
				r = r - v.prob
			end
		end
	end
	
	print_error( "ERROR " .. tostring(#what) .. ", " .. tostring(what[1]["sprite_file"]))
	print_error( "ERROR - director_helpers.lua - load_random_background_sprite() shouldn't reach here")
end

-- Special spawn function that only randomizes position of certain enemies

function spawn_with_limited_random(what, x, y, rand_x, rand_y, entities_to_randomize)
	local x_offset,y_offset = 5,5
	
	local v = random_from_table( what, x, y )
	
	if ( v ~= nil ) then
		local entity_files = {}
		local do_randomization = false
		
		if ( entities_to_randomize ~= nil ) then
			if ( v.entity ~= nil ) then
				table.insert( entity_files, v.entity )
			elseif ( v.entities ~= nil ) then
				for i,entity_data in ipairs(v.entities) do
					if ( tostring( type( entity_data ) ) == "table" ) then
						if ( entity_data.entity ~= nil ) then
							table.insert( entity_files, entity_data.entity )
						end
					elseif ( tostring( type( entity_data ) ) == "string" ) then
						table.insert( entity_files, entity_data )
					end
				end
			end
			
			for i,entity_file in ipairs(entity_files) do
				if ( string.len( entity_file ) > 0 ) then
					local entity_name = ""
					
					for j=1,string.len(entity_file) do
						local letter = string.sub( entity_file, string.len( entity_file ) - ( j - 1 ), string.len( entity_file ) - ( j - 1 ) )
						
						if ( letter ~= "/" ) then
							entity_name = letter .. entity_name
						else
							break
						end
					end
					
					entity_name = string.sub( entity_name, 1, string.len( entity_name ) - 4 )
					
					for j,r_entity in ipairs( entities_to_randomize ) do
						if ( r_entity == entity_name ) then
							do_randomization = true
							break
						end
					end
				end
			end
		end
		
		local random_x = rand_x or 0
		local random_y = rand_y or 0
		
		if do_randomization then
			random_x = random_x + 4
		end
		
		entity_load_camera_bound( v, x + x_offset, y + y_offset, random_x, random_y )
	end
end
