dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetInRadiusWithTag( x, y, 100, "projectile" )
local targets2 = EntityGetInRadiusWithTag( x, y, 400, "moon_energy" )

local vel_x,vel_y = 0,0

for i,v in ipairs( targets ) do
	if ( i == 1 ) and ( EntityHasTag( v, "projectile_lightning" ) == false ) then
		edit_component( v, "VelocityComponent", function(comp,vars)
			vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
		end)
		
		if ( vel_x ~= 0 ) or ( vel_y ~= 0 ) then
			PhysicsApplyForce( entity_id, vel_x * 0.25, vel_y * 0.25 )
		end
	end
	
	EntityKill( v )
end

for i,v in ipairs( targets2 ) do
	local tx,ty = EntityGetTransform( v )
	local test = EntityGetFirstComponent( v, "LightComponent" )
	
	if ( test ~= nil ) then
		local dir = 0 - math.atan2( ty - y, tx - x )
		
		vel_x = math.cos( dir ) * 240
		vel_y = 0 - math.sin( dir ) * 240
		
		PhysicsApplyForce( entity_id, vel_x, vel_y )
	end
end

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
	
	vel_x = vel_x * 0.95
	vel_y = vel_y * 0.95
	
	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y )
end)

local props = EntityGetInRadiusWithTag( x, y, 10, "pixelsprite" )
for i,v in ipairs( props ) do
	EntityKill( v )
end