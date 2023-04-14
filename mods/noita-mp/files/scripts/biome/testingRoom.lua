--- testingroom.lua
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction(0xffffeedd, "init")
RegisterSpawnFunction(0xffff0001, "spawn_enemy_a")
RegisterSpawnFunction(0xffff0002, "spawn_enemy_b")

function init(x, y)
    LoadPixelScene("mods/noita-mp/data/biome_impl/testing-room-pixel-scene.png", "", x, y, "", true)
end

function spawn_enemy_a(x, y)
    EntityLoad("data/entities/animals/zombie_weak.xml", x, y)
end

function spawn_enemy_b(x, y)
    EntityLoad("data/entities/animals/firemage_weak.xml", x, y)
end

function spawn_small_enemies() end