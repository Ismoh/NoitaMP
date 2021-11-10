dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()

local comps = EntityGetComponent( entity_id, "LaserEmitterComponent" )
if ( comps ~= nil ) then
	for i,comp in ipairs( comps ) do
		ComponentSetValue2( comp, "is_emitting", true )
	end
end
