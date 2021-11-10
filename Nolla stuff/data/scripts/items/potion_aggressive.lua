 dofile_once("data/scripts/lib/utilities.lua")

potions = 
{
	{
		material="lava",
		cost=300,
	},
	{
		material="water",
		cost=200,
	},
	{
		material="blood",
		cost=200,
	},
	{
		material="alcohol",
		cost=200,
	},
	{
		material="oil",
		cost=200,
	},
	{
		material="slime",
		cost=200,
	},
	{
		material="acid",
		cost=400,
	},
	{
		material="radioactive_liquid",
		cost=300,
	},
	{
		material="gunpowder_unstable",
		cost=400,
	},
	{
		material="liquid_fire",
		cost=400,
	},
	{
		material="magic_liquid_teleportation",
		cost=500,
	},
	{
		material="magic_liquid_berserk",
		cost=500,
	},
	{
		material="magic_liquid_charm",
		cost=800,
	},
	{
		material="blood_cold",
		cost=400,
	},
}


function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x + GameGetFrameNum(), y )
	-- so that all the potions will be the same in every position with the same seed
	local potion = random_from_array( potions )

	AddMaterialInventoryMaterial( entity_id, potion.material, 1000 )
end
