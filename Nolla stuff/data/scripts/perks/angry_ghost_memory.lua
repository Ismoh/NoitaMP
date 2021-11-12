dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetInRadiusWithTag( x, y, 48, "projectile" )

SetRandomSeed( x, y )
local rnd = Random( 1, #projectiles )

local projectile_id = projectiles[rnd]
local projectile = ""

local storages = EntityGetComponent( projectile_id, "VariableStorageComponent" )

if ( storages ~= nil ) then
	for i,comp in ipairs( storages ) do
		name = ComponentGetValue2( comp, "name" )
		if ( name == "projectile_file" ) then
			projectile = ComponentGetValue2( comp, "value_string" )
			break
		end
	end
end

if ( #projectile > 0 ) then
	storages = EntityGetComponent( entity_id, "VariableStorageComponent" )
	
	if ( storages ~= nil ) then
		for i,comp in ipairs( storages ) do
			local name = ComponentGetValue2( comp, "name" )
			if ( name == "projectile_memory" ) then
				ComponentSetValue2( comp, "value_string", projectile )
			end
		end
	end
end

local comp_cd = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "angry_ghost_cooldown" )
if ( comp_cd ~= nil ) then
	local cd = ComponentGetValue2( comp_cd, "value_int" )

	if ( cd > 0 ) then
		cd = cd - 1
		
		ComponentSetValue2( comp_cd, "value_int", cd )
	end
end