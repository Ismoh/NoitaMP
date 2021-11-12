dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local vel_x, vel_y = 0,0

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)

if ( vel_x ~= 0 ) or ( vel_y ~= 0 ) then
	local angle = 0 - math.atan2( vel_y, vel_x )
	local length = 2000

	local angle_up = angle + 3.1415 * 0.5
	local angle_down = angle - 3.1415 * 0.5
	
	vel_x = math.cos( angle_up ) * length
	vel_y = 0 - math.sin( angle_up ) * length

	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/fireball_ray_small.xml", pos_x, pos_y, vel_x, vel_y )
	
	vel_x = math.cos( angle_down ) * length
	vel_y = 0 - math.sin( angle_down ) * length

	shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/fireball_ray_small.xml", pos_x, pos_y, vel_x, vel_y )
end