dofile( "data/scripts/game_helpers.lua" )
dofile_once("data/scripts/lib/utilities.lua")

function spawn_group( names, x, y )
	-- spawn
	for _,v in ipairs(names) do
		EntityLoad("data/entities/animals/" .. v .. ".xml", x, y)
		x = x + 5
	end

	-- double spawn
	if ProceduralRandomf(x,y) < 0.25 then
		for _,v in ipairs(names) do
			EntityLoad("data/entities/animals/" .. v .. ".xml", x, y)
			x = x + 5
		end
	end
end

function get_random_group(seed)
	local r = ProceduralRandomf(seed,-463)
	
	if r < 0.2 then 		return {"scavenger_leader", "scavenger_smg", "scavenger_grenade", "scavenger_mine"}
	elseif r < 0.3 then		return {"the_end/gazer"}
	elseif r < 0.4 then		return {"tentacler", "tentacler_small", "tentacler_small"}
	elseif r < 0.5 then		return {"the_end/bloodcrystal_physics"}
	elseif r < 0.6 then		return {"crypt/crystal_physics", "crypt/crystal_physics"}
	elseif r < 0.7 then		return {"crypt/phantom_a", "crypt/phantom_a", "crypt/phantom_b"}
	elseif r < 0.8 then		return {"vault/lasershooter", "vault/acidshooter" }
	elseif r < 0.9 then 	return {"drone_lasership", "drone_lasership", "drone_lasership" }
	else 					return {"wizard_poly", "wizard_tele", "wizard_swapper", "wizard_dark"}
	end

end


function item_pickup( entity_item, entity_who_picked, item_name )
	local x_near_shore = 3300
	local y_near_shore = 825
	local x_far_shore = 2300
	local y_far_shore = 830
	local x_cave = 3450
	local y_cave = 930

	--[[
	local r = ProceduralRandomf(21,63)
	if r < 0.05 then
		EntityLoad("data/entities/misc/loose_chunks_huge.xml", 3500, 900)
	elseif r < 0.7 then
		spawn_group( get_random_group(1), x_near_shore, y_near_shore )
		spawn_group( get_random_group(2), x_far_shore, y_far_shore )
	elseif r < 0.9 then
		spawn_group( get_random_group(0), x_cave, y_cave )
		spawn_group( get_random_group(1), x_near_shore, y_near_shore )
		spawn_group( get_random_group(2), x_far_shore, y_far_shore )
	elseif r < 0.999 then
		spawn_group( get_random_group(1), x_near_shore, y_near_shore )
		spawn_group( get_random_group(2), x_far_shore, y_far_shore )
		spawn_group( get_random_group(3), x_far_shore, y_far_shore )
		spawn_group( get_random_group(4), x_far_shore, y_far_shore )
	else
		spawn_group( {"sheep", "sheep", "sheep", "sheep"}, x_far_shore, y_far_shore )
	end
	]]--
end
