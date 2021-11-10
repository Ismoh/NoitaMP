dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/gun/gun_actions.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- abort if conversion already in progress
if #EntityGetInRadiusWithTag(pos_x, pos_y, 64, "seed_a_process") > 0 then return end

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 64, "seed_a")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		-- start conversion
		local x,y = EntityGetTransform( id )
		local eid = EntityLoad("data/entities/buildings/sun/spot_1_process.xml", x, y)
		EntityAddChild( id, eid )
		GamePlaySound( "data/audio/Desktop/projectiles.snd", "projectiles/magic/create", x, y )
		return
	end
end
