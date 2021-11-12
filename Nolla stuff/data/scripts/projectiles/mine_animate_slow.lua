dofile_once("data/scripts/lib/utilities.lua")

function set_main_animation( current_name )
	local entity_id = GetUpdatedEntityID()
	edit_all_components( entity_id, "SpriteComponent", function(comp,vars)
		vars.rect_animation = current_name
	end)
end

set_main_animation( "detonate" )
local entity_id = GetUpdatedEntityID()

edit_component( entity_id, "CollisionTriggerComponent", function(comp,vars)
	local timer = ComponentGetValueInt( comp, "timer_for_destruction")
	vars.mTimer = timer * 5
end)