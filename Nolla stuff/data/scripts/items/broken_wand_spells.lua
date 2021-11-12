dofile_once("data/scripts/lib/utilities.lua")

local speed = 200
local recoil = 50
local max_torque = 30
local start_delay = 60

local entity_id = GetUpdatedEntityID()

-- wait for a while after throwing
local t = GameGetFrameNum()
local comp = get_variable_storage_component(entity_id, "throw_time")
local throw_time = ComponentGetValue2(comp, "value_int")
--print(ComponentGetValue2(comp, "value_int") .. " vs " .. t)
if throw_time + start_delay > t then return end

-- shoot a spell if there's shots remaining for this throw
comp = get_variable_storage_component(entity_id, "spells_remaining")
local remaining = ComponentGetValue2(comp, "value_int")
if remaining > 0 then
	local pos_x, pos_y, rot = EntityGetTransform(entity_id)

	-- direction
	local vel_x = 1
	local vel_y = 0
	vel_x, vel_y = vec_rotate(vel_x, vel_y, rot)

	-- recoil
	PhysicsApplyForce( entity_id, -vel_x * recoil, -vel_y * recoil)
	PhysicsApplyTorque( entity_id, ProceduralRandomf(pos_x, t, -max_torque, max_torque) )
	
	-- offset shooting position to avoid self-collision
	pos_x = pos_x + vel_x * 7
	pos_y = pos_y + vel_y * 7

	vel_x = vel_x * speed
	vel_y = vel_y * speed

	-- pick a random spell per-throw
	local spells = {
		"data/entities/projectiles/deck/light_bullet.xml",
		"data/entities/projectiles/deck/light_bullet.xml",
		"data/entities/projectiles/deck/arrow.xml",
		"data/entities/projectiles/deck/bullet.xml",
		"data/entities/projectiles/deck/bubbleshot.xml",
		"data/entities/projectiles/deck/disc_bullet.xml"
	}
	SetRandomSeed(throw_time, 12)
	local spell = spells[Random(1, #spells)]
	shoot_projectile( entity_id, spell, pos_x, pos_y, vel_x, vel_y)

	remaining = remaining - 1
	ComponentSetValue2( comp, "value_int", remaining)
end
