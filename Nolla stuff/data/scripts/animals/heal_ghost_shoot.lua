dofile_once("data/scripts/lib/utilities.lua")

local range = 160
local projectile_velocity = 400
local scatter = 0.1

local entity_id = GetUpdatedEntityID()
local root_id = EntityGetRootEntity(entity_id)
local pos_x, pos_y = EntityGetTransform( entity_id )

-- locate nearest enemy
local enemy, enemy_x, enemy_y
local min_dist = 9999
for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, range, "mortal")) do
	-- is target a valid enemy
	if EntityGetComponent(id, "GenomeDataComponent") ~= nil and EntityGetHerdRelation(root_id, id) > 90 then
		local x, y = EntityGetFirstHitboxCenter( id )
		local dist = get_distance(pos_x, pos_y, x, y)
		if dist < min_dist then
			local needs_healing = false
			edit_component( id, "DamageModelComponent", function(comp,vars)
				local hp = ComponentGetValue2( comp, "hp" )
				local hp_m = ComponentGetValue2( comp, "max_hp" )
				
				if ( hp < hp_m ) then
					needs_healing = true
				end
			end)
			
			if needs_healing then
				min_dist = dist
				enemy = id
				enemy_x = x
				enemy_y = y
				break
			end
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
SetRandomSeed(pos_x + GameGetFrameNum(), pos_y)
vel_x,vel_y = vec_rotate(vel_x,vel_y, rand(-scatter, scatter))

-- apply velocity & shoot
vel_x,vel_y = vec_mult(vel_x,vel_y, projectile_velocity)
shoot_projectile( root_id, "data/entities/projectiles/deck/heal_bullet_weak.xml", pos_x, pos_y, vel_x, vel_y)

-- delay randomly so that multiple ghosts shoot at different times
local comp_id = GetUpdatedComponentID()
if (comp_id ~= 0) then
	ComponentSetValue(comp_id, "execute_every_n_frame", 70 + Random(2))
end

