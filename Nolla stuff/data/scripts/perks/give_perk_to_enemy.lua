dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/perk_list.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local targets = EntityGetInRadiusWithTag( x, y, 40, "mortal" )

SetRandomSeed( x, y )

if ( #targets > 0 ) then
	local target = targets[1]
	
	local worm = EntityGetComponent( target, "WormAIComponent" )
	local dragon = EntityGetComponent( target, "BossDragonComponent" )
	local ghost = EntityGetComponent( target, "GhostComponent" )
	local lukki = EntityGetComponent( target, "LimbBossComponent" )
	
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
			
			give_perk_to_enemy( perk_data, target, entity_id, 1 )
		end
	end
end

EntityKill( entity_id )
	