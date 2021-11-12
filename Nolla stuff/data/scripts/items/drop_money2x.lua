dofile( "data/scripts/items/drop_money.lua" )


function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	do_money_drop( 2, true )
end