dofile_once("data/scripts/lib/utilities.lua")
--dofile_once("data/scripts/gun/gun.lua")
local speed = 20

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y, rot = EntityGetTransform( entity_id )

-- velocity
local vel_x,vel_y = GameGetVelocityCompVelocity(entity_id)
vel_x, vel_y = vec_normalize(vel_x, vel_y)
if vel_x == nil then return end
vel_x = vel_x * speed
vel_y = vel_y * speed

local offset_x, offset_y = vec_normalize(vel_x, vel_y)
offset_x, offset_y = vec_rotate(offset_x, offset_y, math.pi*0.5) -- perpendicular to flight direction

-- launch projectiles in parallel
local offset = -3
for i=1,7 do
	-- placement
	local x = pos_x + offset_x * offset
	local y = pos_y + offset_y * offset

	-- slow down projectiles on the side for an arrow-y shape
	local vx, vy = vel_x, vel_y
	local brake = (1 - math.abs(offset) * 0.16)
	vx = vx * brake
	vy = vy * brake

	shoot_projectile_from_projectile(entity_id, "data/entities/projectiles/megalaser_blue_beam.xml", x, y, vx, vy)

	offset = offset + 1
end

-- sound is played here instead of the projectiles to avoid duplicates
GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/megalaser_blue/launch", pos_x, pos_y )

