dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()

edit_component( entity_id, "ProjectileComponent", function(comp,vars)
	ComponentSetValue2( comp, "penetrate_world", false )
end)