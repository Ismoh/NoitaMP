dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

local vel_x = 0
local vel_y = 500

GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/bullet_laser/create", pos_x, pos_y )

shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/wall_piece.xml", pos_x, pos_y, 0, 0 )
shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/wall_builder.xml", pos_x, pos_y, vel_x, vel_y )
shoot_projectile_from_projectile( entity_id, "data/entities/projectiles/deck/wall_builder.xml", pos_x, pos_y, vel_x, 0 - vel_y )