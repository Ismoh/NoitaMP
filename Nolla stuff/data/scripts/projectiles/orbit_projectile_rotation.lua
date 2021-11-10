dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projspeed = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "orbit_projectile_speed" )
local orbits = EntityGetAllChildren( entity_id )

if ( projspeed ~= nil ) and ( orbits ~= nil ) then
	local speed = ComponentGetValue2( projspeed, "value_float" )
	local dist = 24
	
	local id = 0
	
	for i,v in ipairs( orbits ) do
		if EntityHasTag( v, "orbit_projectile" ) then
			local angle = math.pi * 0.5 * id + GameGetFrameNum() * speed
			local rot = 0 - ( angle - math.pi * 0.5 )
			
			if EntityHasTag( v, "orbit_laser" ) then
				dist = 8
			end
			
			local px = x + math.cos( angle ) * dist
			local py = y - math.sin( angle ) * dist
			
			EntitySetTransform( v, px, py, rot )
			EntityApplyTransform( v, px, py, rot )
			
			id = id + 1
		end
	end
end