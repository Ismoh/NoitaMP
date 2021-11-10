dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

-- do some kind of an effect? throw some particles into the air?
local theta = math.rad( Random( 1, 360 ) )
local length = 5000

local vel_x = math.cos( theta ) * length
local vel_y = 0 - math.sin( theta ) * length

-- print(entity_id)

--shoot_projectile( entity_id, "data/entities/projectiles/deck/lightning.xml", pos_x, pos_y, vel_x, vel_y )
shoot_projectile( entity_id, "data/entities/misc/electricity.xml", pos_x + Random(-28, 28), pos_y + Random(-28, 28), vel_x, vel_y )