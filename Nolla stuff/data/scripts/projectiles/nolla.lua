dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

entity_id = EntityGetRootEntity( entity_id )

if ( entity_id ~= NULL_ENTITY ) then
	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		ComponentSetValue( comp, "lifetime", 1 )
	end)
	
	edit_component( entity_id, "LifetimeComponent", function(comp,vars)
		ComponentSetValue( comp, "lifetime", 1 )
	end)
end
