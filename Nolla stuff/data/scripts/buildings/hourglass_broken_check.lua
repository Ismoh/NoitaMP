dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

-- check that hourglass is still there, roughly
y = y + 26
local left_x1 = x - 28
local left_x2 = x - 36
local right_x1 = x + 28
local right_x2 = x + 38
if RaytracePlatforms(left_x1, y, left_x2, y) == false or RaytracePlatforms(right_x1, y, right_x2, y) == false then
	EntityLoad("data/entities/projectiles/deck/crumbling_earth_effect.xml", x, y + 46)
	GamePlaySound( "data/audio/Desktop/projectiles.snd", "player_projectiles/crumbling_earth/create", x, y )
	--EntityLoad("data/entities/misc/workshop_collapse.xml", x, y + 30)
	-- clean up hourglass entities
	for _,v in pairs(EntityGetInRadiusWithTag(x, y, 150, "hourglass_entity")) do
		EntityKill(v)
	end
end
