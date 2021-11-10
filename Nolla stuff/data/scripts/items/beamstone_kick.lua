dofile_once("data/scripts/lib/utilities.lua")

function kick()
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	pos_y = pos_y + 10

	if EntityGetFirstComponent( entity_id, "PhysicsBodyComponent" ) == nil then
		return -- do nothing if item is in the inventory or hand
	end

	GamePlaySound( "data/audio/Desktop/misc.bank", "misc/beam_from_sky_kick", pos_x, pos_y )
	EntityLoad( "data/entities/particles/beamstone_kick.xml", pos_x, pos_y )
	EntityLoad( "data/entities/misc/beam_from_sky.xml", pos_x, pos_y )
	EntityKill( entity_id )
end