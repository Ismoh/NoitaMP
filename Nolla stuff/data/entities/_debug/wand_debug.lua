dofile_once("data/scripts/gun/procedural/gun_procedural.lua")
dofile_once("data/scripts/gun/gun_actions.lua")

function DEBUG_GetRandomCard()

	local r = Random( 1, #actions )
	return actions[ r ].id 

end


function DEBUG_wand_add_random_cards( gun, entity_id, level )

	local x, y = EntityGetTransform( entity_id )

	local deck_capacity = gun["deck_capacity"]
	local card = ""
	local is_rare = 0

	if( Random( 0, 100 ) < 4 or is_rare == 1 ) then
		local p = Random(0,100) 
		if( p < 77 ) then
			card = GetRandomActionWithType( x, y, level+1, ACTION_TYPE_MODIFIER, 666 )
		--[[
		Arvi (9.12.2020): DRAW_MANY cards were causing oddities as always casts, so testing a different set of always_cast cards
		elseif( p < 94 ) then
			card = GetRandomActionWithType( x, y, level+1, ACTION_TYPE_DRAW_MANY, 666 )
			good_card_count = good_card_count + 1
		]]--
		elseif ( p < 85 ) then
			card = GetRandomActionWithType( x, y, level+1, ACTION_TYPE_MODIFIER, 666 )
		elseif ( p < 93 ) then
			card = GetRandomActionWithType( x, y, level+1, ACTION_TYPE_STATIC_PROJECTILE, 666 )
		else 
			card = GetRandomActionWithType( x, y, level+1, ACTION_TYPE_PROJECTILE, 666 )
		end
		AddGunActionPermanent( entity_id, card )
	end

	for i=1,deck_capacity do
		card = DEBUG_GetRandomCard()
		AddGunAction( entity_id, card )
	end
end


function DEBUG_generate_gun( cost, level, force_unshuffle )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )


	local gun = get_gun_data( cost, level, force_unshuffle )
	make_wand_from_gun_data( gun, entity_id, level )
	wand_add_random_cards( gun, entity_id, level )
end

DEBUG_generate_gun( 180, 11, false )