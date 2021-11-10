function set_main_animation( current_name, next_name )
	local sprite = EntityGetFirstComponent( GetUpdatedEntityID(), "SpriteComponent" )
	if ( sprite ~= nil ) then
		local anim_name = ComponentGetValue( sprite, "rect_animation" ) 

		if anim_name == "opened" or anim_name == "open" then -- only play the animation if we're in the correct state. this is to avoid it being left "dangling"
			animate_sprite( sprite, current_name, next_name )
		end
	end
end

function animate_sprite( sprite, current_name, next_name )
	ComponentSetValue( sprite, "rect_animation",      current_name )
	ComponentSetValue( sprite, "next_rect_animation", next_name )
end


function damage_received( damage, desc, entity_who, is_fatal )
	set_main_animation( "hurt", "opened" )
end