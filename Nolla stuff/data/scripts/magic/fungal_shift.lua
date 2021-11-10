dofile_once("data/scripts/lib/utilities.lua")

materials_from = 
{
	{ probability = 1.0, materials = { "water", "water_static", "water_salt", "water_ice" }, name_material = "water" },
	{ probability = 1.0, materials = { "lava" } },
	{ probability = 1.0, materials = { "radioactive_liquid", "poison", "material_darkness" }, name_material = "radioactive_liquid"},
	{ probability = 1.0, materials = { "oil", "swamp", "peat" }, name_material = "oil" },
	{ probability = 1.0, materials = { "blood" } },	-- NOTE(Olli): I'm not sure if it's a good idea to convert blood, because that often just feels buggy. but let's see.
	{ probability = 1.0, materials = { "blood_fungi", "fungi", "fungisoil" }, name_material = "fungi" },
	{ probability = 1.0, materials = { "blood_cold", "blood_worm" } },
	{ probability = 1.0, materials = { "acid" } },
	{ probability = 0.4, materials = { "acid_gas", "acid_gas_static", "poison_gas", "fungal_gas", "radioactive_gas", "radioactive_gas_static" }, name_material = "acid_gas" },
	{ probability = 0.4, materials = { "magic_liquid_polymorph", "magic_liquid_unstable_polymorph" }, name_material = "magic_liquid_polymorph" },
	{ probability = 0.4, materials = { "magic_liquid_berserk", "magic_liquid_charm", "magic_liquid_invisibility" } },
	{ probability = 0.6, materials = { "diamond" } },
	{ probability = 0.6, materials = { "silver", "brass", "copper" } },
	{ probability = 0.2, materials = { "steam", "smoke" } },
	{ probability = 0.4, materials = { "sand" } },
	{ probability = 0.4, materials = { "snow_sticky" } },
	{ probability = 0.05, materials = { "rock_static" } },
	{ probability = 0.0003, materials = { "gold", "gold_box2d" }, name_material = "gold" },
}

materials_to = 
{
	{ probability = 1.00, material = "water" },
	{ probability = 1.00, material = "lava" },
	{ probability = 1.00, material = "radioactive_liquid" },
	{ probability = 1.00, material = "oil" },
	{ probability = 1.00, material = "blood" },
	{ probability = 1.00, material = "blood_fungi" },
	{ probability = 1.00, material = "acid" },
	{ probability = 1.00, material = "water_swamp" },
	{ probability = 1.00, material = "alcohol" },
	{ probability = 1.00, material = "sima" },
	{ probability = 1.00, material = "blood_worm" },
	{ probability = 1.00, material = "poison" },
	{ probability = 1.00, material = "vomit" },
	{ probability = 1.00, material = "pea_soup" },
	{ probability = 1.00, material = "fungi" },
	{ probability = 0.80, material = "sand" },
	{ probability = 0.80, material = "diamond" },
	{ probability = 0.80, material = "silver" },
	{ probability = 0.80, material = "steam" },
	{ probability = 0.50, material = "rock_static" },
	{ probability = 0.50, material = "gunpowder" },
	{ probability = 0.50, material = "material_darkness" },
	{ probability = 0.50, material = "material_confusion" },
	{ probability = 0.20, material = "rock_static_radioactive" },
	{ probability = 0.02, material = "magic_liquid_polymorph" },
	{ probability = 0.02, material = "magic_liquid_random_polymorph" },
	{ probability = 0.15, material = "magic_liquid_teleportation" },
	{ probability = 0.01, material = "urine" },
	{ probability = 0.01, material = "poo" },
	{ probability = 0.01, material = "void_liquid" },
	{ probability = 0.01, material = "cheese_static" },
}

log_messages = 
{
	"$log_reality_mutation_00",
	"$log_reality_mutation_01",
	"$log_reality_mutation_02",
	"$log_reality_mutation_03",
	"$log_reality_mutation_04",
	"$log_reality_mutation_05",
}


-- DEBUG: validate data
for i,it in ipairs(materials_from) do
	for i2,mat in ipairs(it.materials) do
		CellFactory_GetType( mat ) -- will spam errors if not a material name
	end
end
for i,it in ipairs(materials_to) do
	CellFactory_GetType( it.material ) -- will spam errors if not a material name
end


function get_held_item_material( entity_id )
	local children = EntityGetAllChildren( entity_id )
	if ( children == nil ) then 
		return 0 
	end

	local inventory2_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "Inventory2Component" )
	if ( inventory2_comp ~= nil ) then
		local active_item = ComponentGetValue( inventory2_comp, "mActiveItem" )
		if ( EntityHasTag( active_item, "potion" ) ) then
			return GetMaterialInventoryMainMaterial( active_item )
		end
	end

	return 0
