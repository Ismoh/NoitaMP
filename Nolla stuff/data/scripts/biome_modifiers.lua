dofile_once( "data/scripts/lib/utilities.lua" )

CHANCE_OF_MODIFIER_PER_BIOME = 0.1
CHANCE_OF_MODIFIER_COALMINE = 0.2
CHANCE_OF_MODIFIER_EXCAVATIONSITE = 0.15
CHANCE_OF_MOIST_FUNGICAVE = 0.5
CHANCE_OF_MOIST_LAKE = 0.75

-- NOTE: at the moment the modifiers aren't serialized. it is assumed the modifiers stay static throughout a single run.
-- this script re-applies the modifiers every time the game systems are initialized (through init_biome_modifiers() and biome_modifiers_inject_spawns()).
-- because of that the biomes shouldn't be modified outside those hooks, because the changes would be lost after the game is saved/loaded.

biomes =
{
	{"coalmine","mountain_hall"},
	{"coalmine_alt"},
	{"excavationsite"},
	{"fungicave"},
	{"snowcave"},
	{"snowcastle"},
	{"rainforest","rainforest_open"},
	{"vault"},
	{"crypt"},
}

rnd = nil
biomes_with_modifier = {}

biome_modifiers =
{
	-- fire extinguishes easily, projectiles are slowed down, characters slowly get wet stains, -- TODO: swamp guys spawn, material corrosion
	{
		id = "MOIST",
		ui_description="$biomemodifierdesc_moist",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/moist.png",
		probability=0.7,
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.75 )
			BiomeObjectSetValue( biome_filename, "modifiers", "fire_extinguish_chance", 11 )
			BiomeObjectSetValue( biome_filename, "modifiers", "random_water_stains_chance", 5 )
			BiomeObjectSetValue( biome_filename, "modifiers", "random_water_stains_amount", 5 )
			BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 0.965 )
		end,
	},
	-- fog of war slowly reappears
	{
		id = "FOG_OF_WAR_REAPPEARS",
		ui_description="$biomemodifierdesc_fog_of_war_reappears",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/fog_of_war.png",
		probability=1,
		does_not_apply_to_biome={"mountain_hall",},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "fog_of_war_delta", 2 )
		end,
	},
	-- projectiles and most entities get higher gravity (doesn't affect physics or particles)
	{
		id = "HIGH_GRAVITY",
		ui_description="$biomemodifierdesc_high_gravity",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/high_gravity.png",
		probability=0.5,
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "entity_gravity_y_multiplier", 1.5 )
		end,
	},
	-- projectiles and most entities get lower gravity (doesn't affect physics or particles)
	{
		id = "LOW_GRAVITY",
		ui_description="$biomemodifierdesc_low_gravity",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/low_gravity.png",
		probability=0.5,
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "entity_gravity_y_multiplier", 0.5 )
		end,
	},
	-- conductive - all materials conduct electricity
	{
		id = "CONDUCTIVE",
		ui_description="$biomemodifierdesc_conductive",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/conductive.png",
		probability=0.2,
		does_not_apply_to_biome={"mountain_hall",},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "everything_is_conductive", true )
		end,
		inject_spawns_action = function()
			inject_spawn( g_props, 2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics/trap_electricity_enabled.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics/trap_laser_enabled.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics/trap_laser_enabled_left.xml",
			})
			inject_spawn( g_small_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/animals/thunderskull.xml"
			})
			inject_spawn( g_lamp, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_hanging_wire.xml",
			})
			inject_spawn( g_vines, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_hanging_wire.xml",
			})
		end,
	},
	-- freezing - liquids freeze
	{
		id = "FREEZING",
		ui_description="$biomemodifierdesc_freezing",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/freezing.png",
		probability=0.0,
		action = function( biome_name, biome_filename )

			BiomeObjectSetValue( biome_filename, "modifiers", "reaction_freeze_chance", 5 )
			-- replace grass, moss etc with snow
			local frozen_veg_type = "grass_ice"
			--if random_next( rnd, 0, 1 ) >= 0.5 then frozen_veg_type = "ice_static" end
			BiomeVegetationSetValue( biome_filename, "grass", "tree_material", frozen_veg_type )
			BiomeVegetationSetValue( biome_filename, "moss", "tree_material", frozen_veg_type )
			BiomeVegetationSetValue( biome_filename, "snow", "tree_probability", 0.83 ) -- enable disabled snow VegetationComponents
			BiomeVegetationSetValue( biome_filename, frozen_veg_type, "grass_requires_neighbors", false )
			-- cosmetic
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.6 )
			BiomeSetValue( biome_filename, "color_grading_r", 0.90 )
			BiomeSetValue( biome_filename, "color_grading_g", 0.95 )
			BiomeSetValue( biome_filename, "color_grading_b", 1.10 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.107 )
		end,
	},
	-- hot - frozen materials melt
	{
		id = "HOT",
		ui_description="$biomemodifierdesc_hot",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/hot.png",
		probability=0.6,
		does_not_apply_to_biome={"mountain_hall",}, --does_not_apply_to_biome={"snowcave","snowcastle",},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "reaction_unfreeze_chance", 12 )
			BiomeVegetationSetValue( biome_filename, "grass", "tree_material", "grass_dry" )
			BiomeVegetationSetValue( biome_filename, "fungus_loose", "tree_probability", 0.0 ) -- no mushrooms in dry biome
			BiomeSetValue( biome_filename, "color_grading_r", 1.00 )
			BiomeSetValue( biome_filename, "color_grading_g", 0.95 )
			BiomeSetValue( biome_filename, "color_grading_b", 0.9 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.075 )
		end,
		inject_spawns_action = function()
			inject_spawn( g_props, 2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/props/physics_barrel_water.xml",
			})
		end,
	},
	-- gold vein - more gold spawns inside ground
	{
		id = "GOLD_VEIN",
		ui_description="$biomemodifierdesc_gold_vein",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/gold.png",
		probability=0.01,
		does_not_apply_to_biome={"snowcastle",},
		action = function( biome_name, biome_filename )
			if biome_name == "rainforest" or biome_name == "rainforest_open" or biome_name == "vault" or biome_name == "fungicave" then
				BiomeMaterialSetValue( biome_filename, "gold", "material_max", 1.0 ) 
				BiomeMaterialSetValue( biome_filename, "gold", "material_min", 0.9 )
			elseif biome_name == "crypt" then
				BiomeMaterialSetValue( biome_filename, "gold", "material_max", 20 ) 
				BiomeMaterialSetValue( biome_filename, "gold", "material_min", 0.05 )
			else
				BiomeMaterialSetValue( biome_filename, "gold", "material_max", 10 ) 
				BiomeMaterialSetValue( biome_filename, "gold", "material_min", 0.1 )
			end
		end,
	},
	-- gold vein super - tons of gold spawns inside ground
	{
		id = "GOLD_VEIN_SUPER",
		ui_description="$biomemodifierdesc_gold_vein_super",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/gold.png",
		probability=0.00025,
		apply_only_to_biome={"coalmine","coalmine_alt","excavationsite","snowcave",},
		action = function( biome_name, biome_filename )
			if biome_name == "snowcave" or biome_name == "crypt" then
				BiomeMaterialSetValue( biome_filename, "gold", "material_max", 10 ) 
				BiomeMaterialSetValue( biome_filename, "gold", "material_min", 0.05 )
			end

			BiomeMaterialSetValue( biome_filename, "gold", "is_rare", false )
		end,
	},
	-- root growers, swamp & soil materials
	{
		id = "PLANT_INFESTED",
		ui_description="$biomemodifierdesc_plant_infested",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/plant_infested.png",
		probability=1.0,
		does_not_apply_to_biome={"snowcastle","snowcave","rainforest","rainforest_open","mountain_hall"},
		action = function( biome_name, biome_filename ) end,
		inject_spawns_action = function()
			-- plants
			inject_spawn( g_props, 0.9, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/root_grower.xml",
			})
			inject_spawn( g_props2, 0.9, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/root_grower.xml",
			})
			inject_spawn( g_lamp, 2.0, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/root_grower.xml",
			})
			inject_spawn( g_lamp, 1.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/verlet_chains/root/hanging_root_random.xml",
			})
			-- enemies
			inject_spawn( g_small_enemies, 0.03, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,
				entity 	=  "data/entities/animals/rainforest/shooterflower.xml",
			})
			inject_spawn( g_small_enemies, 0.03, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,
				entity 	=  "data/entities/animals/rainforest/bloom.xml",
			})
			-- material pixel scenes
			inject_spawn( g_props, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_swamp_ball.xml",
			})
			inject_spawn( g_props2, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_swamp_ball.xml",
			})
			inject_spawn( g_props, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_grass_ball.xml",
			})
			inject_spawn( g_props2, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_grass_ball.xml",
			})
		end,
	},
	-- random furniture
	{
		id = "FURNISHED",
		ui_description="$biomemodifierdesc_furnished",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/furnished.png",
		probability=0.5,
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			local function add_prop(name, mult)
				mult = mult or 0.5
				inject_spawn( g_props, mult, {
					prob   		= 0,
					min_count	= 1,
					max_count	= 1,
					offset_y 	= 0,    
					entity 	=  "data/entities/props/"..name..".xml",
				})
				inject_spawn( g_props2, mult, {
					prob   		= 0,
					min_count	= 1,
					max_count	= 1,
					offset_y 	= 0,    
					entity 	=  "data/entities/props/"..name..".xml",
				})
			end
			add_prop("furniture_bed")
			add_prop("furniture_wood_chair", 0.75)
			add_prop("furniture_dresser")
			add_prop("furniture_rocking_chair", 0.4)
			add_prop("furniture_wood_table")
			add_prop("furniture_wardrobe", 0.25)
			
			add_prop("furniture_castle_chair", 0.45)
			add_prop("furniture_castle_divan", 0.3)
			add_prop("furniture_castle_statue", 0.3)
			add_prop("furniture_castle_table", 0.3)
			add_prop("furniture_castle_wardrobe", 0.15)

			add_prop("furniture_locker", 0.3)
			add_prop("furniture_footlocker", 0.3)
			add_prop("furniture_bunk", 0.3)
			add_prop("furniture_cryopod", 0.15)
			add_prop("furniture_table", 0.3)
			add_prop("furniture_stool", 0.45)
			-- mimic
			inject_spawn( g_big_enemies, 0.05, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/chest_mimic.xml",
			})
		end,
	},
	-- mines
	{
		id = "BOOBY_TRAPPED",
		ui_description="$biomemodifierdesc_booby_trapped",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/booby_trapped.png",
		probability=0.75,
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_props, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/projectiles/mine.xml",
			})
			inject_spawn( g_props2, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/projectiles/mine.xml",
			})
			inject_spawn( g_small_enemies, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/projectiles/mine.xml",
			})
		end,
	},
	-- tunnels and worms
	{
		id = "PERFORATED",
		ui_description="$biomemodifierdesc_perforated",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/perforated.png",
		probability=0.75,
		does_not_apply_to_biome={"vault","vault_frozen","crypt","snowcave"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_01.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_02.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_02.xml",
			})
			inject_spawn( g_lamp, 0.9, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_01.xml",
			})
			inject_spawn( g_lamp, 0.9, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_02.xml",
			})
			inject_spawn( g_lamp, 0.9, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_hole_02.xml",
			})
			inject_spawn( g_small_enemies, 0.15, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm_tiny.xml",
			})
			inject_spawn( g_big_enemies, 0.15, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm.xml",
			})
			inject_spawn( g_big_enemies, 0.075, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm_big.xml",
			})
		end,
	},
	-- ghosts and tombstones
	{
		id = "SPOOKY",
		ui_description="$biomemodifierdesc_spooky",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/spooky.png",
		probability=0.5,
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_props, 1.0, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/tiny_ghost_spawner.xml",
			})
			inject_spawn( g_props2, 1.0, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/tiny_ghost_spawner.xml",
			})
			inject_spawn( g_lamp, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/tiny_ghost_spawner.xml",
			})
			inject_spawn( g_props, 1.0, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/furniture_tombstone_01.xml",
			})
			inject_spawn( g_props, 1.0, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/furniture_tombstone_02.xml",
			})
			inject_spawn( g_props, 1.0, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/furniture_tombstone_03.xml",
			})
		end,
	},
	-- gravity/repulsion fields
	{
		id = "GRAVITY_FIELDS",
		ui_description="$biomemodifierdesc_gravity_fields",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/gravity_fields.png",
		probability=0.3,
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )
			--BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 1.1 )
		end,
		inject_spawns_action = function()
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field.xml",
			})
			inject_spawn( g_lamp, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field.xml",
			})

			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field_reverse.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field_reverse.xml",
			})
			inject_spawn( g_lamp, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/gravity_field_reverse.xml",
			})
		end,
	},
	-- fungus props
	{
		id = "FUNGAL",
		ui_description="$biomemodifierdesc_fungal",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/fungal.png",
		probability=0.5,
		does_not_apply_to_biome={"mountain_hall","snowcastle","snowcave","fungicave"},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.6 )
			BiomeSetValue( biome_filename, "color_grading_r", 0.90 )
			BiomeSetValue( biome_filename, "color_grading_g", 1.10 )
			BiomeSetValue( biome_filename, "color_grading_b", 0.95 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.12 )
		end,
		inject_spawns_action = function()
			local physics_fungus_mult = 0.9
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus.xml",
			})
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_big.xml",
			})
			inject_spawn( g_props, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_small.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_big.xml",
			})
			inject_spawn( g_props2, physics_fungus_mult, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/physics_fungus_small.xml",
			})
			-- enemies
			inject_spawn( g_small_enemies, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 5,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/fungus.xml",
			})
			inject_spawn( g_small_enemies, 0.2, {
				prob   		= 0,
				min_count	= 2,
				max_count	= 5,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/blob.xml",
			})
			inject_spawn( g_big_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 4,
				offset_y 	= 0,    
				entity 	= "data/entities/animals/fungus_big.xml",
			})
		end,
	},
	-- leaky pipes and water material blobs
	{
		id = "FLOODED",
		ui_description="$biomemodifierdesc_flooded",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/moist.png",
		probability=0.75,
		does_not_apply_to_biome={"mountain_hall","rainforest","rainforest_open","snowcave","vault"},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.3 )
			BiomeSetValue( biome_filename, "color_grading_r", 0.90 )
			BiomeSetValue( biome_filename, "color_grading_g", 0.95 )
			BiomeSetValue( biome_filename, "color_grading_b", 1.05 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.12 )
		end,
		inject_spawns_action = function()
			-- leaky pipes
			inject_spawn( g_lamp, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/drain_pipe_spawner.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/drain_pipe_spawner.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/drain_pipe_spawner.xml",
			})
			-- materials
			inject_spawn( g_props, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_water_ball.xml",
			})
			inject_spawn( g_props2, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_water_ball.xml",
			})
			inject_spawn( g_lamp, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/terrain_water_ball.xml",
			})
			inject_spawn( g_small_enemies, 0.4, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/shaman.xml",
			})
		end,
	},
	-- acid gas pipes
	{
		id = "GAS_FLOODED",
		ui_description="$biomemodifierdesc_gas_glooded",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/gas.png",
		probability=0.5,
		does_not_apply_to_biome={"mountain_hall","excavationsite","snowcave","snowcastle","vault","crypt"},
		action = function( biome_name, biome_filename )
			BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.5 )
			BiomeSetValue( biome_filename, "color_grading_r", 0.9 )
			BiomeSetValue( biome_filename, "color_grading_g", 1.05 )
			BiomeSetValue( biome_filename, "color_grading_b", 0.9 )
			BiomeSetValue( biome_filename, "color_grading_grayscale", 0.1 )
		end,
		inject_spawns_action = function()
			-- leaky pipes
			inject_spawn( g_lamp, 1.0, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/gas_pipe_spawner.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/gas_pipe_spawner_floor.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	= "data/entities/buildings/biome_modifiers/gas_pipe_spawner_floor.xml",
			})
			-- enemies
			inject_spawn( g_small_enemies, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/acidshooter.xml",
			})
			inject_spawn( g_big_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/giantshooter.xml",
			})
		end,
	},
	-- energy shields and forcefield generators
	{
		id = "SHIELDED",
		ui_description="$biomemodifierdesc_shielded",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/shielded.png",
		probability=0.1,
		does_not_apply_to_biome={"mountain_hall","excavationsite","snowcave"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_small_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/energy_shield_sector_spawner.xml",
			})
			inject_spawn( g_props, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/energy_shield_sector_spawner.xml",
			})
			inject_spawn( g_props2, 0.75, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/energy_shield_sector_spawner.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/forcefield_generator.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/props/forcefield_generator.xml",
			})
		end,
	},
	-- Creates fields that grant temporary invulnerability to enemies
	{
		id = "PROTECTION_FIELDS",
		ui_description="$biomemodifierdesc_sunlight",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/sunlight.png",
		probability = 0.2,
		requires_flag = "moon_is_sun",
		does_not_apply_to_biome={"mountain_hall"},
		action = function( biome_name, biome_filename )
			--BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 1.1 )
		end,
		inject_spawns_action = function()
			inject_spawn( g_props, 0.8, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/protection_field.xml",
			})
			inject_spawn( g_props2, 0.7, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/protection_field.xml",
			})
			inject_spawn( g_lamp, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/protection_field.xml",
			})
		end,
	},
	{
		id = "OMINOUS",
		ui_description="$biomemodifierdesc_sundark",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/ominous.png",
		probability = 0.2,
		requires_flag = "darkmoon_is_darksun",
		does_not_apply_to_biome={"mountain_hall","coalmine","excavationsite"},
		action = function( biome_name, biome_filename )
			--BiomeObjectSetValue( biome_filename, "modifiers", "projectile_drag_coeff", 1.1 )
		end,
		inject_spawns_action = function()
			inject_spawn( g_props, 0.3, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/ominous_orb.xml",
			})
			inject_spawn( g_props2, 0.4, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/ominous_orb.xml",
			})
			inject_spawn( g_lamp, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/ominous_orb.xml",
			})
		end,
	},
	{
		id = "INVISIBILITY",
		ui_description="$biomemodifierdesc_invisibility",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/invisible.png",
		probability=0.1,
		does_not_apply_to_biome={"mountain_hall","coalmine"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_small_enemies, 0.1, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/invisibility_machine.xml",
			})
			inject_spawn( g_props, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/invisibility_machine.xml",
			})
			inject_spawn( g_props2, 0.5, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/buildings/biome_modifiers/invisibility_machine.xml",
			})
		end,
	},
	{
		id = "WORMY",
		ui_description="$biomemodifierdesc_wormy",
		ui_decoration_file="data/ui_gfx/decorations_biome_modifier/wormy.png",
		probability=0.05,
		does_not_apply_to_biome={"mountain_hall","coalmine"},
		action = function( biome_name, biome_filename )	end,
		inject_spawns_action = function()
			inject_spawn( g_small_enemies, 0.2, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 2,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm_tiny.xml",
			})
			inject_spawn( g_small_enemies, 0.08, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm.xml",
			})
			inject_spawn( g_big_enemies, 0.08, {
				prob   		= 0,
				min_count	= 1,
				max_count	= 1,
				offset_y 	= 0,    
				entity 	=  "data/entities/animals/worm_big.xml",
			})
		end,
	},
	--[[-- dry - fire spreads faster than usually, fire demons spawn
	-- bouncy - projectiles and physics bodies bounce from surfaces
	-- corrupted - corruption grows everywhere. corruption = some sort of easily destructible static material
	-- toxic - pools of toxic sludge, toxic rock everywhere
	-- vulcanous - lava, lava rock everywhere
	-- haunted - ghost crystals spawn
	-- rat infested - rats spawn everywhere
	-- worm infested - more worm spawn than usually
	-- alchemic - humanoid enemies drop random potions on death
	-- peaceful - enemies don't attack unless projectile spells are used
	-- portal upwards - a box can be found that spawns a portal when kicked
	-- portal downwards - a box can be found that spawns a portal when kicked
	-- more based on various perks?
	]]--
}

