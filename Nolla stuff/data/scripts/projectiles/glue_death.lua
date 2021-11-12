dofile_once("data/scripts/lib/utilities.lua")

--function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
--print("rgsx")
	EntityLoad("data/entities/particles/particle_explosion/explosion_glue.xml", pos_x, pos_y)
--end