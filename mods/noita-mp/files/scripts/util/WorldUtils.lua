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

local EncodedSize = ffi.sizeof(nsew.EncodedAreaHeader)
local PixelRunSize = ffi.sizeof(nsew.PixelRun)
local PixelRun_ptr = ffi.typeof("struct PixelRun const*")
---@param start_x number
---@param start_y number
---@param end_x number
---@param end_y number
---@return userdata area techincally a string but shouldn't be edited
function WorldUtils.EncodeWorldArea(start_x, start_y, end_x, end_y)
    local grid = nsew_ffi.get_grid_world()
    local chunk_map = grid.vtable.get_chunk_map(grid)
   
    local area = nsew.encode_area(chunk_map, start_x, start_y, end_x, end_y)
    if area == nil then
        error(("WorldUtils.EncodeWorldArea failed to encode area (%s, %s) to (%s, %s)"):format(start_x, start_y, end_x, end_y))
    end

    local str = ffi.string(area, nsew.encoded_size(area))
    return str
end

---@param encodedArea string
function WorldUtils.LoadEncodedArea(encodedArea)
    local grid_world = nsew_ffi.get_grid_world()

    local header = ffi.cast("struct EncodedAreaHeader const*", ffi.cast('char const*', encodedArea:sub(1, EncodedSize)))
    local body_size = PixelRunSize * header.pixel_run_count

    local body = string.sub(encodedArea, EncodedSize, body_size)
    local runs = ffi.cast(PixelRun_ptr, ffi.cast("const char*", body))

    nsew.decode(grid_world, header, runs)
end

---Syncs the 256x256 area around every player
function WorldUtils.SyncLocalRegions()
    local cpc = CustomProfiler.start("WorldUtils.SyncLocalRegions")
    CustomProfiler.stop("WorldUtils.SyncLocalRegions", cpc)
end