-- cosmetic freeze - does not add biome reactions
biome_modifier_cosmetic_freeze = {
	id = "FREEZING_COSMETIC",
	ui_description="$biomemodifierdesc_freezing",
	probability=0,
	action = function( biome_name, biome_filename )

		-- replace grass, moss etc with snow
		local frozen_veg_type = "snow"
		if random_next( rnd, 0, 1 ) >= 0.5 then frozen_veg_type = "ice_static" end
		BiomeVegetationSetValue( biome_filename, "grass", "tree_material", frozen_veg_type )
		BiomeVegetationSetValue( biome_filename, "moss", "tree_material", frozen_veg_type )
		BiomeVegetationSetValue( biome_filename, "snow", "tree_probability", 0.83 ) -- enable disabled snow VegetationComponents
		BiomeVegetationSetValue( biome_filename, frozen_veg_type, "grass_requires_neighbors", false )
		-- cosmetic
		BiomeObjectSetValue( biome_filename, "modifiers", "dust_amount", 0.6 )
		BiomeSetValue( biome_filename, "color_grading_r", 0.85 )
		BiomeSetValue( biome_filename, "color_grading_g", 0.90 )
		BiomeSetValue( biome_filename, "color_grading_b", 1.10 )
		BiomeSetValue( biome_filename, "color_grading_grayscale", 0.1 )
	end,
}

