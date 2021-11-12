dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local owner_id = 0

local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if ( comp ~= nil ) then
	owner_id = ComponentGetValue2( comp, "mWhoShot" )
end

if ( owner_id ~= nil ) and ( owner_id ~= NULL_ENTITY ) then
	edit_component( entity_id, "VelocityComponent", function(comp2,vars)
		local vel_x,vel_y = ComponentGetValueVector2( comp2, "mVelocity")
		
		local px, py, pr, psx, psy = EntityGetTransform( owner_id )
		
		local angle = 0 - math.atan2( vel_y, vel_x )
		local dist = math.sqrt( vel_y ^ 2 + vel_x ^ 2 )
		
		vel_x = math.cos( angle + psx * 0.33 ) * dist
		vel_y = 0 - math.sin( angle + psx * 0.33) * dist

		ComponentSetValueVector2( comp2, "mVelocity", vel_x, vel_y)
	end)
end