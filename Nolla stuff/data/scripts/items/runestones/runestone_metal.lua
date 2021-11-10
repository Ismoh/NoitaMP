dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

EntityLoad( "data/entities/misc/runestone_metal.xml", x, y )