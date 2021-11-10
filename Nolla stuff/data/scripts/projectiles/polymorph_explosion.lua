-- kill self
local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- do some kind of an effect? throw some particles into the air?
EntityLoad( "data/entities/particles/polymorph_explosion.xml", pos_x, pos_y )