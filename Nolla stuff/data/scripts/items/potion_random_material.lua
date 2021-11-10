 dofile_once("data/scripts/lib/utilities.lua")

function init( entity_id )
	local x,y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )
	-- so that all the potions will be the same in every position with the same seed
	-- local potion = random_from_array( potions )
	local materials = nil

	if( Random( 0, 100 ) <= 50 ) then
		materials = CellFactory_GetAllLiquids( false )
	else
		materials = CellFactory_GetAllSands( false )
	end

	local potion_material = random_from_array( materials )

	-- AddMaterialInventoryMaterial( entity_id, potion.material, 1000 )
	AddMaterialInventoryMaterial( entity_id, potion_material, 1000 )
end