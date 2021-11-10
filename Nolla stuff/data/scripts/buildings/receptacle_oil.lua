dofile_once("data/scripts/lib/utilities.lua")

function material_area_checker_success( pos_x, pos_y )
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform(entity_id)
	x = x + 72
	y = y - 22

	EntityLoad("data/entities/items/wand_ruusu.xml", x, y)
	EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", x, y)
	GamePlaySound( "data/audio/Desktop/projectiles.snd", "player_projectiles/crumbling_earth/create", x, y)
	EntityKill(entity_id)
end
