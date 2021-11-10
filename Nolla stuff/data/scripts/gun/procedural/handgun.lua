-- This is not a very good way of generating these, way too much randomness...
dofile('data/scripts/gun/procedural/gun_utilities.lua')


function generate_gun()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )
	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )
	-- It's better if don't randomize the start pistol
	-- SetItemSprite( entity_id, ability_comp, "data/items_gfx/gungen_guns/handgun_", Random( 0, 7 )  )
end

generate_gun()

