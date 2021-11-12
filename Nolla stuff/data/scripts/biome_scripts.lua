-- RegisterSpawnFunction( 0xffbf26a9, "spawn_runes" )
-- RegisterSpawnFunction( 0xff6b26a6, "spawn_bigtorch" )
dofile( "data/scripts/item_spawnlists.lua" )

function runestone_activate( entity_id )
	local status = 0
	
	local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if ( variablestorages ~= nil ) then
		for j,storage_id in ipairs(variablestorages) do
			local var_name = ComponentGetValue( storage_id, "name" )
			if ( var_name == "active" ) then
				status = ComponentGetValue( storage_id, "value_int" )
				
				status = 1 - status
				
				ComponentSetValue2( storage_id, "value_int", status )
				
				if ( status == 1 ) then
					EntitySetComponentsWithTagEnabled( entity_id, "activate", true )
				else
					EntitySetComponentsWithTagEnabled( entity_id, "activate", false )
				end
			end
		end
	end
end

function spawn_apparition(x, y)
	SetRandomSeed( x, y )
	local PlaceItems1 	= 1
	local PlaceItems2 	= 2
	local Spawn 		= 3

	local level = 0 -- TODO: fetch biome level somehow
	local state,apparition_entity_id = SpawnApparition( x, y, level )

	-- local r = ProceduralRandom(x + 5.352, y - 4.463)
	-- if (r > 0.1) then

	local place_items = function()
		for i=1,4 do
			local rx = x + Random( -10, 10 )
				
			spawn_candles(rx, y)
		end
	end

	if state == PlaceItems1 or state == PlaceItems2 then
		place_items()
		print( tostring(x) .. ", " .. tostring(y) ) -- DEBUG:
	elseif state == Spawn then
		LoadPixelScene( "data/biome_impl/grave.png", "data/biome_impl/grave_visual.png", x-10, y-15, "", true )
		--[[
		GamePrint( "___________________________" )
		GamePrint( "" )
		GamePrint( "A chill runs up your spine!" )
		GamePrint( "___________________________" )
		--]]
		print( tostring(x) .. ", " .. tostring(y) ) -- DEBUG:
	end
end

function spawn_persistent_teleport(x, y)
	--[[
	local r = ProceduralRandom(x + 5.352, y - 4.463)
	if (r > 0.1) then
		local level = 0 -- TODO: fetch biome level somehow
		SpawnPersistentTeleport( x, y )
	end
	]]--
end

function spawn_persistent_teleport(x, y)
	--spawn(g_persistent_teleport,x,y,0,0)
end

function spawn_candles(x, y)
	spawn(g_candles,x,y,0,0)
end

function spawn_wands(x, y)
	spawn(g_items,x-5,y,0,0)
end

function spawn_potions( x, y )
	spawn_from_list( "potion_spawnlist", x, y )
end

function spawn_ghostlamp(x, y)
	spawn2(g_ghostlamp,x,y,0,0)
end

function parallel_check( x, y )
	if ( y < 0 ) then
		local pw = GetParallelWorldPosition( x, y )
		
		if ( pw ~= 0 ) then
			local r = ProceduralRandom( x + 35, y - 253 )
			local rx = ProceduralRandom( x - 35, y + 243 )
			
			SetRandomSeed( x + 35, y - 253 )
			
			r = Random( 1, 100 )
			rx = Random( 0, 512 )
			
			if ( r >= 98 ) then
				-- print( "ALCHEMIST AT " .. tostring( x + rx ) .. ", " .. tostring( y ) )
				EntityLoad( "data/entities/animals/parallel/alchemist/parallel_alchemist.xml", x + rx, y )
			elseif ( r >= 96 ) then
				-- print( "TENTACLE AT " .. tostring( x + rx ) .. ", " .. tostring( y ) )
				EntityLoad( "data/entities/animals/parallel/tentacles/parallel_tentacles.xml", x + rx, y )
			end
		end
	end
end

