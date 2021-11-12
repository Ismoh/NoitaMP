dofile_once("data/scripts/lib/utilities.lua")

function collision_trigger()
	local entity_id = GetUpdatedEntityID()
	wake_up(entity_id)
end

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id = GetUpdatedEntityID()
	wake_up(entity_id)
end

function wake_up(entity_id)
	edit_component( entity_id, "PhysicsAIComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_id, comp, true )
	end)
	
	edit_component( entity_id, "LightComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_id, comp, true )
	end)
	
	edit_component( entity_id, "AnimalAIComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_id, comp, true )
	end)
	
	edit_component( entity_id, "SpriteParticleEmitterComponent", function(comp,vars)
		EntitySetComponentIsEnabled( entity_id, comp, true )
	end)
end