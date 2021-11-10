dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

EntityLoad("data/entities/particles/knockback_star.xml", pos_x, pos_y)
