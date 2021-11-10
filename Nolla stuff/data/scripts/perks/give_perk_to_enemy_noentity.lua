dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/perk_list.lua" )

function give_random_perk( entity_id )
	local x, y = EntityGetTransform( entity_id )
	
	SetRandomSeed( x, y )

	local worm = EntityGetComponent( entity_id, "WormAIComponent" )
	local dragon = EntityGetComponent( entity_id, "BossDragonComponent" )
	local ghost = EntityGetComponent( entity_id, "GhostComponent" )
	local lukki = EntityGetComponent( entity_id, "LimbBossComponent" )
	
	if ( worm == nil ) and ( dragon == nil ) and ( ghost == nil ) and ( lukki == nil ) then
		local valid_perks = {}
		
		for i,perk_data in ipairs( perk_list ) do
			if ( perk_data.usable_by_enemies ~= nil ) and perk_data.usable_by_enemies then
				table.insert( valid_perks, i )
			end
		end
		
		if ( #valid_perks > 0 ) then
			local rnd = Random( 1, #valid_perks )
			local result = valid_perks[rnd]
			
			local perk_data = perk_list[result]
			
			give_perk_to_enemy( perk_data, entity_id, 0 )
		end
	end
end