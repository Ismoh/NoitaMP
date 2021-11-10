dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/procedural/gun_action_utils.lua")

local name = "$item_wand_ruusu"
local sprite_path = "data/items_gfx/wands/custom/plant_01.png"
local sprite_offset_x = 3
local sprite_offset_y = 5

local entity_id = GetUpdatedEntityID()

-- change visuals and UI texts
component_write( EntityGetFirstComponent(entity_id, "SpriteComponent"), {
	image_file = sprite_path,
	offset_x = sprite_offset_x,
	offset_y = sprite_offset_y,
})

component_write( EntityGetFirstComponent(entity_id, "ItemComponent"), {
	ui_sprite = sprite_path,
	item_name = name,
	always_use_item_name_in_ui = true
})
