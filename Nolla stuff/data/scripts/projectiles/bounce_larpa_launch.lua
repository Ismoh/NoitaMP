dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local vel_x,vel_y = 0,0

local test = EntityGetClosestWithTag( pos_x, pos_y, "projectile" )
local projectile_file = ""

if ( test ~= nil ) and ( test ~= NULL_ENTITY ) then
	local variablestorages = EntityGetComponent( test, "VariableStorageComponent" )

	if ( variablestorages ~= nil ) then
		for j,storage_id in ipairs(variablestorages) do
			local var_name = ComponentGetValue( storage_id, "name" )
			if ( var_name == "projectile_file" ) then
				projectile_file = ComponentGetValue2( storage_id, "value_string" )
			end
		end
	end
	
	edit_component( test, "VelocityComponent", function(comp,vars)
		vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity" )
	end)
end

if ( #projectile_file > 0 ) and ( math.abs( vel_x ) + math.abs( vel_y ) > 50 ) then
	local how_many = 4
	local angle = 0 - math.atan2( vel_y, vel_x )
	local angle_inc = (math.pi * 2) / how_many
	
	angle = angle + angle_inc * 0.5

	for i=1,how_many do
		local shot_vel_x = math.cos(angle) * 250
		local shot_vel_y = 0 - math.sin(angle) * 250
		
		angle = angle + angle_inc

		local eid = shoot_projectile_from_projectile( entity_id, projectile_file, pos_x + shot_vel_x * 0.05, pos_y + shot_vel_y * 0.05, shot_vel_x, shot_vel_y, false )
		EntityAddTag( eid, "projectile_cloned" )
	end
	
	EntityKill( entity_id )
end