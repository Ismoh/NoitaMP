 dofile_once("data/scripts/lib/utilities.lua")

potions = 
{
	{
		material="magic_liquid_hp_regeneration_unstable",
		cost=300,
	},
	{
		material="blood_worm",
		cost=300,
	},
	{
		material="gold",
		cost=300,
	},
	--[[
	{
		material="creepy_liquid",
		cost=300,
	},
	]]--
	{
		material="snow",
		cost=300,
	},
	{
		material="glowshroom",
		cost=300,
	},
	{
		material="bush_seed",
		cost=300,
	},
	{
		material="cement",
		cost=300,
	},
	{
		material="salt",
		cost=300,
	},
	{
		material="sodium",
		cost=300,
	},
	{
		material="mushroom_seed",
		cost=300,
	},
	{
		material="plant_seed",
		cost=300,
	},
	{
		material="urine",
		cost=300,
	},
	{
		material="purifying_powder",
		cost=300,
	},
}


function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )
	-- so that all the potions will be the same in every position with the same seed
	local potion = random_from_array( potions )

	AddMaterialInventoryMaterial( entity_id, potion.material, 1000 )
end