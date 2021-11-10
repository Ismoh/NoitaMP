dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )

local count = Random(0,3) * Random(0,1)
local prefixes = {{name = "physics_smallgem", count = 5}, {name = "physics_bone", count = 5}}

if count > 0 then
	for i=1,count do
		local type = prefixes[math.random(#prefixes)]
		
		local prefix = type.name
		local id = Random(1,type.count)
		local name = prefix .. "_0" .. tostring(id)
		entity_id = EntityLoad( "data/entities/items/" .. name .. ".xml", pos_x+Random(-6,6), pos_y+Random(-6,6))

		if entity_id ~= 0 then
			PhysicsApplyForce( entity_id, Random(-100,100), Random(-150,0) )
		end
	end
end

