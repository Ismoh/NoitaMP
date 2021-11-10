dofile_once("data/scripts/lib/utilities.lua")


function electricity_receiver_switched(on)
	-- spawn reward and kill entity
	local entity_id = GetUpdatedEntityID()
	local x,y = EntityGetTransform(entity_id)
	print("done")
	EntityLoad( "data/entities/items/pickup/chest_random.xml", x-75, y-70)
	EntityLoad("data/entities/particles/image_emitters/magical_symbol.xml", x-75, y-70)
	GamePlaySound( "data/audio/Desktop/projectiles.snd", "player_projectiles/crumbling_earth/create", x-75, y-70 )
	EntityKill(entity_id)
end


