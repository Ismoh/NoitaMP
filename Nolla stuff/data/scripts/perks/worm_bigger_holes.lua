dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetWithTag( "worm" )

if ( #targets > 0 ) then
	for i,target_id in ipairs( targets ) do
		local variablestorages = EntityGetComponent( target_id, "VariableStorageComponent", "worm_bigger_holes" )
		local found = false
		
		if ( variablestorages ~= nil ) then
			found = true
		end
		
		if ( found == false ) then
			local cid = EntityAddComponent( target_id, "VariableStorageComponent", 
			{ 
				name = "worm_bigger_holes",
			} )
			ComponentAddTag( cid, "worm_bigger_holes" )
			
			EntitySetComponentsWithTagEnabled( target_id, "cell_eater", true )
			
			edit_component( target_id, "WormComponent", function(comp,vars)
				local radius = ComponentGetValue2( comp, "hitbox_radius" )
				local radius2 = ComponentGetValue2( comp, "ground_check_offset" )
				radius = radius * 2.0
				radius2 = radius2 * 2.0
				ComponentSetValue2( comp, "hitbox_radius", radius )
				ComponentSetValue2( comp, "ground_check_offset", radius2 )
			end)
			
			edit_component( target_id, "CellEaterComponent", function(comp,vars)
				local radius = ComponentGetValue2( comp, "radius" )
				radius = radius * 2.0
				ComponentSetValue2( comp, "radius", radius )
				ComponentSetValue2( comp, "only_stain", false )
			end)
		end
	end
end