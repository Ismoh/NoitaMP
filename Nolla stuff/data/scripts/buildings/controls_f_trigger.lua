dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger()
	local entity_id = EntityGetClosestWithTag( 671, -112, "controls_f" )

	local components = EntityGetAllComponents( entity_id )
	if components == nil then
		return
	end

	for i,comp in ipairs( components ) do 
		EntitySetComponentIsEnabled( entity_id, comp, true )
	end
end