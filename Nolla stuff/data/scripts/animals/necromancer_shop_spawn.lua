dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform(entity_id)

if tonumber(GlobalsGetValue("STEVARI_DEATHS", 0)) < 3 then
	EntityLoad("data/entities/animals/necromancer_shop.xml", pos_x, pos_y)
else
	EntityLoad("data/entities/animals/necromancer_super.xml", pos_x, pos_y)
end

EntityKill(entity_id)
