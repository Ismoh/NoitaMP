dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

function wand_fired( wand_entity_id )
	local entity_id    = GetUpdatedEntityID()
	local player_id = EntityGetRootEntity( GetUpdatedEntityID() )

	-- find the wand held by the player
	-- number of times shot == how much heath to return
	-- shuffler = more health

	-- local wand = find_the_wand_held( player_id )
	local wand = wand_entity_id

	if( wand ~= nil ) then 
		local ability_comp = EntityGetFirstComponentIncludingDisabled( wand, "AbilityComponent" )
		if( ability_comp ~= nil ) then
			local n = tonumber( ComponentGetValue2( ability_comp, "stat_times_player_has_shot") ) 
			if( n < 8 ) then
				local heal = 0
				local shuffler = ComponentObjectGetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", "0" )

				if( shuffler == "0" ) then
					-- print("non shuffler")
					if( n == 1 ) then heal = 10 end
					if( n == 2 ) then heal = 5 end
					if( n == 3 ) then heal = 3 end
					if( n == 4 ) then heal = 2 end
					if( n == 5 ) then heal = 1 end
					if( n == 6 ) then heal = 1 end
					if( n == 7 ) then heal = 1 end
				else
					-- print("shuffler") 
					if( n == 1 ) then heal = 16 end
					if( n == 2 ) then heal = 8 end
					if( n == 3 ) then heal = 4 end
					if( n == 4 ) then heal = 2 end
					if( n == 5 ) then heal = 1 end
					if( n == 6 ) then heal = 1 end
					if( n == 7 ) then heal = 1 end
				end

				heal = heal / 25

				local damagemodels = EntityGetComponent( player_id, "DamageModelComponent" )
				if( damagemodels ~= nil ) then
					for i,damagemodel in ipairs(damagemodels) do
						local max_hp = tonumber( ComponentGetValue2( damagemodel, "max_hp" ) )
						local current_hp = tonumber( ComponentGetValue2( damagemodel, "hp" ) )
						current_hp = math.min( current_hp + heal, max_hp )
						
						ComponentSetValue2( damagemodel, "hp", current_hp )
						-- TODO( Petri ): Play heal effect to communicate this to player
					end
				end
			end
		end
	end

end