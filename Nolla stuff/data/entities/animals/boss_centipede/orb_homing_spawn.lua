dofile( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

EntityLoad( "data/entities/particles/muzzle_flashes/muzzle_flash_circular_blue.xml", pos_x, pos_y)
