dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )
	
	local rats = EntityGetWithTag( "seed_c" )
	
	if ( #rats > 0 ) then
		local eid = rats[1]
		
		local comp = EntityGetFirstComponent( eid, "VariableStorageComponent", "sunegg_kills" )
		
		if ( comp ~= nil ) then
			local kills = ComponentGetValue2( comp, "value_int" )
			
			kills = kills + 1
			
			print( tostring( kills ) )
			
			ComponentSetValue2( comp, "value_int", kills )
		end
	end
end