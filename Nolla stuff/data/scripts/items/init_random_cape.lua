 dofile_once("data/scripts/lib/utilities.lua")


local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )
SetRandomSeed( x, y )

---
local capes =
{
	{
		kind = "protection_fire",
		name = "Fire protection cape",
		sprite = "protection_fire",
		
	},
	{
		kind = "protection_radioactivity",
		name = "Radioactivity protection cape",
		sprite = "protection_radioactivity",
	},
	{
		kind = "breath_underwater",
		name = "Underwater breathing cape",
		sprite = "breath_underwater",
	},
}

local cape = random_from_array( capes )

local sprite = "data/items_gfx/cape/default.xml"
if (cape.sprite ~= nil) then
	sprite = "data/items_gfx/cape/" .. cape.sprite .. ".xml"
end

edit_component( entity_id, "VariableStorageComponent",	function(comp,vars)  vars.value_string = cape.kind	end)
edit_component( entity_id, "ItemComponent",				function(comp,vars)  vars.item_name = cape.name 	end)

edit_component( entity_id, "SpriteComponent",			function(comp,vars)  vars.image_file = sprite 	end)