dofile_once("data/scripts/lib/utilities.lua")


local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform(entity_id)

local materials = {
	"water", "blood", "alcohol", "radioactive_liquid", "water_salt", "slime",
	"water", "blood", "alcohol", "radioactive_liquid", "water_salt", "slime",
	"magic_liquid_berserk", "magic_liquid_charm", "oil"
}
local mat = materials[ProceduralRandomi(x, y, 1, #materials)]

GameCreateParticle(mat, x+40, y-175, 10, 0, 0, false)

-- update material checker
if ComponentGetValue2(GetUpdatedComponentID(), "mTimesExecuted") == 0 then
	local mat_id = CellFactory_GetType(mat)
	component_write( EntityGetFirstComponent( entity_id, "MaterialAreaCheckerComponent"), { material = mat_id, material2 = mat_id } ) 
end


