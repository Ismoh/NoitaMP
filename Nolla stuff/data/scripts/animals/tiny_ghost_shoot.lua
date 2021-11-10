dofile_once("data/scripts/lib/utilities.lua")

local range = 200
local projectile_velocity_min = 570
local projectile_velocity_max = 630
local scatter = 0.15

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)
local pos_x, pos_y = EntityGetTransform( entity_id )

-- locate nearest enemy
local enemy, enemy_x, enemy_y
local min_dist = 9999
for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, range, "mortal")) do
	-- is target a valid enemy
	if (EntityGetComponent(id, "GenomeDataComponent") ~= nil) and (EntityGetHerdRelation(root_id, id) < 40) and (IsPlayer(root_id) ~= IsPlayer(id)) then
		local x, y = EntityGetFirstHitboxCenter( id )
		local dist = get_distance(pos_x, pos_y, x, y)
		if dist < min_dist then
			min_dist = dist
			enemy = id
			enemy_x = x
			enemy_y = y
		end
	end
end

if not enemy then return end

-- check los
if RaytraceSurfacesAndLiquiform(pos_x, pos_y, enemy_x, enemy_y) then return end

-- direction
local vel_x, vel_y = vec_sub(enemy_x, enemy_y, pos_x, pos_y)
vel_x,vel_y = vec_normalize(vel_x, vel_y)

-- scatter
--SetRandomSeed(pos_x + GameGetFrameNum(), pos_y)
--vel_x,vel_y = vec_rotate(vel_x,vel_y, rand(-scatter, scatter))

-- change projectile based on lost hp
local projectile = "light_bullet"
local count = 1
if IsPlayer(root_id) then
	component_read( EntityGetFirstComponent( root_id, "DamageModelComponent" ), { max_hp = 0, hp = 0 }, function(comp)
		local lost_hp = (comp.max_hp - comp.hp) * 25
		if lost_hp >= 6400 then
			projectile = "spitter_tier_3"
			count = 6
		elseif lost_hp >= 3200 then
			projectile = "bullet_heavy"
			count = 6
		elseif lost_hp >= 1600 then
			projectile = "bullet"
			count = 6
		elseif lost_hp >= 800 then
			projectile = "spitter_tier_3"
			count = 3
		elseif lost_hp >= 400 then
			projectile = "bullet_heavy"
			count = 3
		elseif lost_hp >= 200 then
			projectile = "bullet"
			count = 3
		elseif lost_hp >= 100 then
			projectile = "spitter_tier_3"
		elseif lost_hp >= 50 then
			projectile = "bullet_heavy"
		elseif lost_hp >= 25 then
			projectile = "bullet"
		end
		--print("lost_hp: " .. lost_hp .. ": " .. projectile .. " x " .. count)
	end)
end


SetRandomSeed(pos_x + GameGetFrameNum(), pos_y)
for i=1,count do
	-- scatter
	local vx,vy = vec_rotate(vel_x,vel_y, rand(-scatter, scatter))
	scatter = scatter + 0.05 -- subsequent shots more inaccurate

	-- apply velocity & shoot
	vx,vy = vec_mult(vx,vy, rand(projectile_velocity_min, projectile_velocity_max))
	local eid = shoot_projectile( root_id, "data/entities/projectiles/deck/".. projectile .. ".xml", pos_x, pos_y, vx, vy)
	
	--[[
	-- scale damage by visited biome count
	if ( eid ~= nil ) then
		local c = EntityGetFirstComponent( eid, "ProjectileComponent" )
		local vbc = tonumber( GlobalsGetValue( "visited_biomes_count" ) ) or 0
		
		if ( c ~= nil ) and ( vbc > 0 ) then
			local extra_damage = vbc
			local damage = ComponentGetValue2( c, "damage" ) + extra_damage * 0.1
			ComponentSetValue2( c, "damage", damage )
		end
	end
	--]]
end

-- delay randomly so that multiple ghosts shoot at different times
local comp_id = GetUpdatedComponentID()
if (comp_id ~= 0) then
	ComponentSetValue(comp_id, "execute_every_n_frame", 24 + Random(2))
end

