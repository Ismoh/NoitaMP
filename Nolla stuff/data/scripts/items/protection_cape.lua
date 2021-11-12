dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")


function item_pickup( entity_item, entity_who_picked, item_name )

	local effect_metadatas = 
	{
		protection_fire =
		{
			entity_file = "data/entities/misc/effect_protection_fire.xml",
			cloth_color = 0xFF7f6d54,
			cloth_color_edge = 0xFF9c8970,
		},
		protection_radioactivity =
		{
			entity_file = "data/entities/misc/effect_protection_radioactivity.xml",
			cloth_color = 0xFF546d7f,
			cloth_color_edge = 0xFF70899c,
		},
		breath_underwater =
		{
			entity_file = "data/entities/misc/effect_breath_underwater.xml",
			cloth_color = 0xFF546dff,
			cloth_color_edge = 0xFF7089ff,
		},
	}

	---
	local kind = "protection_radioactivity"
	edit_component( entity_item, "VariableStorageComponent", function(comp,vars)
		kind = ComponentGetValue( comp, "value_string" )
	end)

	---
	local effect_metadata = effect_metadatas[kind]

	---
	local game_effect_entity = LoadGameEffectEntityTo( entity_who_picked, effect_metadata.entity_file )

	-- change cape color
	local children = EntityGetAllChildren( entity_who_picked )
	for i,child in ipairs( children ) do
		if EntityGetName( child ) == "cape" then
			edit_component( child, "VerletPhysicsComponent", function(comp,vars) 
				vars.cloth_color = effect_metadata.cloth_color
				vars.cloth_color_edge = effect_metadata.cloth_color_edge
			end)
		end
	end

	---
	EntityKill( entity_item )
end
