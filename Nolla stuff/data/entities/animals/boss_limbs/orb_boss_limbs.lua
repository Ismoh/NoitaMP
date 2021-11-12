dofile( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity" )

	local angle = 0 - math.atan2(vel_y,vel_x)
	angle = angle + math.rad(10)
	vel_x = math.cos(angle) * 250
	vel_y = 0-math.sin(angle) * 250

	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)