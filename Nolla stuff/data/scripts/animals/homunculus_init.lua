dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local types =
{
	{
		name="slow",
		AnimalAIComponent =
		{
			attack_ranged_entity_file="data/entities/projectiles/deck/bullet_slow.xml",
			attack_ranged_frames_between=100,
			attack_ranged_max_distance=120,
		},
		SpriteComponent =
		{
			image_file="data/enemies_gfx/homunculus_dark.xml",
		},
	},
	{
		name="arrow",
		AnimalAIComponent =
		{
			attack_ranged_entity_file="data/entities/projectiles/deck/bullet.xml",
			attack_ranged_frames_between=50,
			attack_ranged_max_distance=180,
		},
	},
	{
		name="fireball",
		AnimalAIComponent =
		{
			attack_ranged_entity_file="data/entities/projectiles/grenade_scavenger.xml",
			attack_ranged_frames_between=50,
			attack_ranged_max_distance=200,
		},
		SpriteComponent =
		{
			image_file="data/enemies_gfx/homunculus_fire.xml",
		},
	},
	{
		name="laser",
		AnimalAIComponent =
		{
			attack_ranged_entity_file="data/entities/projectiles/deck/laser.xml",
			attack_ranged_frames_between=120,
			attack_ranged_max_distance=240,
		},
		SpriteComponent =
		{
			image_file="data/enemies_gfx/homunculus_laser.xml",
		},
	},
	{
		name="spitter",
		AnimalAIComponent =
		{
			attack_ranged_entity_file="data/entities/projectiles/deck/spitter.xml",
			attack_ranged_frames_between=20,
			attack_ranged_max_distance=150,
		},
		SpriteComponent =
		{
			image_file="data/enemies_gfx/homunculus_heal.xml",
		},
	},
}

local storages = EntityGetComponent( entity_id, "VariableStorageComponent" )
local style = ""
local data

if ( storages ~= nil ) then
	for i,comp in ipairs( storages ) do
		local name = ComponentGetValue2( comp, "name" )
		if ( name == "type" ) then
			style = ComponentGetValue2( comp, "value_string" )
			break
		end
	end
end

if ( #style > 0 ) then
	for i,v in ipairs(types) do
		if ( v.name == style ) then
			data = types[i]
		end
	end
end

if ( data == nil ) then
	SetRandomSeed( x, y * entity_id )
	local rnd = Random( 1, #types )
	data = types[rnd]
end

local players = EntityGetWithTag( "player_unit" )
local player_id
if ( #players > 0 ) then
	player_id = players[1]
end

local max_hp = ( math.floor( y / 512 ) * 0.5 ) + 0.5
if ( player_id ~= nil ) then
	edit_component( player_id, "DamageModelComponent", function(comp,vars)
		max_hp = ComponentGetValue2( comp, "max_hp" ) * 2.0
	end)
end

edit_component( entity_id, "DamageModelComponent", function(comp,vars)
	ComponentSetValue2( comp, "max_hp", max_hp )
	ComponentSetValue2( comp, "hp", max_hp )
end)

for i,v in pairs(data) do
	if ( type( v ) == "table" ) then
		edit_component( entity_id, i, function(comp,vars)
			for a,b in pairs( v ) do
				ComponentSetValue2( comp, a, b )
			end
		end)
	end
end

if EntityHasTag( entity_id, "homing_target" ) then
	EntityRemoveTag( entity_id, "homing_target" )
end

if EntityHasTag( entity_id, "enemy" ) then
	EntityRemoveTag( entity_id, "enemy" )
end