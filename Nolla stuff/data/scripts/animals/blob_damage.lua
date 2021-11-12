dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

	if( entity_who_caused == entity_id ) then return end

	local herd_id = component_get_value( entity_id, "GenomeDataComponent", "herd_id", 0 )

	edit_component( entity_id, "ControlsComponent", function(comp,vars)
		ComponentSetValueVector2( comp, "mJumpVelocity", Random(-70, 70), Random(-150, -300))
	end)
	
	local health = 0
	local max_health = 0
	
	edit_component( entity_id, "DamageModelComponent", function(comp,vars)
		health = tonumber(ComponentGetValue( comp, "hp"))
		max_health = tonumber(ComponentGetValue( comp, "max_hp"))
	end)
	
	local minion_count = 4
	local minion_interval = max_health / minion_count
	
	local new_health = health - damage
	local nearest_interval = math.floor( health / minion_interval ) * minion_interval
	
	local limit = 7
	local count = 0
	
	while (nearest_interval > new_health) and (count < limit) and (nearest_interval >= 0) do
		GameEntityPlaySound( entity_id, "duplicate" )
		
		pos_x = pos_x + Random(-4, 4)
		pos_y = pos_y + Random(-4, 4)
		local e = EntityLoad( "data/entities/animals/miniblob.xml", pos_x, pos_y )
		
		nearest_interval = nearest_interval - minion_interval
		
		count = count + 1
	end
end
