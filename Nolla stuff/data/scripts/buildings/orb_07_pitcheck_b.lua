dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger( colliding_entity )
	local entity_id    = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )

	if( IsInvisible( colliding_entity ) ) then return end

	local pid = EntityLoad( "data/entities/animals/boss_pit/boss_pit.xml", x - 160, y + 256 )
	PhysicsApplyForce( pid, 0, -80 )
	EntityKill( entity_id )
end