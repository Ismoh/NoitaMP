dofile_once("data/scripts/lib/utilities.lua")

function throw_glass_shard( potion_entity, entity_file, pos_x, pos_y )
	local vx,vy = vec_rotate( Random(1,2), 0, Random(0,math.pi*2.0) )
	edit_component( potion_entity, "VelocityComponent", function(comp,vars)
		local rvx,rvy = ComponentGetValue2( comp, "mVelocity") -- root velocity
		rvx,rvy = GameVecToPhysicsVec( rvx, rvy )
		rvx,rvy = vec_rotate( rvx, rvy, Random( -0.2, 0.2 ))
		rvx,rvy = vec_mult( rvx, rvy, 0.5)
		vx = vx+rvx
		vy = vy+rvy
	end)

	local entity = EntityLoad( entity_file, pos_x, pos_y )
	if entity ~= 0 then
		PhysicsApplyForce( entity, vx, vy )
	end
end

function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
	local entity_id = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	SetRandomSeed( pos_x, pos_y )
	throw_glass_shard( entity_id, "data/entities/props/physics_glass_shard_01.xml", pos_x-1, pos_y-1 )
	throw_glass_shard( entity_id, "data/entities/props/physics_glass_shard_02.xml", pos_x-1, pos_y+1 )
	throw_glass_shard( entity_id, "data/entities/props/physics_glass_shard_03.xml", pos_x+1, pos_y-1 )
	throw_glass_shard( entity_id, "data/entities/props/physics_glass_shard_04.xml", pos_x+1, pos_y+1 )
end