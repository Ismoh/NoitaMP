dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

entity_id = EntityGetRootEntity( entity_id )

if ( entity_id ~= NULL_ENTITY ) then
	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		ComponentSetValue( comp, "on_death_explode", "0" )
		ComponentSetValue( comp, "on_lifetime_out_explode", "0" )
	end)
	
	local comps = EntityGetComponent( entity_id, "ExplosionComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			EntitySetComponentIsEnabled( entity_id, v, false )
		end
	end
	
	comps = EntityGetComponent( entity_id, "ExplodeOnDamageComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			EntitySetComponentIsEnabled( entity_id, v, false )
		end
	end
end
