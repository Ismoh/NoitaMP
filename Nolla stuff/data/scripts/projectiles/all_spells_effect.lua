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
			break
		end
	end
end

local p = EntityGetWithTag( "player_unit" )

SetRandomSeed( x * state + GetUpdatedComponentID(), y * GameGetFrameNum() )
local angle = math.pi * 2 * (Random(1,100) * 0.01)
local length = Random( 48, 160 )
local ox = math.cos( angle ) * length
local oy = 0 - math.sin( angle ) * length

if ( state == 3 ) then
	EntityLoad( "data/entities/particles/tiny_ghost_poof.xml", x + ox, y + oy )
	EntityLoad( "data/entities/props/physics_propane_tank.xml", x + ox, y + oy )
elseif ( state == 4 ) then
	for i=0,15 do
		local angle_ = math.pi * 0.125 * i
		
		shoot_projectile( entity_id, "data/entities/projectiles/wraith_glowing_laser.xml", x + ox, y + oy, math.cos( angle_ ) * 400, 0 - math.sin( angle_ ) * 400 )
	end
elseif ( state == 7 ) then
	for i=0,3 do
		local angle_ = math.pi * 0.5 * i
		
		local pid = shoot_projectile( entity_id, "data/entities/projectiles/orb_poly.xml", x + ox, y + oy, math.cos( angle_ ) * 200, 0 - math.sin( angle_ ) * 200 )
		
		edit_component( pid, "ProjectileComponent", function(comp,vars)
			ComponentSetValue2( comp, "collide_with_world", false )
		end)
	end
elseif ( state == 8 ) then
	for i=0,15 do
		local angle_ = math.pi * 0.125 * i
		
		shoot_projectile( entity_id, "data/entities/projectiles/deck/rocket_tier_2.xml", x + ox, y + oy, math.cos( angle_ ) * 100, 0 - math.sin( angle_ ) * 100 )
	end
elseif ( state == 9 ) then
	EntityLoad( "data/entities/particles/tiny_ghost_poof.xml", x + ox, y + oy )
	shoot_projectile( entity_id, "data/entities/animals/boss_pit/wand.xml", x + ox, y - oy, ox, oy )
elseif ( state == 11 ) then
	local eid = EntityLoad( "data/entities/animals/worm_big.xml", x + ox, y + oy )
	EntitySetComponentsWithTagEnabled( eid, "death_reward", false )
elseif ( state == 12 ) then
	EntityLoad( "data/entities/items/pickup/potion.xml", x + ox, y + oy )
elseif ( state == 13 ) then
	for i=0,3 do
		local angle_ = math.pi * 0.5 * i
		
		shoot_projectile( entity_id, "data/entities/projectiles/deck/nuke.xml", x + ox, y + oy, math.cos( angle_ ) * 500, 0 - math.sin( angle_ ) * 500 )
	end
end