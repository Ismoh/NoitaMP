dofile_once("data/scripts/lib/utilities.lua")

function damage_received()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	EntitySetComponentsWithTagEnabled( entity_id, "pata_active", true )
	EntitySetComponentsWithTagEnabled( entity_id, "pata_inactive", false )
end