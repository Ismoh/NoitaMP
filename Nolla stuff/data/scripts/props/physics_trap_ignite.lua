dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )
local offset = 8

-- forces ignition while submerged in liquids
EntityLoad( "data/entities/misc/fire_5_frames.xml", x + offset, y )
EntityLoad( "data/entities/misc/fire_5_frames.xml", x - offset, y )
EntityLoad( "data/entities/misc/fire_5_frames.xml", x, y + offset )
EntityLoad( "data/entities/misc/fire_5_frames.xml", x, y - offset )