end

-- TODO: pick one of the materials from cape
-- TODO: pick one of the materials from a potion?
function fungal_shift( entity, x, y, debug_no_limits )
	local parent = EntityGetParent( entity )
	if parent ~= 0 then
		entity = parent
	end

	local frame = GameGetFrameNum()
	local last_frame = tonumber( GlobalsGetValue( "fungal_shift_last_frame", "-1000000" ) )
	if frame < last_frame + 60*60*5 and not debug_no_limits then
		return -- long cooldown
	end

	local comp_worldstate = EntityGetFirstComponent( GameGetWorldStateEntity(), "WorldStateComponent" )
	if( comp_worldstate ~= nil and ComponentGetValue2( comp_worldstate, "EVERYTHING_TO_GOLD" ) ) then
		return -- do nothing in case everything is gold
	end

	local iter = tonumber( GlobalsGetValue( "fungal_shift_iteration", "0" ) )
	GlobalsSetValue( "fungal_shift_iteration", tostring(iter+1) )
	if iter > 20 and not debug_no_limits then
		return
	end

	SetRandomSeed( 89346, 42345+iter )

	local converted_any = false

	local rnd = random_create(9123,58925+iter ) -- TODO: store for next change
	local from = pick_random_from_table_weighted( rnd, materials_from )
	local to = pick_random_from_table_weighted( rnd, materials_to )
	local held_material = get_held_item_material( entity )
	local from_material_name = ""

	-- if a potion is equipped, randomly use main material from potion as one of the materials
	if held_material > 0 and random_nexti( rnd, 1, 100 ) <= 75 then
		if random_nexti( rnd, 1, 100 ) <= 50 then
			from = {}
			from.materials = { CellFactory_GetName(held_material) }
		else
			to = {}
			to.material = CellFactory_GetName(held_material)
		end
	end

	-- apply effects
	for i,it in ipairs(from.materials) do
		local from_material = CellFactory_GetType( it )
		local to_material = CellFactory_GetType( to.material )
		from_material_name = string.upper( GameTextGetTranslatedOrNot( CellFactory_GetUIName( from_material ) ) )
		if from.name_material then
			from_material_name = string.upper( GameTextGetTranslatedOrNot( CellFactory_GetUIName( CellFactory_GetType( from.name_material ) ) ) )
		end

		-- convert
		if from_material ~= to_material then
			print(CellFactory_GetUIName(from_material) .. " -> " .. CellFactory_GetUIName(to_material))
			ConvertMaterialEverywhere( from_material, to_material )
			converted_any = true

			-- shoot particles of new material
			GameCreateParticle( CellFactory_GetName(from_material), x-10, y-10, 20, rand(-100,100), rand(-100,-30), true, true )
			GameCreateParticle( CellFactory_GetName(from_material), x+10, y-10, 20, rand(-100,100), rand(-100,-30), true, true )
		end
	end

	-- fx
	if converted_any then
		-- remove tripping effect
		EntityRemoveIngestionStatusEffect( entity, "TRIP" );

		-- audio
		GameTriggerMusicFadeOutAndDequeueAll( 5.0 )
		GameTriggerMusicEvent( "music/oneshot/tripping_balls_01", false, x, y )

		-- particle fx
		local eye = EntityLoad( "data/entities/particles/treble_eye.xml", x,y-10 )
		if eye ~= 0 then
			EntityAddChild( entity, eye )
		end

		-- log
		local log_msg = ""
		if from_material_name ~= "" then
			log_msg = GameTextGet( "$logdesc_reality_mutation", from_material_name )
			GamePrint( log_msg )
		end
		GamePrintImportant( random_from_array( log_messages ), log_msg, "data/ui_gfx/decorations/3piece_fungal_shift.png" )
		GlobalsSetValue( "fungal_shift_last_frame", tostring(frame) )

		-- add ui icon
		local add_icon = true
		local children = EntityGetAllChildren(entity)
		if children ~= nil then
			for i,it in ipairs(children) do
				if ( EntityGetName(it) == "fungal_shift_ui_icon" ) then
					add_icon = false
					break
				end
			end
		end

		if add_icon then
			local icon_entity = EntityCreateNew( "fungal_shift_ui_icon" )
			EntityAddComponent( icon_entity, "UIIconComponent", 
			{ 
				name = "$status_reality_mutation",
				description = "$statusdesc_reality_mutation",
				icon_sprite_file = "data/ui_gfx/status_indicators/fungal_shift.png"
			})
			EntityAddChild( entity, icon_entity )
		end
	end
end
