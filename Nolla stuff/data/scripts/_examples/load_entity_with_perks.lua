dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/perk_list.lua" )

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

	if perk_data.func ~= nil and entity_item ~= nil then
		perk_data.func( entity_item, entity_who_picked )
	end

	-- add ui icon etc
	local entity_icon = EntityLoad( "data/entities/misc/perks/enemy_icon.xml", pos_x, pos_y )
	edit_component( entity_icon, "SpriteComponent", function(comp,vars)
		ComponentSetValue( comp, "image_file", perk_data.ui_icon )
	end)
	EntityAddChild( entity_who_picked, entity_icon )
end


function entity_load_give_perks( entity, x, y )
	
	local eid = EntityLoad( entity, x, y )
	if( eid ~= nil ) then
		local comps = EntityGetComponent( eid, "CameraBoundComponent" )
		if( comps ~= nil ) then
			for i,camerabound in ipairs(comps) do
				EntitySetComponentIsEnabled( eid, camerabound, false )	
			end
		end

		-- pick a random perk
		local valid_perks = {}
		
		for i,perk_data in ipairs( perk_list ) do
			if ( perk_data.usable_by_enemies ~= nil ) and perk_data.usable_by_enemies then
				table.insert( valid_perks, i )
			end
		end

		SetRandomSeed( x, y )
		
		if ( #valid_perks > 0 ) then
			local rnd = Random( 1, #valid_perks )
			local result = valid_perks[rnd]
			
			local perk_data = perk_list[result]
			
			give_perk_to_enemy( perk_data, eid, nil )
		end
	end
end


-- this is used for debug purposes. If you CTRL+O and select a lua file it 
-- will list all the functions in the debug UI and you can just click them from there
function SPAWN_SHOTGUNNER()
	local x, y = GameGetCameraPos()
	entity_load_give_perks( "data/entities/animals/shotgunner.xml", x, y )
end