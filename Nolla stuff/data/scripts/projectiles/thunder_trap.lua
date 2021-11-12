dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local vel_x,vel_y = GameGetVelocityCompVelocity( entity_id )

shoot_projectile( entity_id, "data/entities/projectiles/lightning.xml", x, y, vel_x * 400, 0 )
