dofile( "data/scripts/game_helpers.lua" )

function item_pickup( entity_item, entity_who_picked, name )

	local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
	local variablestorages = EntityGetComponent( entity_who_picked, "VariableStorageComponent" )

	local max_hp_old = 0
	local max_hp = 0
	local multiplier = tonumber( GlobalsGetValue( "HEARTS_MORE_EXTRA_HP_MULTIPLIER", "1" ) )
	
	local x, y = EntityGetTransform( entity_item )

	if( damagemodels ~= nil ) then
		for i,damagemodel in ipairs(damagemodels) do
			max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) )
			max_hp_old = max_hp
			max_hp = max_hp + 2 * multiplier

			local max_hp_cap = tonumber( ComponentGetValue( damagemodel, "max_hp_cap" ) )
			if max_hp_cap > 0 then
				max_hp = math.min( max_hp, max_hp_cap )
			end
			
			-- if( hp > max_hp ) then hp = max_hp end
			ComponentSetValue( damagemodel, "max_hp_old", max_hp_old )
			ComponentSetValue( damagemodel, "max_hp", max_hp )
			ComponentSetValue( damagemodel, "mLastMaxHpChangeFrame", GameGetFrameNum() )
		end
	end

	EntityLoad("data/entities/particles/image_emitters/heart_effect.xml", x, y-12)
	local description = GameTextGet( "$logdesc_heart_evil", tostring(math.floor(max_hp*25)) )
	if max_hp == max_hp_old then
		description =  GameTextGet( "$logdesc_heart_blocked", tostring(math.floor(max_hp*25)) )
	else
		local x_pos,y_pos = EntityGetTransform( entity_who_picked )
		local child_id = EntityLoad( "data/entities/misc/effect_poison_big.xml", x_pos, y_pos )
		EntityAddChild( entity_who_picked, child_id )
	end

	GamePrintImportant( "$log_heart", description )
	GameTriggerMusicCue( "item" )

	-- remove the item from the game
	EntityKill( entity_item )
end
 