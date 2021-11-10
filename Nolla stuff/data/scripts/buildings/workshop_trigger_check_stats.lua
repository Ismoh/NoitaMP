dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	-- Note! 
	--  * For global stats use StatsGetValue("enemies_killed")
	--  * For biome stats use StatsBiomeGetValue("enemies_killed")
	--
	-- the difference is that StatsBiomeGetValue() tracks the stats diff since calling StatsResetBiome()
	-- which is what workshop_exit calls
	--
	--
	-- this does the workshop rewards for playing in a certain way
	-- 1) killed none
	
	local reference_id = EntityGetClosestWithTag( x, y, "workshop_reference" )

	local enemies_killed = tonumber( StatsBiomeGetValue("enemies_killed") )
	print(enemies_killed)
	if( enemies_killed == 0 ) then
		print("KILLED NONE")
		local sx,sy = x,y
		
		if ( reference_id ~= NULL_ENTITY ) then
			sx,sy = EntityGetTransform( reference_id )
		else
			print("No reference point found for workshop no-kill chest")
		end
		
		print("Loading chest_random.xml to " .. tostring(sx) .. ", " .. tostring(sy))
		local eid = EntityLoad( "data/entities/items/pickup/chest_random.xml", sx, sy )
		change_entity_ingame_name( eid, "$item_chest_treasure_pacifist" )
	else
		print("KILLED ALL")
	end
end