biome_modifier_fog_of_war_clear_at_player = {
	id = "FOG_OF_WAR_CLEAR_AT_PLAYER",
	ui_description="$biomemodifierdesc_fog_of_war_clear_at_player",
	ui_decoration_file="data/ui_gfx/decorations_biome_modifier/fog_of_war_clear_at_player.png",
	probability=0,
	action = function( biome_name, biome_filename )
		BiomeSetValue( biome_filename, "fog_of_war_type", "HEAVY_CLEAR_AT_PLAYER" )
	end,
}

--

function table_clear(t)
    for k,_ in pairs(t) do
        t[k] = nil
    end
end

function inject_spawn(list, probability_mult, new_spawn)
	if list == nil then
		return
	end

	local existing_spawn = nil
	local max_prob = 0.0
	for _,it in ipairs(list) do
		max_prob = math.max(max_prob, it.prob)
		if it.entity == new_spawn.entity then
			existing_spawn = it
		end
	end
	max_prob = math.max( max_prob, 0.3 )

	if existing_spawn then
		existing_spawn.prob = max_prob * probability_mult
		existing_spawn.min_count = new_spawn.min_count
		existing_spawn.max_count = new_spawn.max_count
		existing_spawn.offset_y = new_spawn.offset_y
	else
		new_spawn.prob = max_prob * probability_mult
		table.insert(list, new_spawn)
	end
