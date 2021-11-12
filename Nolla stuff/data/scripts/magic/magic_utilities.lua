dofile_once("data/scripts/lib/utilities.lua")


function convert_material( x, y, from_material, to_material, clean_stains )
	if clean_stains == nil then clean_stains = false end

	local entity_id = EntityLoad( "data/entities/misc/magic/convert_material.xml", x, y )
	edit_component( entity_id, "MagicConvertMaterialComponent", function(comp,vars)
		vars.from_material = from_material
		vars.to_material   = to_material
		vars.clean_stains  = clean_stains
	end)
end