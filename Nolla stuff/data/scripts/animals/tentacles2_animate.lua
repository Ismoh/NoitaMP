local entity_id = GetUpdatedEntityID()
local comp_ids  = EntityGetComponent( entity_id, "PhysicsJointComponent" )

-- local pers = GetValueNumber( "a", 1.0 )
-- SetValueNumber( "a", pers + 1.0 )
-- print( tostring( pers ) )

local dir    = 1.0
local offset = 0.5
local i      = 0
if( comp_ids ~= nil ) then
	for index,joint in ipairs(comp_ids) do
		local time = GameGetFrameNum() / 60.0

		ComponentSetValue( joint, "mMotorEnabled",  "1" )
		ComponentSetValue( joint, "mMotorSpeed",     math.sin(offset + time * 5.0) * 20.0 * dir )
		ComponentSetValue( joint, "mMaxMotorTorque", 1000.0 )

		dir = dir * -1.0
		i = i + 1
		if i == 4 then
			--offset = offset + 0.5
			i = 0
		end
	end
end
