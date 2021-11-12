dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

entity_id = EntityGetRootEntity( entity_id )

if ( entity_id ~= NULL_ENTITY ) then
	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		ComponentObjectSetValue( comp, "config_explosion", "explosion_radius", "5" )
	end)
	
	local comps = EntityGetComponent( entity_id, "ExplosionComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			ComponentObjectSetValue( v, "config_explosion", "explosion_radius", "5" )
		end
	end
	
	comps = EntityGetComponent( entity_id, "ExplodeOnDamageComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			ComponentObjectSetValue( v, "config_explosion", "explosion_radius", "5" )
		end
	end
end
