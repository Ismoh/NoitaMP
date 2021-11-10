dofile_once("data/scripts/lib/utilities.lua")

local eid    = GetUpdatedEntityID()
local x, y = EntityGetTransform( eid )

local styles =
{
	{
		name = "darkness",
		setup =
		function( entity_id )
			local animalais = EntityGetComponent( entity_id, "AnimalAIComponent" )
			local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )
			local sprites = EntityGetComponent( entity_id, "SpriteComponent" )
			
			if ( animalais ~= nil ) then
				for i,v in ipairs( animalais ) do
					ComponentSetValue2( v, "attack_ranged_entity_file", "data/entities/projectiles/enlightened_laser_dark_wand.xml" )
				end
			end
			
			if ( damagemodels ~= nil ) then
				for i,v in ipairs( damagemodels ) do
					ComponentObjectSetValue2( v, "damage_multipliers", "explosion", 0.5 )
				end
			end
			
			if ( sprites ~= nil ) and ( sprites[2] ~= nil ) then
				local v = sprites[2]
				
				ComponentSetValue2( v, "image_file", "data/particles/enlightened_alchemist_halo_dark.xml" )
			end
		end,
	},
	{
		name = "electricity",
		setup =
		function( entity_id )
			local animalais = EntityGetComponent( entity_id, "AnimalAIComponent" )
			local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )
			local sprites = EntityGetComponent( entity_id, "SpriteComponent" )
			
			if ( animalais ~= nil ) then
				for i,v in ipairs( animalais ) do
					ComponentSetValue2( v, "attack_ranged_entity_file", "data/entities/projectiles/enlightened_laser_elec_wand.xml" )
				end
			end
			
			if ( damagemodels ~= nil ) then
				for i,v in ipairs( damagemodels ) do
					ComponentObjectSetValue2( v, "damage_multipliers", "electricity", 0.0 )
				end
			end
			
			if ( sprites ~= nil ) and ( sprites[2] ~= nil ) then
				local v = sprites[2]
				
				ComponentSetValue2( v, "image_file", "data/particles/enlightened_alchemist_halo_elec.xml" )
			end
		end,
	},
	{
		name = "light",
		setup =
		function( entity_id )
			local animalais = EntityGetComponent( entity_id, "AnimalAIComponent" )
			local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )
			local sprites = EntityGetComponent( entity_id, "SpriteComponent" )
			
			if ( animalais ~= nil ) then
				for i,v in ipairs( animalais ) do
					ComponentSetValue2( v, "attack_ranged_entity_file", "data/entities/projectiles/enlightened_laser_light_wand.xml" )
				end
			end
			
			if ( damagemodels ~= nil ) then
				for i,v in ipairs( damagemodels ) do
					ComponentObjectSetValue2( v, "damage_multipliers", "ice", 0.2 )
				end
			end
			
			if ( sprites ~= nil ) and ( sprites[2] ~= nil ) then
				local v = sprites[2]
				
				ComponentSetValue2( v, "image_file", "data/particles/enlightened_alchemist_halo_light.xml" )
			end
		end,
	},
	{
		name = "fire",
		setup =
		function( entity_id )
			local animalais = EntityGetComponent( entity_id, "AnimalAIComponent" )
			local damagemodels = EntityGetComponent( entity_id, "DamageModelComponent" )
			local sprites = EntityGetComponent( entity_id, "SpriteComponent" )
			
			if ( animalais ~= nil ) then
				for i,v in ipairs( animalais ) do
					ComponentSetValue2( v, "attack_ranged_entity_file", "data/entities/projectiles/enlightened_laser_fire_wand.xml" )
				end
			end
			
			if ( damagemodels ~= nil ) then
				for i,v in ipairs( damagemodels ) do
					ComponentSetValue2( v, "fire_probability_of_ignition", 0 )
					ComponentObjectSetValue2( v, "damage_multipliers", "fire", 0.0 )
				end
			end
			
			if ( sprites ~= nil ) and ( sprites[2] ~= nil ) then
				local v = sprites[2]
				
				ComponentSetValue2( v, "image_file", "data/particles/enlightened_alchemist_halo_fire.xml" )
			end
		end,
	},
}

SetRandomSeed( x * eid, y * eid )

local rnd = Random( 1, #styles )
local style = styles[rnd]

style.setup( eid )