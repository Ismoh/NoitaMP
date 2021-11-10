dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )
local dir = Random( 0, 100 ) * 0.01 * math.pi * 2

local comp2 = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
local shooter,px,py
if ( comp2 ~= nil ) then
	shooter = ComponentGetValue2( comp2, "mWhoShot" )
end

if ( shooter ~= nil ) and ( shooter ~= NULL_ENTITY ) then
	local wand_id = find_the_wand_held( shooter )

	if ( wand_id ~= nil ) and ( wand_id ~= NULL_ENTITY ) then
		px,py,dir = EntityGetTransform( wand_id )
	end
end

dir = 0 - dir

edit_component( entity_id, "VelocityComponent", function(comp,vars)
	local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
	
	local dist = math.sqrt( vel_y ^ 2 + vel_x ^ 2 )
	
	local dir2 = 0 - math.atan2( vel_y, vel_x )
	
	local delta = math.atan2( math.sin( dir - dir2 ), math.cos( dir - dir2 ) )
	local newdir = dir2 + delta * 0.2
	
	local addx = math.cos( newdir ) * dist
	local addy = 0 - math.sin( newdir ) * dist
	
	vel_x = addx
	vel_y = addy

	ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
end)