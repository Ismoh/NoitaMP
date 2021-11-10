dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

entity_id = EntityGetRootEntity( entity_id )

if ( entity_id ~= NULL_ENTITY ) then
	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		ComponentSetValue2( comp, "bounce_always", false )
		ComponentSetValue2( comp, "bounces_left", 0 )
	end)
end
