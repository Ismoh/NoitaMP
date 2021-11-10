dofile_once("data/scripts/lib/utilities.lua")

local lerp_speed = 0.60
local default_gravity = 350
local fly_gravity = default_gravity * -0.8

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )
local player_id = EntityGetRootEntity(entity_id)

component_readwrite( EntityGetFirstComponent( player_id, "CharacterPlatformingComponent" ), { pixel_gravity = 350, mFramesNotSwimming = 10 }, function(comp)
	local gravity = default_gravity
	
	-- boost lift while swimming
	if comp.mFramesNotSwimming == 0 then
		fly_gravity = fly_gravity * 15
	end

	-- read controls input
	component_read(EntityGetFirstComponent(player_id, "ControlsComponent"), { mButtonDownDown = false, mButtonDownUp = false }, function(controls_comp)
		if controls_comp.mButtonDownDown then
			-- float down, ignore walls
			comp.pixel_gravity = lerp(comp.pixel_gravity, default_gravity, lerp_speed)
			return
		elseif controls_comp.mButtonDownUp then
			-- flying
			gravity = fly_gravity
		else
			-- not flying: stabilize
			local _,vy = GameGetVelocityCompVelocity(player_id)
			gravity = -vy*200
		end
	end)
	
	if comp.mFramesNotSwimming ~= 0 then
		-- check if limbs are attached
		for _,limb_entity in ipairs(EntityGetInRadiusWithTag(x, y, 2, "attack_foot_walker")) do
			local limb = EntityGetFirstComponent(limb_entity, "IKLimbWalkerComponent")
			if limb ~= nil then
				if ComponentGetValue2(limb, "mState") > 0 then
					-- climb
					comp.pixel_gravity = lerp(comp.pixel_gravity, gravity, lerp_speed)
					return
				end
			end
		end
	else
		-- swim
		comp.pixel_gravity = lerp(comp.pixel_gravity, gravity, lerp_speed)
		return
	end

	-- not climbing
	comp.pixel_gravity = lerp(comp.pixel_gravity, default_gravity, lerp_speed)
end)
