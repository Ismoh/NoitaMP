dofile( "data/scripts/lib/utilities.lua" )

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

--if( entity_who == entity_id ) then return end

local vel_x = ProceduralRandom(pos_x, pos_y, -15, 15)
GameEntityPlaySound( entity_id, "duplicate" )
shoot_projectile_from_projectile( entity_id, "data/entities/animals/boss_centipede/firepillar_part.xml", pos_x, pos_y, vel_x, -75 )
--shoot_projectile_from_projectile( entity_id, "data/entities/animals/boss_centipede/firepillar_part.xml", pos_x, pos_y, 0, -200 )
shoot_projectile_from_projectile( entity_id, "data/entities/animals/boss_centipede/firepillar_part.xml", pos_x, pos_y, -vel_x*2, -150 )