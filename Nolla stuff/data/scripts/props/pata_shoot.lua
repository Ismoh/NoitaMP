dofile_once("data/scripts/lib/utilities.lua")
local entity_id = GetUpdatedEntityID()
local x, y, r = EntityGetTransform( entity_id )

SetRandomSeed( entity_id * x, GameGetFrameNum() * y )

local r_ = 0 - r + math.pi * 0.5 + Random( -10, 10 ) * 0.03
local vel_x = math.cos( r_ ) * 100
local vel_y = 0 - math.sin( r_ ) * 100

local fx = Random( -240, 240 )
local fy = Random( -240, 240 )
local ft = Random( -240, 240 )

local rnd = Random( 1, 6 )

shoot_projectile( entity_id, "data/entities/projectiles/deck/pata_rocket_" .. tostring( rnd ) .. ".xml", x + vel_x * 0.15, y + vel_y * 0.15, vel_x, vel_y )
PhysicsApplyForce( entity_id, fx, fy )
PhysicsApplyTorque( entity_id, ft )

local comp = EntityGetFirstComponent( entity_id, "VariableStorageComponent", "pata_times_shot" )
if ( comp ~= nil ) then
	local timer = ComponentGetValue2( comp, "value_int" )
	timer = timer + 1
	
	if ( timer > 20 ) then
		EntitySetComponentsWithTagEnabled( entity_id, "pata_active", false )
		EntitySetComponentsWithTagEnabled( entity_id, "pata_inactive", true )
		timer = 0
	end
	
	ComponentSetValue2( comp, "value_int", timer )
end