dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local angle = math.rad( Random( 0, 359 ) )
local length = 100

--local vel_x = math.cos( angle ) * length
--local vel_y = math.sin( angle ) * length
local vel_x = 0
local vel_y = 0

shoot_projectile( entity_id, "data/entities/projectiles/tentacle.xml", pos_x, pos_y, vel_x, vel_y )
