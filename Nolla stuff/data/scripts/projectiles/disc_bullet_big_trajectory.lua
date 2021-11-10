dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local angle,speed = -1,-1
local vel_x,vel_y = 0,0

local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )

if ( variablestorages ~= nil ) then
	for i,varstor in ipairs( variablestorages ) do
		local name = ComponentGetValue( varstor, "name" )
		
		if ( name == "angle" ) then
			angle = tonumber( ComponentGetValue( varstor, "value_string" ) )
		elseif ( name == "speed" ) then
			speed = tonumber( ComponentGetValue( varstor, "value_string" ) )
		end
	end
end

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)

if ( speed ~= -1 ) and ( speed > -200 ) then
	speed = speed - 60
end

if ( angle == -1 ) or ( speed == -1 ) then
	angle = 0 - math.atan2( vel_y, vel_x )
	angle = math.floor( math.deg( angle ) )
	
	speed = math.sqrt( vel_y * vel_y + vel_x * vel_x )
	
	if ( variablestorages ~= nil ) then
		for i,varstor in ipairs( variablestorages ) do
			local name = ComponentGetValue( varstor, "name" )
			
			if ( name == "angle" ) then
				ComponentSetValue( varstor, "value_string", angle )
			elseif ( name == "speed" ) then
				ComponentSetValue( varstor, "value_string", speed )
			end
		end
	end
else
	if ( variablestorages ~= nil ) then
		for i,varstor in ipairs( variablestorages ) do
			local name = ComponentGetValue( varstor, "name" )
			
			if ( name == "speed" ) then
				ComponentSetValue( varstor, "value_string", speed )
			end
		end
	end
end

local angle_rad = math.rad( angle )
local multiplier = 0.1

vel_x = vel_x + math.cos( angle_rad ) * speed * multiplier
vel_y = vel_y - math.sin( angle_rad ) * speed * multiplier

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)