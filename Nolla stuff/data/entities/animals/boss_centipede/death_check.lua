dofile_once( "data/scripts/lib/utilities.lua" )

function death()
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform( entity_id )
	
	local sun = EntityGetInRadiusWithTag( x, y, 540, "seed_e" )
	local sun2 = EntityGetInRadiusWithTag( x, y, 540, "seed_f" )
	
	if ( #sun > 0 ) or ( #sun2 > 0 ) then
		print( "SUN DETECTED" )
		GameAddFlagRun( "sun_kill" )
	end
end