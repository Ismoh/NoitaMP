dofile( "data/scripts/lib/utilities.lua" )

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	-- kill self
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	local flag_status = HasFlagPersistent( "card_unlocked_pyramid" )

	-- do some kind of an effect? throw some particles into the air?
	EntityLoad( "data/entities/items/pickup/heart.xml", pos_x - 16, pos_y )
	EntityLoad( "data/entities/items/wand_unshuffle_04.xml", pos_x, pos_y )
	
	local pw = check_parallel_pos( pos_x )
	SetRandomSeed( pw, 44 )
	
	local opts = { "NOLLA", "DAMAGE_RANDOM", "RANDOM_SPELL", "RANDOM_PROJECTILE", "RANDOM_MODIFIER", "RANDOM_STATIC_PROJECTILE", "DRAW_RANDOM", "DRAW_RANDOM_X3", "DRAW_3_RANDOM" }
	local rnd = Random( 1, #opts )
	
	if flag_status then
		for i=1,4 do
			rnd = Random( 1, #opts )
			CreateItemActionEntity( opts[rnd], pos_x - 8 * 4 + (i-1) * 16, pos_y )
			table.remove( opts, rnd )
		end
	else
		for i=1,4 do
			rnd = Random( 1, #opts )
			CreateItemActionEntity( opts[rnd], pos_x - 8 * 4 + (i-1) * 16, pos_y )
			table.remove( opts, rnd )
		end
		EntityLoad( "data/entities/items/pickup/heart_fullhp.xml",  pos_x, pos_y )
	end
	
	AddFlagPersistent( "card_unlocked_pyramid" )

	--EntityKill( entity_id )
end