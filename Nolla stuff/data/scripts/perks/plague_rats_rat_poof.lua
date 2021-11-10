dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- do some kind of an effect? throw some particles into the air?
EntityLoad( "data/entities/misc/perks/plague_rats_rat_poof.xml", pos_x, pos_y )
EntityKill( entity_id )