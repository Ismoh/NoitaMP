dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
x, y = EntityGetTransform( entity_id )
SetRandomSeed( x, y )

local timing = -1
local fire = false

local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )

if ( variablestorages ~= nil ) then
	for j,storage_id in ipairs(variablestorages) do
		local var_name = ComponentGetValue( storage_id, "name" )
		if ( var_name == "timing" ) then
			timing = ComponentGetValueInt( storage_id, "value_int" )
			
			if (timing == -1) then
				timing = Random( 0, 10 )
			elseif (timing > -1) then
				timing = timing + 1
			end
			
			if (timing == 11) then
				timing = 0
				fire = true
			end
			
			ComponentSetValue( storage_id, "value_int", timing )
		end
	end
end

if fire then
	local vel_x = 0
	local vel_y = 1000
	
	shoot_projectile( entity_id, "data/entities/projectiles/laser_lasergun.xml", x, y + 8, vel_x, vel_y )
end