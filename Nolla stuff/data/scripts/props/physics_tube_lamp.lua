dofile_once("data/scripts/lib/utilities.lua")

function physics_body_modified( is_destroyed )
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	--local x, y = EntityGetFirstHitboxCenter(entity_id)

	-- blinkin'
	edit_all_components( entity_id, "LightComponent", function(comp,vars)
		vars.blinking_freq = 0.9
	end)

	-- sparkin'
	EntitySetComponentsWithTagEnabled( entity_id, "electricity_effect", true )

	-- break one of the joints
	local broken_joint_id = ProceduralRandomi(x,y,1,2)
	edit_all_components2( entity_id, "PhysicsJoint2MutatorComponent", function(comp,vars)
		if ComponentGetValue2( comp, "joint_id" ) == broken_joint_id then
			vars.destroy = true
		end			
	end)
end
