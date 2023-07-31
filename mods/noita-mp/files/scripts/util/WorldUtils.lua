------------------------------------------------------------------------------------------------------------------------
--- 'Imports'
------------------------------------------------------------------------------------------------------------------------
local nsew = require("nsew.world")
local nsew_ffi = require("nsew.world_ffi")
local ffi = require("ffi")
------------------------------------------------------------------------------------------------------------------------
--- WorldUtils
------------------------------------------------------------------------------------------------------------------------
WorldUtils = {}

---@param start_x number
---@param start_y number
---@param end_x number
---@param end_y number
---@return userdata area techincally a string but shouldn't be edited
function WorldUtils.EncodeWorldArea(start_x, start_y, end_x, end_y)
    if not WorldUtils.chunk_map then
        local grid = nsew_ffi.get_grid_world()
        WorldUtils.chunk_map = grid.vtable.get_chunk_map(grid)
    end
   
    local area = nsew.encode_area(WorldUtils.chunk_map, start_x, start_y, end_x, end_y)
    if area == nil then
        error(("WorldUtils.EncodeWorldArea failed to encode area (%s, %s) to (%s, %s)"):format(start_x, start_y, end_x, end_y))
    end

    local str = ffi.string(area, nsew.encoded_size(area))
    return str
end

---@param encodedArea userdata
function WorldUtils.LoadEncodedArea(encodedArea)
    error("Not implemented yet")
end