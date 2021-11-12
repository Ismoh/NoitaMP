dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetInRadiusWithTag( x, y, 12, "projectile" )
local projectile_id = 0
local projectile = ""

for i,v in ipairs( projectiles ) do
	local shooter_id = 0
	edit_component( v, "ProjectileComponent", function(comp,vars)
		shooter_id = ComponentGetValue2( comp, "mWhoShot" )
	end)
	
	if ( shooter_id ~= entity_id ) then
		projectile_id = v
		break
	end
end

if ( projectile_id ~= nil ) and ( projectile_id ~= NULL_ENTITY ) then
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

	if ( string.len( projectile ) > 0 ) then
		storages = EntityGetComponent( entity_id, "VariableStorageComponent" )
		
		if ( storages ~= nil ) then
			for i,comp in ipairs( storages ) do
				name = ComponentGetValue2( comp, "name" )
				if ( name == "projectile_memory" ) then
					ComponentSetValue2( comp, "value_string", projectile )
					break
				end
			end
		end
	end
end