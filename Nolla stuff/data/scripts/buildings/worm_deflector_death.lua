dofile( "data/scripts/game_helpers.lua" )

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local players = EntityGetWithTag( "player_unit" )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	local display_message = false
	
	if ( #players > 0 ) then
		for i,player_id in ipairs(players) do
			local px, py = EntityGetTransform( player_id )
			
			local distance = math.abs( px - x ) + math.abs( py - y )
			
			if ( distance < 240 ) then
				display_message = true
				break
			end
		end
	end
	
	if display_message then
		GamePrintImportant( "$log_worm_deflector_death", "$logdesc_worm_deflector_death" )
	end
end
 