end

function biome_modifiers_inject_spawns( biome_name )
	local mappings = get_modifier_mappings()
	local modifier = mappings[biome_name]
	if modifier ~= nil and modifier.inject_spawns_action ~= nil then
		modifier.inject_spawns_action(biome_name)
	end
end

---

function biome_material_multiply_value( biome_filename, material_name, field_name, multiplier )
	local value = BiomeMaterialGetValue( biome_filename, material_name, field_name )
	if type(value) == "number" then
		BiomeMaterialSetValue( biome_filename, material_name, field_name, value*multiplier )
	end
end

function biome_modifier_applies_to_biome( modifier, biome_name )
	if modifier == nil then
		return false
	end

	local ok = true
	
	if modifier.requires_flag ~= nil then
		if ( HasFlagPersistent( modifier.requires_flag ) == false ) then
			return false
		end
	end

	if modifier.does_not_apply_to_biome ~= nil then
		for _,skip_biome in ipairs(modifier.does_not_apply_to_biome) do
			if skip_biome == biome_name then
				ok = false
				break
			end
		end
	end

	if modifier.apply_only_to_biome ~= nil then
		ok = false
		for _,required_biome in ipairs(modifier.apply_only_to_biome) do
			if required_biome == biome_name then
				ok = true
				break
			end
		end
	end

	return ok
