dofile_once("data/scripts/lib/utilities.lua")

function material_area_checker_success( pos_x, pos_y )
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform(entity_id)
	
	EntityLoad("data/entities/items/wand_kiekurakeppi.xml", x, y-25)
	EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", x, y-25)
	GamePlaySound( "data/audio/Desktop/projectiles.snd", "player_projectiles/crumbling_earth/create", x, y-25)
	EntityKill(entity_id)
end
