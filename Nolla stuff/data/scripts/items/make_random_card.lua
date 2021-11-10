dofile( "data/scripts/gun/gun_actions.lua" )

function make_random_card()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	
	SetRandomSeed( x, y )

	local item = ""
	local valid = false

	while ( valid == false ) do
		local itemno = Random( 1, #actions )
		local thisitem = actions[itemno]
		item = string.lower(thisitem.id)
		
		if ( thisitem.spawn_requires_flag ~= nil ) then
			local flag_name = thisitem.spawn_requires_flag
			local flag_status = HasFlagPersistent( flag_name )
			
			if flag_status then
				valid = true
			end
		else
			valid = true
		end
	end

	if ( string.len(item) > 0 ) then
		local card_entity = CreateItemActionEntity( item, x, y )
	else
		print( "No valid action entity found!" )
	end
end

make_random_card()