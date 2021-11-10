dofile_once( "data/scripts/lib/utilities.lua" )

local exec_wait_min = 4
local exec_wait_max = 50
local min_vel = 60
local dampening = 0.85

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y, rad = EntityGetTransform( entity_id )

local velocity_comp = EntityGetFirstComponent( entity_id, "VelocityComponent")
if velocity_comp == nil then return end

local vel_x,vel_y = ComponentGetValueVector2( velocity_comp, "mVelocity")
local vel = get_magnitude(vel_x, vel_y)
local lua_comps = EntityGetComponent(entity_id, "LuaComponent", "pingpong_path")
if lua_comps == nil then return end

-- disable once velocity is too low
if vel < min_vel then
	for i=1,#lua_comps do
		EntitySetComponentIsEnabled( entity_id, lua_comps[i], false)
	end
	return
end

-- set execute pace based on velocity: faster projectiles bounce more frequently
local exec_wait = map(vel, min_vel, 600, exec_wait_max, exec_wait_min)
exec_wait = clamp(exec_wait, exec_wait_min, exec_wait_max)
exec_wait = math.floor(exec_wait)
for i=1,#lua_comps do
	ComponentSetValue( lua_comps[i], "execute_every_n_frame", exec_wait)
end
--print("vel: " .. vel .. ", delay: " .. exec_wait)

-- bounce
vel_x = -vel_x * dampening
local jump = vel * 0.1
vel_y = -vel_y * dampening - jump
ComponentSetValueVector2( velocity_comp, "mVelocity", vel_x, vel_y)
