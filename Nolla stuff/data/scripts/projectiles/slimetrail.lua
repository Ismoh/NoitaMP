dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

pos_x = pos_x + rand(-4, 4)
pos_y = pos_y + rand(-4, 4)
local vel_x = rand(-20, 20)
local vel_y = rand(-20, 20)

local projectile = shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/slimeblob.xml", pos_x, pos_y, vel_x, vel_y )