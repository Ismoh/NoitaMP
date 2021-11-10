dofile_once("data/scripts/lib/utilities.lua")

function shot()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	local radius = 220
	local limit = 15
	local limitlocal = 12
	
	local scomp = 0
	local count = 0
	local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			local n = ComponentGetValue2( v, "name" )
			if ( n == "sausage_max" ) then
				scomp = v
				count = ComponentGetValue2( v, "value_int" )
				break
			end
		end
	end
	
	local targets = EntityGetInRadiusWithTag( x, y, radius, "projectile_item" )
	local comp = EntityGetFirstComponent( entity_id, "AnimalAIComponent" )

	if ( comp ~= nil ) and ( scomp ~= 0 ) then
		if ( #targets < limit ) and ( count < limitlocal ) then
			ComponentSetValue2( comp, "attack_ranged_enabled", true )
			
			count = count + 1
		else
			ComponentSetValue2( comp, "attack_ranged_enabled", false )
		end
	end
	
	ComponentSetValue2( scomp, "value_int", count )
end