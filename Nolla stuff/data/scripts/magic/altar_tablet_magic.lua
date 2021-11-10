dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( x, y )

local tablets = EntityGetWithTag( "tablet" )
local worm_crystals = EntityGetWithTag( "worm_crystal" )
local hand_statues = EntityGetWithTag( "statue_hand" )

-- chest rain is done only once
if( GlobalsGetValue("MISC_CHEST_RAIN") ~= "1" ) then

	local chests = EntityGetWithTag( "chest" )
	if ( #chests > 0 ) then
		local collected = false
		local players = EntityGetWithTag( "player_unit" )
		
		if ( #players > 0 ) then
			local player_id = players[1]
			local px, py = EntityGetTransform( player_id )
			
			for i,chest_id in ipairs(chests) do
				local cx, cy = EntityGetTransform( chest_id )
				
				local distance = math.abs( x - cx ) + math.abs( y - cy )
			
				if ( distance < 48 ) then
					local eid = EntityLoad("data/entities/misc/chest_rain.xml", px, py)
					EntityAddChild( player_id, eid )
					EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", cx, cy)
					collected = true
					EntityKill( chest_id )
				end
			end
		end
		
		if collected then
			GlobalsSetValue("MISC_CHEST_RAIN", "1" )			
			GamePrintImportant( "$log_altar_magic", "" )
			
			AddFlagPersistent( "misc_chest_rain" )
		end
	end
end

if( GlobalsGetValue("MISC_SUN_EFFECT") ~= "1" ) then
	local suns = EntityGetWithTag( "sunrock" )
	
	if ( #suns > 0 ) then
		local collected = false
		local players = EntityGetWithTag( "player_unit" )
		
		if ( #players > 0 ) then
			local player_id = players[1]
			local px, py = EntityGetTransform( player_id )
			
			for i,chest_id in ipairs(suns) do
				local cx, cy = EntityGetTransform( chest_id )
				
				local distance = math.abs( x - cx ) + math.abs( y - cy )
			
				if ( distance < 72 ) then
					EntityLoad("data/entities/items/pickup/sun/newsun.xml", cx, cy )
					EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", cx, cy)
					collected = true
					EntityKill( chest_id )
				end
			end
		end
		
		if collected then
			GlobalsSetValue("MISC_SUN_EFFECT", "1" )			
			GamePrintImportant( "$log_altar_magic", "" )
			
			AddFlagPersistent( "misc_sun_effect" )
		end
	end
end

if( GlobalsGetValue("MISC_DARKSUN_EFFECT") ~= "1" ) then
	local suns = EntityGetWithTag( "darksunrock" )
	
	if ( #suns > 0 ) then
		local collected = false
		local players = EntityGetWithTag( "player_unit" )
		
		if ( #players > 0 ) then
			local player_id = players[1]
			local px, py = EntityGetTransform( player_id )
			
			for i,chest_id in ipairs(suns) do
				local cx, cy = EntityGetTransform( chest_id )
				
				local distance = math.abs( x - cx ) + math.abs( y - cy )
			
				if ( distance < 72 ) then
					EntityLoad("data/entities/items/pickup/sun/newsun_dark.xml", cx, cy )
					EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", cx, cy)
					collected = true
					EntityKill( chest_id )
				end
			end
		end
		
		if collected then
			GlobalsSetValue("MISC_DARKSUN_EFFECT", "1" )			
			GamePrintImportant( "$log_altar_magic", "" )
			
			AddFlagPersistent( "misc_darksun_effect" )
		end
	end
end

local greed_crystals = EntityGetWithTag( "greed_crystal" )
if ( #greed_crystals > 0 ) then
	local collected = false
	local players = EntityGetWithTag( "player_unit" )
	
	if ( #players > 0 ) then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )
		
		for i,crystal_id in ipairs( greed_crystals ) do
			local cx, cy = EntityGetTransform( crystal_id )
			
			local distance = math.abs( x - cx ) + math.abs( y - cy )
		
			if ( distance < 64 ) then
				if( GlobalsGetValue("MISC_GREED_RAIN") ~= "1" ) then
					local eid = EntityLoad("data/entities/misc/greed_curse/greed_rain.xml", px, py)
					EntityAddChild( player_id, eid )
				else
					local eid = EntityLoad("data/entities/misc/greed_curse/greed_rain_simple.xml", px, py)
					EntityAddChild( player_id, eid )
				end
				
				EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", cx, cy)
				collected = true
				EntityKill( crystal_id )
			end
		end
	end
	
	if collected then
		GlobalsSetValue("MISC_GREED_RAIN", "1" )			
		GamePrintImportant( "$log_altar_magic", "" )
		
		AddFlagPersistent( "misc_greed_rain" )
	end
end

if ( #worm_crystals > 0 ) then
	local collected = false
	local players = EntityGetWithTag( "player_unit" )
	
	if ( #players > 0 ) then
		local player_id = players[1]
		local px, py = EntityGetTransform( player_id )
		
		for i,crystal_id in ipairs(worm_crystals) do
			local cx, cy = EntityGetTransform( crystal_id )
			
			local distance = math.abs( x - cx ) + math.abs( y - cy )
		
			if ( distance < 64 ) then
				local eid = EntityLoad("data/entities/misc/worm_rain.xml", px, py)
				EntityAddChild( player_id, eid )
				collected = true
				EntityKill( crystal_id )
			end
		end
	end
	
	if collected then
		GamePrintImportant( "$log_altar_magic_worm", "" )
		
		AddFlagPersistent( "misc_worm_rain" )
	end
end

if ( #hand_statues > 0 ) then
	local collected = false
	
	for _,statue_id in ipairs(hand_statues) do
		local cx, cy = EntityGetTransform( statue_id )
		
		if ( get_distance(x, y, cx, cy) < 64 ) then
			collected = true
			-- spawn bots with monk arms in a circle formation
			local count = 12
			local spawn_x = 400
			local spawn_y = 0
			local rot_inc = math.pi * 2 / count
			for i=1, count do
				local eid = EntityLoad("data/entities/animals/drone_lasership.xml", x + spawn_x, y + spawn_y)
				local arms = EntityLoad("data/entities/misc/monk_arms_standalone.xml", x + spawn_x, y + spawn_y)
				EntityAddChild( eid, arms )
				spawn_x, spawn_y = vec_rotate(spawn_x, spawn_y, rot_inc)
			end
			-- statue disappears
			EntityKill(statue_id)
			EntityLoad("data/entities/buildings/statue_hand_fx.xml", cx, cy)
		end
	end

	if collected then
		GamePrintImportant( "$log_altar_magic_monster", "" )
		AddFlagPersistent( "misc_monk_bots" )
	end
end

if ( #tablets > 0 ) then
	local collected = false
	
	local tx = 0
	local ty = 0
	for i,tablet_id in ipairs(tablets) do
		local in_world = false
		local components = EntityGetComponent( tablet_id, "PhysicsBodyComponent" )
		
		if( components ~= nil ) then
			in_world = true
		end
		
		tx, ty = EntityGetTransform( tablet_id )
		SetRandomSeed( tx+236, ty-4125 )
		
		if in_world then
			local distance = math.abs(x - tx) + math.abs(y - ty)
		
			if ( distance < 56 ) then
				EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", tx, ty)
				EntityConvertToMaterial( tablet_id, "gold")
				collected = true
				EntityKill( tablet_id )
			end
		end
	end
	
	if collected then
		local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
		local tablets_eaten = 0
		
		if( variablestorages ~= nil ) then
			for i,variablestorage in ipairs(variablestorages) do
				if ( ComponentGetValue( variablestorage, "name" ) == "tablets_eaten" ) then
					tablets_eaten = ComponentGetValueInt( variablestorage, "value_int" )
					
					tablets_eaten = tablets_eaten + 1

					ComponentSetValue( variablestorage, "value_int", tablets_eaten )
				end
			end
		end
		
		local spawn_monster = false
		
		if (tablets_eaten > 2) then
			local lower_limit = math.min(tablets_eaten, 8)
			
			local rnd = Random( lower_limit, 9 )
			
			if (rnd == 9) then
				spawn_monster = true
				
				for i=1,3 do
					local ox = Random( -10, 10 )
					local oy = Random( -10, 10 )
					EntityLoad( "data/entities/animals/gazer.xml", x + ox, y + oy )
				end
			end
			
			AddFlagPersistent( "misc_altar_tablet" )
		end
		
		if ( spawn_monster == false ) then
			GamePrintImportant( "$log_altar_magic", "" )
		else
			EntityLoad("data/entities/particles/image_emitters/altar_tablet_curse_symbol.xml", tx, ty)
			GamePrintImportant( "$log_altar_magic_monster", "" )
		end
	end
end