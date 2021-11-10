dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local x, y, angle = EntityGetTransform( entity_id )
local radius = 48
local default_teleport_radius = 30

angle = 0 - angle

local prev_entity_id = 0
local prev_prev_entity_id = 0

local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( variablestorages ~= nil ) then
	for j,storage_id in ipairs(variablestorages) do
		local var_name = ComponentGetValue( storage_id, "name" )
		if ( var_name == "prev_entity_id" ) then
			prev_entity_id = ComponentGetValueInt( storage_id, "value_int" )
		elseif ( var_name == "prev_prev_entity_id" ) then
			prev_prev_entity_id = ComponentGetValueInt( storage_id, "value_int" )
		end
	end
end

local targets = EntityGetInRadiusWithTag( x, y, radius, "homing_target" )
local target_found = false

if ( #targets > 0 ) then
	for i,target_id in ipairs( targets ) do
		if ( target_id ~= prev_entity_id ) and ( target_id ~= prev_prev_entity_id ) and ( target_found == false ) then
			prev_prev_entity_id = prev_entity_id
			prev_entity_id = target_id
			target_found = true
			
			local ex, ey = EntityGetFirstHitboxCenter( target_id )
			
			EntitySetTransform( entity_id, ex, ey )
			x = ex
			y = ey
			
			break
		end
	end
end

if ( target_found == false ) then
	prev_prev_entity_id = prev_entity_id
	prev_entity_id = 0
	
	x = x + math.cos( angle ) * default_teleport_radius
	y = y - math.sin( angle ) * default_teleport_radius
	
	EntitySetTransform( entity_id, x, y )
end

if ( variablestorages ~= nil ) then
	for j,storage_id in ipairs(variablestorages) do
		local var_name = ComponentGetValue( storage_id, "name" )
		if ( var_name == "prev_entity_id" ) then
			ComponentSetValue2( storage_id, "value_int", prev_entity_id )
		elseif ( var_name == "prev_prev_entity_id" ) then
			ComponentSetValue2( storage_id, "value_int", prev_prev_entity_id )
		end
	end
end

shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/chain_bolt_explosion.xml", x, y, 0, 0 )