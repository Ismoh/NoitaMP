dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local eid = EntityLoad( "data/entities/particles/particle_explosion/explosion_trail_swirl_green_slow.xml", pos_x, pos_y )