end

function apply_modifier_from_data( biome_name, modifier )
	local biome_filename = "data/biome/" .. biome_name .. ".xml"

	if rnd == nil then
		rnd = random_create(347893,90734)
	end

	-- ignores?
	local ok = true
	if modifier.does_not_apply_to_biome ~= nil then
		for _,skip_biome in ipairs(modifier.does_not_apply_to_biome) do
			if skip_biome == biome_name then
				ok = false
				break
			end
		end
	end

	if modifier.apply_only_to_biome ~= nil then
		ok = false
		for _,required_biome in ipairs(modifier.apply_only_to_biome) do
			if required_biome == biome_name then
				ok = true
				break
			end
		end
	end
	
	if modifier.requires_flag ~= nil then
		if ( HasFlagPersistent( modifier.requires_flag ) == false ) then
			ok = false
		end
	end

	-- apply
	if ok then
		modifier.action( biome_name, biome_filename )
		BiomeSetValue( biome_filename, "mModifierUIDescription", modifier.ui_description )
		BiomeSetValue( biome_filename, "mModifierUIDecorationFile", modifier.ui_decoration_file or "" )
		table.insert( biomes_with_modifier, biome_name )
	end
end

function apply_modifier( biome_name, modifier_id )
	local biome_filename = "data/biome/" .. biome_name .. ".xml"

	for _,modifier in ipairs(biome_modifiers) do
		if modifier.id == modifier_id then
			apply_modifier_from_data( biome_name, modifier )
			break
		end
	end
