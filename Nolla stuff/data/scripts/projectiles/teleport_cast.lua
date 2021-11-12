dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local targets = EntityGetInRadiusWithTag( pos_x, pos_y, 96, "homing_target" )

SetRandomSeed( pos_x + pos_y, GameGetFrameNum() )

if ( #targets > 0 ) then
	local rnd = Random(1, #targets)
	local target_id = targets[rnd]
	
	local tx, ty = EntityGetFirstHitboxCenter( target_id )
	
	EntitySetTransform( entity_id, tx, ty )
end