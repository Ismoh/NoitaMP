dofile_once("data/scripts/lib/utilities.lua")
dofile( "data/scripts/gun/gun_actions.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

-- convert items
local converted = false

for _,id in pairs(EntityGetInRadiusWithTag(pos_x, pos_y, 70, "seed_a")) do
	-- make sure item is not carried in inventory or wand
	if EntityGetRootEntity(id) == id then
		local x,y = EntityGetTransform(id)
		EntityLoad("data/entities/items/pickup/sun/sunstone.xml", x, y)
		EntityLoad("data/entities/projectiles/deck/explosion_giga.xml", x, y)
		EntityKill(id)
		converted = true
	end
end

if converted then
	GameTriggerMusicFadeOutAndDequeueAll( 3.0 )
	GameTriggerMusicEvent( "music/oneshot/dark_01", true, pos_x, pos_y )
	
	GamePrintImportant( "$log_new_step", "$logdesc_new_step" )
end