end

function get_modifier( modifier_id )
	for _,modifier in ipairs(biome_modifiers) do
		if modifier.id == modifier_id then
			return modifier
		end
	end
	return nil
end

function apply_modifier_if_has_none( biome_name, modifier_id )
	if biomes_with_modifier[biome_name] == nil then
		apply_modifier( biome_name, modifier_id )
	end
end

function has_modifiers(biome_name,ctx)
	if biome_name == "coalmine" and ctx.deaths < 8 and ctx.should_be_fully_deterministic == false then
		return false
	end

	local chance_of_modifier = CHANCE_OF_MODIFIER_PER_BIOME
	if biome_name == "coalmine" then
		chance_of_modifier = CHANCE_OF_MODIFIER_COALMINE
	elseif biome_name == "excavationsite" then
		chance_of_modifier = CHANCE_OF_MODIFIER_EXCAVATIONSITE
	end

	return random_next(ctx.rnd, 0.0, 1.0) <= chance_of_modifier
end


function get_modifier_mappings()
	-- returns a table mapping biome_names to active_modifiers.
	-- this function should be deterministic, and have no side effects.
	local result = {}

	local set_modifier_if_has_none = function( biome_name, modifier_id )
		if result[biome_name] == nil then
			result[biome_name] = get_modifier( modifier_id )
		end
	end

	rnd = random_create(347893,90734)
	local ctx = { }
	ctx.rnd = rnd
	ctx.deaths = tonumber(StatsGlobalGetValue( "death_count" ))
	ctx.should_be_fully_deterministic = GameIsModeFullyDeterministic()

	for _,biome_names in ipairs(biomes) do
		local modifier = nil
		if has_modifiers( biome_names[1], ctx ) then
			modifier = pick_random_from_table_weighted( rnd, biome_modifiers )
		end

		for _,biome_name in ipairs(biome_names) do
			if biome_modifier_applies_to_biome( modifier, biome_name ) then
				result[biome_name] = modifier
			end
		end
	end

	-- DEBUG - apply modifier to all biomes
	for _,biome_names in ipairs(biomes) do
		for _,biome_name in ipairs(biome_names) do
			--result[biome_name] = get_modifier( "GAS_FLOODED" )
		end
	end

	if( random_next( rnd, 0.0, 1.0 ) < CHANCE_OF_MOIST_FUNGICAVE ) then
		set_modifier_if_has_none( "fungicave", "MOIST" )
	end

	-- force custom fog of war in these biomes
	result["wandcave"] = biome_modifier_fog_of_war_clear_at_player
	result["wizardcave"] = biome_modifier_fog_of_war_clear_at_player
	result["alchemist_secret"] = biome_modifier_fog_of_war_clear_at_player
	--apply_modifier_if_has_none( "snowcave", "FREEZING" )

	-- side biomes
	set_modifier_if_has_none( "mountain_top", "FREEZING" ) -- NOTE: Freezing tends to occasionally bug out physics bodies, only put it in overworld biomes
	set_modifier_if_has_none( "mountain_floating_island", "FREEZING" ) 
	set_modifier_if_has_none( "winter", "FREEZING" )
	result["winter_caves"] = biome_modifier_cosmetic_freeze
	--apply_modifier_if_has_none( "bridge", "FREEZING" )
	--apply_modifier_if_has_none( "vault_frozen", "FREEZING" )

	set_modifier_if_has_none( "lavalake", "HOT" )
	set_modifier_if_has_none( "desert", "HOT" )
	set_modifier_if_has_none( "pyramid_entrance", "HOT" )
	set_modifier_if_has_none( "pyramid_left", "HOT" )
	set_modifier_if_has_none( "pyramid_top", "HOT" )
	set_modifier_if_has_none( "pyramid_right", "HOT" )

	set_modifier_if_has_none( "watercave", "MOIST" )

	if( random_next( rnd, 0.0, 1.0 ) < CHANCE_OF_MOIST_LAKE ) then
		set_modifier_if_has_none( "lake_statue", "MOIST" )
	end

	return result
end

function init_biome_modifiers()
	local mappings = get_modifier_mappings()
	
	for biome_name,modifier in pairs(mappings) do
		if modifier ~= nil then
			apply_modifier_from_data( biome_name, modifier )
		end
	end
end

return init_biome_modifiers


-- TODO:
-- FREEZING - VegetationComponent modifications to add any or more snow/ice to rainforest, crypt and vault
-- CONDUCTIVE - some particle fx?, spawn thundermages
-- MOIST - burning status is shorter