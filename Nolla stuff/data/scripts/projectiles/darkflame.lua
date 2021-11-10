dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
 
SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

pos_x = pos_x + Random(-8, 8)
pos_y = pos_y + Random(-8, 8)

local projectile = shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/darkflame_stationary.xml", pos_x, pos_y, 0, 0 )