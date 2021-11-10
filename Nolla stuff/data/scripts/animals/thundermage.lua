dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local theta = math.rad( Random( 1,360 ) )
local length = 5000

local vel_x = math.cos( theta ) * length
local vel_y = 0 - math.sin( theta ) * length

shoot_projectile( entity_id, "data/entities/misc/electricity.xml", pos_x, pos_y, vel_x, vel_y )