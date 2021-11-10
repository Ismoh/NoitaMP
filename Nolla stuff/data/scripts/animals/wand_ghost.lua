dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

EntityLoad( "data/entities/items/wand_level_03.xml", pos_x, pos_y)

