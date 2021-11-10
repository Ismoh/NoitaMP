
function portal_teleport_used( entity_teleported, from_x, from_y, to_x, to_y )
	if( IsPlayer( entity_teleported ) ) then
		-- 
		-- print( "teleported from: " .. from_x .. ", " .. from_y )
		-- - 50
		local teleport_back_x = from_x - 50
		local teleport_back_y = from_y 

		GlobalsSetValue( "TELEPORT_SNOWCAVE_BURIED_EYE_POS_X", tostring( teleport_back_x ) )
		GlobalsSetValue( "TELEPORT_SNOWCAVE_BURIED_EYE_POS_Y", tostring( teleport_back_y ) )

		-- for mountain_tree pillars
		AddFlagPersistent( "secret_buried_eye" )
	end
end