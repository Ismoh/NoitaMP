dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
entity_id = EntityGetRootEntity( entity_id )

local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local angle = math.rad(Random(0,359))
local length = 3000

local vel_x = math.cos( angle ) * length
local vel_y = 0 - math.sin( angle ) * length

shoot_projectile( entity_id, "data/entities/projectiles/deck/fireball_ray.xml", pos_x, pos_y, vel_x, vel_y )