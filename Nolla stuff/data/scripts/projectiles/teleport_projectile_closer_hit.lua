dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local enemy_id = EntityGetRootEntity( entity_id )

local projectiles = EntityGetInRadiusWithTag( x, y, 32, "teleport_projectile_closer" )

if ( #projectiles > 0 ) then
	local pid = projectiles[1]
	local comps = EntityGetComponent( pid, "VariableStorageComponent", "teleport_closer" )
	local ox,oy

	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			local n = ComponentGetValue2( v, "name" )
			
			if ( n == "origin_x" ) then
				ox = ComponentGetValue2( v, "value_float" )
			elseif ( n == "origin_y" ) then
				oy = ComponentGetValue2( v, "value_float" )
			end
		end
	end
	
	-- print( tostring(entity_id) .. ", " .. tostring(enemy_id) )
	
	if ( ox ~= nil ) and ( oy ~= nil ) then
		EntitySetTransform( enemy_id, ox, oy )
		EntityApplyTransform( enemy_id, ox, oy )
	end
end

--EntityKill( entity_id )