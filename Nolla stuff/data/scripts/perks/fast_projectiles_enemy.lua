dofile_once("data/scripts/lib/utilities.lua")

function shot( entity_id )
	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comps ~= nil ) then
		for i,comp in ipairs(comps) do
			local v = ComponentGetValue2( comp, "speed_max" )
			v = v * 1.75
			ComponentSetValue2( comp, "speed_max", v )
			
			v = ComponentGetValue2( comp, "speed_min" )
			v = v * 1.75
			ComponentSetValue2( comp, "speed_min", v )
		end
	end
end