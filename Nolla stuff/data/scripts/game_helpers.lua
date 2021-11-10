function play_animation( entity_id, animation_name )
	local sprite_components = EntityGetComponent( entity_id, "SpriteComponent" )
	if( sprite_components ~= nil ) then
		for i,v in ipairs(sprite_components) do
			ComponentSetValue( v, "rect_animation", animation_name)
		end
	end
end

function heal_entity( entity_id, heal_amount )
	local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )
	if( damagemodels ~= nil ) then
		for i,damagemodel in ipairs(damagemodels) do
			local max_hp = tonumber( ComponentGetValue2( damagemodel, "max_hp" ) )
			local current_hp = tonumber( ComponentGetValue2( damagemodel, "hp" ) )
			current_hp = math.min( current_hp + heal_amount, max_hp )
			
			ComponentSetValue2( damagemodel, "hp", current_hp )

			-- gfx effect
			local x, y = EntityGetTransform( entity_id )
			local entity_fx = EntityLoad( "data/entities/particles/heal_effect.xml", x, y )
			EntityAddChild( entity_id, entity_fx )
		end
	end
end

function load_gold_entity( entity_filename, x, y, remove_timer )
	local gold_entity = EntityLoad( entity_filename, x, y )
	if( remove_timer ) then
		local lifetime_components = EntityGetComponent( gold_entity, "LifetimeComponent" )
		if( lifetime_components ~= nil ) then
			for i,lifetime_comp in ipairs(lifetime_components) do
				EntityRemoveComponent( gold_entity, lifetime_comp )
			end
		end
	end
	return gold_entity
end

function give_perk_to_enemy( perk_data, entity_who_picked, entity_item )
	-- fetch perk info ---------------------------------------------------

	local pos_x, pos_y = EntityGetTransform( entity_who_picked )

	local perk_id = perk_data.id
	
	-- add game effect
	if perk_data.game_effect ~= nil then
		local game_effect_comp = GetGameEffectLoadTo( entity_who_picked, perk_data.game_effect, true )
		if game_effect_comp ~= nil then
			ComponentSetValue( game_effect_comp, "frames", "-1" )
		end
	end
	
	if perk_data.func_enemy ~= nil then
		perk_data.func_enemy( entity_item, entity_who_picked )
	elseif perk_data.func ~= nil then
		perk_data.func( entity_item, entity_who_picked )
	end

	-- add ui icon etc
	local entity_icon = EntityLoad( "data/entities/misc/perks/enemy_icon.xml", pos_x, pos_y )
	edit_component( entity_icon, "SpriteComponent", function(comp,vars)
		ComponentSetValue( comp, "image_file", perk_data.ui_icon )
	end)
	EntityAddChild( entity_who_picked, entity_icon )
end

function give_random_perk_to_enemy( entity_id )
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