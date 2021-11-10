dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetInRadiusWithTag( x, y, 24, "projectile" )

SetRandomSeed( x, y )
local rnd = Random( 1, #projectiles )

local projectile_id = projectiles[rnd]
local projectile = ""

local storages = EntityGetComponent( projectile_id, "VariableStorageComponent" )

if ( storages ~= nil ) then
	for i,comp in ipairs( storages ) do
		local name = ComponentGetValue2( comp, "name" )
		if ( name == "projectile_file" ) then
			projectile = ComponentGetValue2( comp, "value_string" )
			break
		end
	end
end

if ( string.len( projectile ) > 0 ) then
	storages = EntityGetComponent( entity_id, "AnimalAIComponent" )
	
	if ( storages ~= nil ) then
		for i,comp in ipairs( storages ) do
			ComponentSetValue2( comp, "attack_ranged_entity_file", projectile )
		end
	end
end