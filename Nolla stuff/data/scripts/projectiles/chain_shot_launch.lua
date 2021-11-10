dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )

local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
local iteration = 0
local projectile_file = ""

if ( comps ~= nil ) then
	for i,v in ipairs( comps ) do
		local n = ComponentGetValue2( v, "name" )
		if ( n == "chain_shot" ) then
			iteration = ComponentGetValue2( v, "value_int" )
		elseif ( n == "projectile_file" ) then
			projectile_file = ComponentGetValue2( v, "value_string" )
		end
	end
end

if ( iteration == 0 ) then
	print( "Chain shot failed" )
elseif ( iteration > 0 ) and ( iteration < 5 ) and ( #projectile_file > 0 ) and ( string.find(projectile_file, "exploding_deer") == nil ) and ( string.find(projectile_file, "pebble") == nil ) then
	iteration = iteration + 1
	local vel_x,vel_y = 0,0
	
	edit_component( entity_id, "VelocityComponent", function(comp,vars)
		vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
	end)
	
	SetRandomSeed( x - vel_x, y + vel_y )
	
	if ( math.abs( vel_x ) + math.abs( vel_y ) < 20 ) then
		vel_x = vel_x + Random( -400, 400 )
		vel_y = vel_y + Random( -400, 400 )
	end
	
	vel_x = vel_x + Random( -10, 10 )
	vel_y = vel_y + Random( -10, 10 )
	
	local eid = shoot_projectile_from_projectile( entity_id, projectile_file, x, y, vel_x, vel_y )
	EntityLoadToEntity( "data/entities/misc/chain_shot.xml", eid )
	EntityAddComponent( eid, "VariableStorageComponent", 
	{ 
		name = "chain_shot",
		value_int = iteration,
	} )	
end