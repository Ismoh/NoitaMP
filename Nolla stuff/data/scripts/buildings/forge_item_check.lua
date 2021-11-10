dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/gun/gun_actions.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- abort if conversion already in progress
if #EntityGetInRadiusWithTag(pos_x, pos_y, 10, "forge_item_convert") > 0 then return end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 40, "forgeable")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		-- start conversion
		EntityLoad("data/entities/buildings/forge_item_convert.xml", pos_x, pos_y)
		GamePlaySound( "data/audio/Desktop/projectiles.snd", "projectiles/magic/create", pos_x, pos_y )
		return
	end
end
