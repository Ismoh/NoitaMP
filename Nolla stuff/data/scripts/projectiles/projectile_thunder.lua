dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local projectiles = EntityGetWithTag( "projectile" )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs(projectiles) do	
		local px, py = EntityGetTransform( projectile_id )
		
		local distance = math.abs( x - px ) + math.abs( y - py )
		
		if ( distance < 64 ) and ( entity_id ~= projectile_id ) then
			distance = math.sqrt( ( x - px ) ^ 2 + ( y - py ) ^ 2 )
	
			if ( distance < 48 ) then
				local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
				
				if ( projectilecomponents ~= nil ) then
					for j,comp_id in ipairs(projectilecomponents) do
						ComponentSetValue( comp_id, "on_death_explode", "0" )
						ComponentSetValue( comp_id, "on_lifetime_out_explode", "0" )
					end
				end
				
				local direction = 0 - math.atan2( ( py - y ), ( px - x ) )
				local speed = 6000
				local vel_x = math.cos( direction ) * speed
				local vel_y = 0 - math.sin( direction ) * speed
				shoot_projectile( projectile_id, "data/entities/projectiles/deck/projectile_thunder_lightning.xml", px, py, vel_x, vel_y, false )
				EntityKill( projectile_id )
			end
		end
	end
end