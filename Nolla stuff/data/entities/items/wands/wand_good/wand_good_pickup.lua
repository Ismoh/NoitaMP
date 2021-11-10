dofile( "data/scripts/game_helpers.lua" )
dofile( "data/scripts/lib/utilities.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
	local good_wands = EntityGetWithTag( "wand_good" )
	
	if ( #good_wands > 0 ) then
		for i,entity_id in ipairs(good_wands) do
			local in_world = false
			local components = EntityGetComponent( entity_id, "VelocityComponent" )
			
			if( components ~= nil ) then
				in_world = true
			end
			
			if ( entity_id ~= entity_item ) and in_world then
				local x,y = EntityGetTransform( entity_id )
				EntityLoad( "data/entities/particles/poof_pink.xml", x, y )
				EntityKill( entity_id )
			end
		end
	end
	
	if EntityHasTag( entity_item, "wand_good" ) then
		EntityRemoveTag( entity_item, "wand_good" )
	end
	
	local x,y = EntityGetTransform( entity_item )
	EntityLoad( "data/entities/particles/image_emitters/wand_effect.xml", x, y )
end
