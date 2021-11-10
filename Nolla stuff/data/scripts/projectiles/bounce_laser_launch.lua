dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local vel_x,vel_y = 0,0

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity" )
end)

local speed = math.sqrt( vel_y ^ 2 + vel_x ^ 2 )

if ( speed < 50 ) then
	local how_many = 4
	local angle = math.pi * 0.5
	local angle_inc = (math.pi * 2) / how_many

	for i=1,how_many do
		local shot_vel_x = math.cos(angle) * 150
		local shot_vel_y = 0 - math.sin(angle) * 150
		
		angle = angle + angle_inc

		shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/bounce_laser.xml", pos_x + shot_vel_x * 0.05, pos_y + shot_vel_y * 0.05, shot_vel_x, shot_vel_y, false )
	end
	
	EntityKill( entity_id )
end