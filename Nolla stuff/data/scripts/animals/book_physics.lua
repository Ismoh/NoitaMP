dofile_once("data/scripts/lib/utilities.lua")

function spawn_wand()
	-- check that we only have less than N minions
	local existing_wand_count = 0
	local existing_wands = EntityGetWithTag( "wand_ghost" )
	if ( #existing_wands > 0 ) then
		existing_wand_count = #existing_wands
	end

	if existing_wand_count >= 4 then
		return
	end

	-- spawn
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	x = x + 50
	
	SetRandomSeed( GameGetFrameNum(), x + y + GetUpdatedEntityID() )
	
	local slime = EntityLoad( "data/entities/animals/wand_ghost.xml", x, y )
	edit_component( slime, "VelocityComponent", function(comp,vars)
		local vel_x = Random(-90,90)
		local vel_y = Random(-150,25)
		ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y )
	end)
end

spawn_wand()