dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local player_id    = EntityGetRootEntity( entity_id )
local x, y = EntityGetTransform( entity_id )

local lcomp = EntityGetFirstComponent( entity_id, "LuaComponent", "hungry_ghost_cooldown" )

if ( lcomp ~= nil ) then
	local timing = ComponentGetValue2( lcomp, "execute_every_n_frame" )
	
	-- print( "test: " .. tostring( timing ) )
	
	if ( timing == 1 ) then
		local projectiles = EntityGetInRadiusWithTag( x, y, 12, "projectile" )
		local projectile_id

		for i,v in ipairs( projectiles ) do
			local comp = EntityGetFirstComponent( v, "ProjectileComponent" )
			
			if ( comp ~= nil ) then
				local who = ComponentGetValue2( comp, "mWhoShot" )
				
				if ( who ~= player_id ) then
					projectile_id = v
					break
				end
			end
		end

		if ( projectile_id ~= nil ) then
			local projectilecomponents = EntityGetComponent( projectile_id, "ProjectileComponent" )
			local px, py = EntityGetTransform( projectile_id )
			
			if ( projectilecomponents ~= nil ) then
				for j,comp_id in ipairs(projectilecomponents) do
					ComponentSetValue2( comp_id, "on_death_explode", false )
					ComponentSetValue2( comp_id, "on_lifetime_out_explode", false )
				end
			end
			
			EntityLoad( "data/entities/particles/poof_yellow_tiny.xml", px, py )
			local effect_id = EntityLoad( "data/entities/misc/effect_damage_plus_small.xml", px, py )
			EntityAddChild( entity_id, effect_id )
			EntityKill( projectile_id )
			
			ComponentSetValue2( lcomp, "execute_every_n_frame", 160 )
		end
	else
		ComponentSetValue2( lcomp, "execute_every_n_frame", 1 )
	end
end