dofile( "data/scripts/game_helpers.lua" )

-- spawn boss dragon

local entity_id = GetUpdatedEntityID()

-- disables the dragon with globals
local is_spawned = GlobalsGetValue("boss_dragon_spawned")
if( is_spawned == "1") then
	EntityKill( entity_id )
	return 0
end

local pos_x, pos_y = EntityGetTransform( entity_id )
local ppos_x = 0
local ppos_y = 0

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local players = EntityGetWithTag( "player_unit" )
if( #players == 0 ) then
	return
end
ppos_x, ppos_y = EntityGetTransform( players[1])

local delta_x = ppos_x - pos_x
local delta_y = ppos_y - pos_y
-- if the player is above, make it lot longer...
if( delta_y < 0 ) then delta_y = delta_y * 10 end

delta_x = delta_x * delta_x
delta_y = delta_y * delta_y


if( delta_x + delta_y > 450*450) then
	-- print( math.sqrt( delta_x + delta_y ) )
	return
end

if( Random( 0, 100 ) < 50 ) then
	ppos_x = ppos_x - 512
else
	ppos_x = ppos_x + 512
end

ppos_y = ppos_y + Random( 128, 512 )

GlobalsSetValue("boss_dragon_spawned", "1")

EntityLoad( "data/entities/animals/boss_dragon.xml", ppos_x, ppos_y )

local end_eggs = EntityGetWithTag( "end_egg" )
if( #end_eggs > 0 ) then
	for i,v in ipairs(end_eggs) do
		EntityKill(v)
	end
end

EntityKill( entity_id )