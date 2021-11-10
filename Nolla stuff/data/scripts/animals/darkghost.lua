dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()

SetRandomSeed( entity_id, GameGetFrameNum() )
local rand = Random(1,10)

if (rand == 2) then
	edit_all_components( entity_id, "SpriteComponent", function(comp,vars)
		ComponentSetValue( comp, "rect_animation",      "blink" )
		ComponentSetValue( comp, "next_rect_animation", "stand" )
	end)
end