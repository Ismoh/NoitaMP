dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() + GetUpdatedComponentID(), x + y + entity_id )

local angle = math.rad(Random(0,359))
local length = 6000

local vel_x = math.cos( angle ) * length
local vel_y = 0 - math.sin( angle ) * length

shoot_projectile( entity_id, "data/entities/projectiles/lightning.xml", x,y, vel_x, vel_y )