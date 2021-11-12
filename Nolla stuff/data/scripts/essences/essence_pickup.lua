dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/perks/perk_list.lua" )

function item_pickup( entity_item, entity_who_picked, item_name )
	-- fetch perk info ---------------------------------------------------

	local pos_x, pos_y = EntityGetTransform( entity_item )
	
	local essence_name = "ESSENCE_NAME_NOT_DEFINED"
	local essence_desc = "ESSENCE_DESCRIPTION_NOT_DEFINED"
	
	edit_component( entity_item, "ItemComponent", function(comp,vars)
		essence_name = ComponentGetValue( comp, "item_name")
		essence_desc = ComponentGetValue( comp, "ui_description")
	end)

	local id = ""
	edit_component( entity_item, "VariableStorageComponent", function(comp,vars)
		id = ComponentGetValue( comp, "value_string" )
	end)
	
	local ui_icon = "data/ui_gfx/essence_icons/" .. id .. ".png"
	local sprite_icon = "data/items_gfx/essences/" .. id .. ".png"
	
	-- add ui icon etc
	local entity_ui = EntityCreateNew( "" )
	EntityAddComponent( entity_ui, "UIIconComponent", 
	{ 
		name = essence_name,
		description = essence_desc,
		icon_sprite_file = ui_icon
	})
	EntityAddTag( entity_ui, "essence_effect" )
	EntityAddChild( entity_who_picked, entity_ui )
	
	if (id == "fire") then
		local cid = EntityLoad( "data/entities/misc/essences/fire.xml", pos_x, pos_y )
		EntityAddChild( entity_who_picked, cid )
		
		local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
		if( damagemodels ~= nil ) then
			for i,damagemodel in ipairs(damagemodels) do	
				local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
				local explosion_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ))
				projectile_resistance = projectile_resistance * 1.3
				explosion_resistance = explosion_resistance * 1.3
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion_resistance) )
			end
		end
		
	elseif ( id == "laser" ) then
		local cid = EntityLoad( "data/entities/misc/essences/laser.xml", pos_x, pos_y )
		EntityAddChild( entity_who_picked, cid )
	elseif ( id == "air" ) then
		local cid = EntityLoad( "data/entities/misc/essences/air.xml", pos_x, pos_y )
		EntityAddChild( entity_who_picked, cid )
	elseif ( id == "water" ) then
		local cid = EntityLoad( "data/entities/misc/essences/water.xml", pos_x, pos_y )
		EntityAddChild( entity_who_picked, cid )
	elseif ( id == "alcohol" ) then
		local cid = EntityLoad( "data/entities/misc/essences/alcohol.xml", pos_x, pos_y )
		EntityAddChild( entity_who_picked, cid )
	end
	
	GameAddFlagRun( "essence_" .. id )
	AddFlagPersistent( "essence_" .. id )
	
	local globalskey = "ESSENCE_" .. string.upper(id) .. "_PICKUP_COUNT"
	local pickups = tonumber( GlobalsGetValue( globalskey, "0" ) )
	pickups = pickups + 1
	GlobalsSetValue( globalskey, tostring( pickups ) )

	-- cosmetic fx -------------------------------------------------------

	EntityLoad( "data/entities/particles/image_emitters/perk_effect.xml", pos_x, pos_y )
	GamePrintImportant( GameTextGet( "$log_pickedup_perk", GameTextGetTranslatedOrNot( essence_name ) ), essence_desc )
	
	EntityKill( entity_item )
end