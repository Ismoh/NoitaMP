
function portal_teleport_used( entity_teleported, from_x, from_y, to_x, to_y )
	if( IsPlayer( entity_teleported ) ) then
		-- remove edit wands
		for _,eid in pairs(EntityGetAllChildren(entity_teleported)) do
			if EntityHasTag(eid, "meditation_cube_effect") then
				EntityKill(eid)
				return
			end
		end
	end
end