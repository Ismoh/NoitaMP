dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() * entity_id, (pos_x + pos_y) * entity_id )

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
	
	local scale = 20
	local random_adjustment_x = Random( 0 - scale, scale )
	local random_adjustment_y = Random( 0 - scale, scale )

	vel_x = vel_x + random_adjustment_x
	vel_y = vel_y + random_adjustment_y

	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)