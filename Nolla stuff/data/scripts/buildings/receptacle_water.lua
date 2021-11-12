dofile_once("data/scripts/lib/utilities.lua")

function material_area_checker_success( pos_x, pos_y )
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform(entity_id)
	
	EntityLoad("data/entities/items/wand_valtikka.xml", x, y-85)
	EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", x, y-85)
	GamePlaySound( "data/audio/Desktop/projectiles.snd", "player_projectiles/crumbling_earth/create", x, y-85)
	EntityKill(entity_id)
end
