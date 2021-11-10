dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local root_id = EntityGetRootEntity( entity_id )
entity_id = EntityGetRootEntity( entity_id )

local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum() + GetUpdatedComponentID(), pos_x + pos_y + entity_id )

local angle = math.rad(Random(0,359))
local length = 250

local vel_x = math.cos( angle ) * length
local vel_y = 0 - math.sin( angle ) * length

EntityRemoveFromParent( entity_id )
shoot_projectile( entity_id, "data/entities/projectiles/deck/bloodtentacle.xml", pos_x + vel_x * 0.1, pos_y + vel_y * 0.1, vel_x, vel_y )