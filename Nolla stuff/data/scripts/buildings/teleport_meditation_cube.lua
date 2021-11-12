
function portal_teleport_used( entity_teleported, from_x, from_y, to_x, to_y )
	if( IsPlayer( entity_teleported ) ) then
		-- 
		-- print( "teleported from: " .. from_x .. ", " .. from_y )
		-- - 50
		local teleport_back_x = from_x
		local teleport_back_y = from_y + 20

		-- apply edit wands effect when teleporting for the first time
		if GlobalsGetValue( "TELEPORT_MEDITATION_CUBE_POS_X", "" ) == "" then
			local x,y = EntityGetTransform(entity_teleported)
			local e = EntityLoad("data/entities/buildings/teleport_meditation_cube_playereffect.xml", x, y)
			EntityAddChild( entity_teleported, e )
		end

		GlobalsSetValue( "TELEPORT_MEDITATION_CUBE_POS_X", tostring( teleport_back_x ) )
		GlobalsSetValue( "TELEPORT_MEDITATION_CUBE_POS_Y", tostring( teleport_back_y ) )

		-- for mountain_tree pillars
		AddFlagPersistent( "secret_meditation" )
	end
end