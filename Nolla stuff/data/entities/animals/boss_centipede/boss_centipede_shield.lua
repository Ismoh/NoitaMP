dofile_once("data/scripts/lib/utilities.lua")

local distance_full = 60
local gravity_coeff = 450
local conversion_velocity_mult = 0.8

local entity_id = EntityGetRootEntity(GetUpdatedEntityID())
local x, y = EntityGetTransform(entity_id)
local herd_id = get_herd_id(entity_id)

orbcount = ComponentGetValue2(get_variable_storage_component(entity_id, "orbcount"), "value_int")

-- projectile attractor
local projectiles = EntityGetInRadiusWithTag(x, y, distance_full, "projectile")
if ( #projectiles == 0 ) then return end
for _,id in ipairs(projectiles) do	
	local projectilecomp = EntityGetFirstComponent(id, "ProjectileComponent")
	local is_converted = EntityHasTag(id, "projectile_converted")
	if ComponentGetValue2(projectilecomp, "mWhoShot") ~= entity_id or is_converted then
		-- gravity
		local px, py = EntityGetTransform( id )
		
		local distance = math.sqrt( ( x - px ) ^ 2 + ( y - py ) ^ 2 )
		direction = 0 - math.atan2( ( y - py ), ( x - px ) )
		
		local gravity_percent = ( distance_full - distance ) / distance_full
		
		local offset_x = math.cos( direction ) * ( gravity_coeff * gravity_percent )
		local offset_y = 0 - math.sin( direction ) * ( gravity_coeff * gravity_percent )

		-- slow down when entering field
		if not is_converted then 
			offset_x = offset_x * conversion_velocity_mult
			offset_y = offset_y * conversion_velocity_mult
		end

		-- apply velocity
		local velocitycomp = EntityGetFirstComponent( id, "VelocityComponent" )
		if velocitycomp ~= nil then
			local vel_x,vel_y = ComponentGetValue2( velocitycomp, "mVelocity")
			vel_x = vel_x + offset_x
			vel_y = vel_y + offset_y

			ComponentSetValue2( velocitycomp, "mVelocity", vel_x, vel_y)
		else
			-- add physical force instead
			PhysicsApplyForce(id, offset_x * 0.000003, offset_y * 0.000003)
		end

		-- extend projectile lifetime
		-- NOTE: may have slightly funky results if projectile has other lifetimes or timers
		local lifetime = ComponentGetValue2(projectilecomp, "lifetime")
		ComponentSetValue2(projectilecomp, "lifetime", lifetime + 2) -- +2 feels better than 1

		-- init projectile attracted for the first time
		if not is_converted then
			if projectilecomp ~= nil then
				GameEntityPlaySound( entity_id, "suck_projectile" )

				-- prevent projectile from hurting boss
				component_write( projectilecomp,
				{
					mWhoShot = entity_id,
					mShooterHerdId = herd_id,
					friendly_fire = false,
					collide_with_shooter_frames = -1,
				} )
				-- FX
				EntityLoadToEntity("data/entities/animals/boss_centipede/boss_centipede_shield_trail_effect.xml", id)
			end
			-- convert damage fields with high enough orbcount
			if orbcount >= 6 then
				for _,comp in ipairs(EntityGetComponent(id, "AreaDamageComponent") or {}) do
					ComponentSetValue2(comp, "entities_with_tag", "player_unit")
				end
			end
			EntityAddTag(id, "projectile_converted")
		end
	end
end


