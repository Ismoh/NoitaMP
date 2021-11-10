dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local state = 0
local comps = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( comps ~= nil ) then
	for i,v in ipairs( comps ) do
		local n = ComponentGetValue2( v, "name" )
		if ( n == "stage" ) then
			state = ComponentGetValue2( v, "value_int" )
			
			state = state + 1
			
			ComponentSetValue2( v, "value_int", state )
			break
		end
	end
end

local stage_names = { "$item_mcguffin_0", "$item_mcguffin_1", "$item_mcguffin_2", "$item_mcguffin_3", "$item_mcguffin_4", "$item_mcguffin_5", "$item_mcguffin_6", "$item_mcguffin_7", "$item_mcguffin_8", "$item_mcguffin_9", "$item_mcguffin_10", "$item_mcguffin_11", "$item_mcguffin_12", "$item_mcguffin_13" }

if ( stage_names[state] ~= nil ) then
	GamePrintImportant( stage_names[state] or "", "" )
end

local p = EntityGetWithTag( "player_unit" )

if ( #p == 0 ) then
	EntityGetWithTag( "sheep" )
end

if ( #p > 0 ) then
	local v = p[1]
	local px,py = EntityGetTransform( v )
	EntitySetTransform( entity_id, px, py )
end

if ( state == 1 ) then
	EntityLoad( "data/entities/projectiles/remove_ground.xml", x, y )
elseif ( state == 2 ) then
	EntityLoad( "data/entities/projectiles/circle_lava_small.xml", x, y - 96 )
elseif ( state == 5 ) then
	EntityLoad( "data/entities/projectiles/circle_acid_small.xml", x, y - 96 )
elseif ( state == 6 ) then
	if ( #p > 0 ) then
		for i,v in ipairs( p ) do
			local vx,vy = EntityGetTransform( v )
			local eid = EntityLoad( "data/entities/projectiles/deck/meteor_rain.xml", vx, vy )
			EntityAddChild( v, eid )
		end
	end
elseif ( state == 10 ) then
	local enemies = EntityGetWithTag( "enemy" )
	
	for i,v in ipairs( enemies ) do
		local shop = EntityHasTag( v, "necromancer_shop" ) or EntityHasTag( v, "boss" )
		local vx,vy = EntityGetTransform( v )
		
		if ( shop == false ) then
			EntityLoad( "data/entities/animals/necromancer_shop.xml", vx, vy )
			EntityKill( v )
		end
	end
elseif ( state == 12 ) then
	EntityLoad( "data/entities/projectiles/rain_gold.xml", x, y )
elseif ( state == 14 ) then
	EntityLoad( "data/entities/items/pickup/chest_random_super.xml", x, y )
end