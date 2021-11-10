dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetWithTag( "worm" )
local targets2 = EntityGetWithTag( "lukki" )

if ( #targets > 0 ) then
	for i,target_id in ipairs( targets ) do
		local variablestorages = EntityGetComponent( target_id, "VariableStorageComponent", "worm_smaller_holes" )
		local found = false
		
		if ( variablestorages ~= nil ) then
			found = true
		end

		if ( found == false ) then
			local cid = EntityAddComponent( target_id, "VariableStorageComponent", 
			{ 
				name = "worm_smaller_holes",
			} )
			ComponentAddTag( cid, "worm_smaller_holes" )
			
			edit_component( target_id, "CellEaterComponent", function(comp,vars)
				ComponentSetValue2( comp, "only_stain", true )
			end)
		end
	end
end

if ( #targets2 > 0 ) then
	for i,target_id in ipairs( targets2 ) do
		local variablestorages = EntityGetComponent( target_id, "VariableStorageComponent", "worm_smaller_holes" )
		local found = false
		
		if ( variablestorages ~= nil ) then
			found = true
		end

		if ( found == false ) then
			local cid = EntityAddComponent( target_id, "VariableStorageComponent", 
			{ 
				name = "worm_smaller_holes",
			} )
			ComponentAddTag( cid, "worm_smaller_holes" )
			
			edit_component( target_id, "CellEaterComponent", function(comp,vars)
				ComponentSetValue2( comp, "only_stain", true )
			end)
		end
	end
end