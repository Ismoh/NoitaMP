dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetWithTag( "potion" )
local total_capacity = tonumber( GlobalsGetValue( "EXTRA_POTION_CAPACITY_LEVEL", "1000" ) ) or 1000

if ( #targets > 0 ) then
	for i,target_id in ipairs( targets ) do
		if ( EntityHasTag( target_id, "extra_potion_capacity" ) == false ) then
			local comp = EntityGetFirstComponentIncludingDisabled( target_id, "MaterialSuckerComponent" )
			
			if ( comp ~= nil ) then
				ComponentSetValue( comp, "barrel_size", total_capacity )
			end
			
			EntityAddTag( target_id, "extra_potion_capacity" )
		end
	end
end