function spawn_mimic_sign( x, y )
	impl_raytrace_x = function( x0, y0, x_direction, max_length )
		local hit_something,hit_x,hit_y = Raytrace( x0, y0, x0 + (x_direction * max_length), y0 )
		return hit_x
	end

	local min_x = impl_raytrace_x( x, y, -1, 32 )
	local max_x = impl_raytrace_x( x, y, 1, 32 )

	if( ( x - min_x ) >= 24 and Raytrace( x - 16, y, x - 16, y - 26 ) == false ) then
		local hit_something, temp_x, max_y = Raytrace( x - 16, y - 25, x - 16, y + 32 )
		LoadPixelScene( "data/biome_impl/mimic_sign.png", "data/biome_impl/mimic_sign_visual.png", min_x, max_y - 23, "", true, true )
	elseif( ( max_x - x ) >= 24 and Raytrace( x + 16, y, x + 16, y - 26 ) == false ) then
		local hit_something, temp_x, max_y = Raytrace( x + 16, y - 25, x + 16, y + 32 )
		LoadPixelScene( "data/biome_impl/mimic_sign.png", "data/biome_impl/mimic_sign_visual.png", max_x - 22, max_y - 23, "", true, true )
	end
end


function spawn_heart( x, y )
	local r = ProceduralRandom( x, y )
	SetRandomSeed( x, y )
	local heart_spawn_percent = 0.7
	
	local year, month, day = GameGetDateAndTimeLocal()
	if ( month == 2 ) and ( day == 14 ) then heart_spawn_percent = 0.35 end


	if (r > heart_spawn_percent) then
		local entity = EntityLoad( "data/entities/items/pickup/heart.xml", x, y)
	elseif (r > 0.3) then
		SetRandomSeed( x+45, y-2123 )
		local rnd = Random( 1, 100 )
		
		if (rnd <= 90) or (y < 512 * 3) then
			rnd = Random( 1, 1000 )
			
			if( Random( 1, 300 ) == 1 ) then spawn_mimic_sign( x, y ) end

			if ( rnd < 1000 ) then
				local entity = EntityLoad( "data/entities/items/pickup/chest_random.xml", x, y)
			else
				local entity = EntityLoad( "data/entities/items/pickup/chest_random_super.xml", x, y)
			end
		else
			rnd = Random( 1, 100 )
			if( Random( 1, 30 ) == 1 ) then spawn_mimic_sign( x, y ) end

			if( rnd <= 95 ) then
				local entity = EntityLoad( "data/entities/animals/chest_mimic.xml", x, y)
			else
				local entity = EntityLoad( "data/entities/items/pickup/chest_leggy.xml", x, y)
			end
		end
	end
end

function spawn_potion_altar(x, y)
	local r = ProceduralRandom( x, y )
	
	if (r > 0.65) then
		LoadPixelScene( "data/biome_impl/potion_altar.png", "data/biome_impl/potion_altar_visual.png", x-5, y-15, "", true )
	end
end

function spawn_debug_mark( x,y )
	EntityLoad( "data/entities/_debug/debug_marker.xml", x, y )
end

function spawn_portal( x, y )
	if( BIOME_NAME == "crypt" ) then
		EntityLoad( "data/entities/buildings/teleport_boss_arena.xml", x, y - 4 )
	else
		EntityLoad( "data/entities/buildings/teleport_liquid_powered.xml", x, y - 4 )
	end
end

function spawn_end_portal( x, y )
	EntityLoad( "data/entities/buildings/teleport_boss_arena.xml", x, y - 4 )
end


function spawn_runes( x, y )
	--EntityLoad( "data/entities/buildings/runes.xml", x, y )
end

function spawn_fullhp(x, y)
	EntityLoad( "data/entities/items/pickup/heart_fullhp.xml", x, y )
end

function spawn_wand_trap( x, y )
	-- print(x)
	-- EntityLoad( "data/entities/buildings/wand_trap_circle_acid.xml", x, y )
	EntityLoad( "data/entities/props/physics_trap_circle_acid.xml", x, y )
end

function spawn_wand_trap_electricity_source( x, y )
	-- print(x)
	EntityLoad( "data/entities/buildings/wand_trap_electricity.xml", x, y )
end

function spawn_wand_trap_electricity( x, y )
	-- print(x)
	EntityLoad( "data/entities/props/physics_trap_electricity.xml", x, y )
end

function spawn_wand_trap_ignite( x, y )
	-- EntityLoad( "data/entities/buildings/wand_trap_ignite.xml", x, y )
	EntityLoad( "data/entities/props/physics_trap_ignite.xml", x, y )
end

function spawn_bigtorch(x, y)
	EntityLoad( "data/entities/props/physics_torch_stand.xml", x, y )
end

function spawn_moon(x, y)
	EntityLoad( "data/entities/buildings/moon_altar.xml", x, y )
end

function spawn_collapse( x, y )
	EntityLoad( "data/entities/misc/loose_chunks.xml", x, y )
end

function spawn_shopitem( x, y )
	generate_shop_item( x, y, false, 10 )
end