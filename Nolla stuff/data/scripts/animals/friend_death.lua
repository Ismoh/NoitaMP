dofile_once("data/scripts/lib/utilities.lua")

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	--shoot_projectile( entity_id, "data/entities/projectiles/ultimate_killer_explosion.xml", pos_x, pos_y, 0, 0 )
	
	local tcount = tonumber( GlobalsGetValue( "ULTIMATE_KILLER_KILLS", "0" ) )
	if ( tcount >= 9 ) then
		AddFlagPersistent( "final_secret_orb3" )
	end
end