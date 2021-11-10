dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local projectiles = EntityGetInRadiusWithTag( x, y, 64, "projectile" )

if ( #projectiles > 0 ) then
	local p = projectiles[1]
	local p_n = ""
	local comps = EntityGetComponent( p, "VariableStorageComponent" )
	if ( comps ~= nil ) then
		for i,v in ipairs( comps ) do
			local n = ComponentGetValue2( v, "name" )
			if ( n == "projectile_file" ) then
				p_n = ComponentGetValue2( v, "value_string" )
				break
			end
		end
	end
	
	if ( #p_n > 0 ) then
		comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
		if ( comps ~= nil ) then
			for i,v in ipairs( comps ) do
				local n = ComponentGetValue2( v, "name" )
				if ( n == "memory" ) then
					ComponentSetValue2( v, "value_string", p_n )
					break
				end
			end
		end
	end
end