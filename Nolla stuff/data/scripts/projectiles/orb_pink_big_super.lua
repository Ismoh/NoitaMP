dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local amount = 12
local theta = math.pi * 2 / amount
local vx = 120
local vy = 0

for i=1, amount do
	local x = pos_x + vx * 0.07
	local y = pos_y + vy * 0.07
	local projectile = shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/orb_pink_big_super_shrapnel.xml", x, y, vx, vy )
	vx,vy = vec_rotate(vx, vy, theta)
end
