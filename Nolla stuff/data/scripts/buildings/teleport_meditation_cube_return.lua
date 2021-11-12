dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )

if not is_in_camera_bounds(pos_x,pos_y,300) then return end

local time = GameGetFrameNum()
local scale = 50

-- pyramid
--[[
local verts = { -- x1,y1,z1,x2,y2,y3...
	1,-0.75,1,
	-1,-0.75,1,
	1,-0.75,-1,
	-1,-0.75,-1,
	0,1,0
}

-- cube
local verts = { -- x1,y1,z1,x2,y2,y3...
	1,1,1,
	-1,1,1,
	1,-1,1,
	-1,-1,1,
	1,1,-1,
	-1,1,-1,
	1,-1,-1,
	-1,-1,-1,
}
--]]

-- octahedron
local verts = { -- x1,y1,z1,x2,y2,y3...
	1,0,1,
	-1,0,1,
	1,0,-1,
	-1,0,-1,
	0,1,0,
	0,-1,0,
}


local corners = #verts/3-1

function rotate_y(theta)
	local sin_t = math.sin(theta);
	local cos_t = math.cos(theta);
	
	for vert=0,corners do
		local ix = vert*3+1 
		local iz = vert*3+3
		local x = verts[ix];
		local z = verts[iz];
		verts[ix] = x * cos_t - z * sin_t;
		verts[iz] = z * cos_t + x * sin_t;
	end
end

function rotate_x(theta)
	local sin_t = math.sin(theta);
	local cos_t = math.cos(theta);
	
	for vert=0,corners do
		local iy = vert*3+2
		local iz = vert*3+3
		local y = verts[iy];
		local z = verts[iz];
		verts[iy] = y * cos_t - z * sin_t;
		verts[iz] = z * cos_t + y * sin_t;
	end
end

rotate_y(time * 0.00613)
rotate_x(math.sin(time * 0.002) * 0.3)

-- set the fx entity positions
local children = EntityGetAllChildren(entity_id)
if children == nil or #children == 0 then return end

-- trails flipflop between v1 and v2
local pos = time%2

for i,fx_entity in pairs(children) do
	if EntityHasTag(fx_entity, "cube_fx") then
		local v1 = (i-1)%corners
		local v2 = ProceduralRandomi(time,i,0,corners)

		local x1 = verts[v1*3+1]
		local y1 = verts[v1*3+2]
		local x2 = verts[v2*3+1]
		local y2 = verts[v2*3+2]

		local x, y = vec_lerp(x1, y1, x2, y2, pos)
		x = x * scale + pos_x
		y = y * scale + pos_y
		EntitySetTransform(fx_entity, x, y)
	end
end

-- set teleporter return coords
-- this is called every x frames
if time % 71 == 0 then
	local teleport_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "TeleportComponent" )

	local teleport_back_x = 190
	local teleport_back_y = 1525

	-- get the defaults from teleport_comp(s)
	if( teleport_comp ~= nil ) then
		teleport_back_x, teleport_back_y = ComponentGetValue2( teleport_comp, "target" )
		-- print( "teleport std pos:" .. teleport_back_x .. ", " .. teleport_back_y )
	end

	teleport_back_x = tonumber( GlobalsGetValue( "TELEPORT_MEDITATION_CUBE_POS_X", teleport_back_x ) )
	teleport_back_y = tonumber( GlobalsGetValue( "TELEPORT_MEDITATION_CUBE_POS_Y", teleport_back_y ) )

	if( teleport_comp ~= nil ) then
		ComponentSetValue2( teleport_comp, "target", teleport_back_x, teleport_back_y )
		-- ComponentGetValue2( teleport_comp, "target.y", teleport_back_y )
	end
end

-- hide teleporter for debug
--EntitySetComponentsWithTagEnabled(GetUpdatedEntityID(), "enabled_by_liquid", true)
