dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
	
	local angle = math.deg(0 - math.atan2( vel_y, vel_x ))
	local dist = math.sqrt( vel_y ^ 2 + vel_x ^ 2 )
	angle = math.floor((angle + 22.5) / 45) * 45
	angle = math.rad(angle)

	vel_x = math.cos( angle ) * dist
	vel_y = 0 - math.sin( angle ) * dist

	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)