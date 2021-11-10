dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/buildings/wand_trap.lua" )

function item_pickup( entity_item, entity_who_picked, name )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	if( entity_who_picked == entity_id ) then  return  end
	
	if IsPlayer( entity_who_picked ) then
		local do_fx = true

		edit_component( entity_id, "ItemComponent", function(comp,vars)
			if ( ComponentGetValueBool( comp, "has_been_picked_by_player" ) ) then
				do_fx = false
			end
		end)

		if (do_fx) then
			GamePrintImportant( "$itemtitle_wand_pickup", "" )
			shoot_projectile( entity_id, "data/entities/particles/image_emitters/wand_effect.xml", pos_x, pos_y, 0, 0 )
		end
	end
	
	local entity_tags = EntityGetTags( entity_id )
	
	if ( string.find( entity_tags, "trap_wand" ) ~= nil ) then
		trigger_wand_pickup_trap( pos_x, pos_y )
	end
end
