dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

entity_id = EntityGetRootEntity( entity_id )

edit_component( entity_id, "HitboxComponent", function(comp,vars)
	ComponentSetValue2( comp, "damage_multiplier", 1.0 )
end)