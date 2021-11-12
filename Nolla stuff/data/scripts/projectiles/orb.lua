dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local time  = GameGetFrameNum() / 60.0
local angle = time * 2
local vel_x = math.cos(angle) * 90
local vel_y = -math.sin(angle) * 90

GameEntityPlaySound( entity_id, "duplicate" )
shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/orb.xml", pos_x, pos_y, vel_x, vel_y )