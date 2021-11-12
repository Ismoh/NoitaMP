dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once( "data/scripts/game_helpers.lua" )

function wand_fired( wand_entity_id )
	local entity_id    = GetUpdatedEntityID()
	local player_id = EntityGetRootEntity( GetUpdatedEntityID() )
	local x, y = EntityGetTransform( player_id )

	-- find the wand held by the player
	-- number of times shot == how much heath to return
	-- shuffler = more health

	-- local wand = find_the_wand_held( player_id )
	local wand = wand_entity_id

	if( wand ~= nil ) then 
		local ability_comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
		if( ability_comp ~= nil ) then
			
			local edit_count = tonumber( ComponentGetValue2( ability_comp, "stat_times_player_has_edited") ) 
			if( edit_count > 0 ) then
				return
			end

			local n = tonumber( ComponentGetValue2( ability_comp, "stat_times_player_has_shot") ) 
			if( n < 8 ) then
				local heal = 0
				local shuffler = ComponentObjectGetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", "0" )

				if( shuffler == "0" ) then
					-- print("non shuffler")
					if( n == 1 ) then heal = 30 end
					if( n == 2 ) then heal = 15 end
					if( n == 3 ) then heal = 9 end
					if( n == 4 ) then heal = 6 end
					if( n == 5 ) then heal = 4 end
					if( n == 6 ) then heal = 3 end
					if( n == 7 ) then heal = 2 end
				else
					-- print("shuffler") 
					if( n == 1 ) then heal = 48 end
					if( n == 2 ) then heal = 24 end
					if( n == 3 ) then heal = 12 end
					if( n == 4 ) then heal = 8 end
					if( n == 5 ) then heal = 6 end
					if( n == 6 ) then heal = 4 end
					if( n == 7 ) then heal = 2 end
				end

				heal = heal / 25
				heal_entity( player_id, heal )
			end
		end
	end

end