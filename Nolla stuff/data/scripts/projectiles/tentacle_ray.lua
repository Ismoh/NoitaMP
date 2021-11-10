dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() + GetUpdatedComponentID(), pos_x + pos_y + entity_id )

local angle = math.rad(Random(0,359))
local length = 3000

local vel_x = math.cos( angle ) * length
local vel_y = 0 - math.sin( angle ) * length

-- NOTE: tentacle's mWhoShot will be the projectile, not the actual shooter
local proj_id = shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/tentacle.xml", pos_x, pos_y, vel_x, vel_y )
