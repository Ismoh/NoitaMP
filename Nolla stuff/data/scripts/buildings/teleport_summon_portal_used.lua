function portal_teleport_used( entity_teleported, from_x, from_y, to_x, to_y )
	if( IsPlayer( entity_teleported ) ) then
		-- prevent infinite teleporting loop
		EntityKill(GetUpdatedEntityID())
	end
end