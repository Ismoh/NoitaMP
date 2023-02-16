
local function prequire(...)
   local ok, mod = pcall(require, ...)
   if not ok then return nil, mod end
   return mod, ...
end

local function vrequire(...)
   local errors = {}
   for i, n in ipairs{...} do
      local mod, err = prequire(n)
      if mod then return mod, err end
      errors[#errors + 1] = err
   end
   error(table.concat(errors, "\n\n"))
end

local path = require "path"

local json, json_name = vrequire("json", "cjson.safe", "dkjson")

local function read_file(n)
  local f, e = io.open(n, "r")
  if not f then return nil, e end
  local d, e = f:read("*all")
  f:close()
  return d, e
end

local function json_init_array(t)
   if json.util and json.util.InitArray then
      return json.util.InitArray(t)
   end
   return t
end

local function json_encode(t)
   return json.encode(t)
end

local json_decode
if json_name == 'dkjson' then
  assert(nil ~= json.null)
  json_decode = function (t)
    local ok, r1, r2 = pcall(json.decode, t, nil, json.null)
    if ok then return r1, r2 end
    return nil, r1
  end
else
  json_decode = function (t)
    local ok, r1, r2 = pcall(json.decode, t)
    if ok then return r1, r2 end
    return nil, r1
  end
end

local function json_null()
  if json.null then return json.null end
  return json.decode('null')
end

local function json_load_file(n)
   local d, e = read_file(n)
   if not d then return nil, e end
   return json_decode(d)
end

-----------------------------------------------------------
local exec do

local lua_version_t
local function lua_version()
  if not lua_version_t then 
    local version = rawget(_G,"_VERSION")
    local maj,min = version:match("^Lua (%d+)%.(%d+)$")
    if maj then                         lua_version_t = {tonumber(maj),tonumber(min)}
    elseif not math.mod then            lua_version_t = {5,2}
    elseif table.pack and not pack then lua_version_t = {5,2}
    else                                lua_version_t = {5,2} end
  end
  return lua_version_t[1], lua_version_t[2]
end

local LUA_MAJOR, LUA_MINOR = lua_version()
local LUA_VERSION = LUA_MAJOR * 100 + LUA_MINOR
local LUA_52 = 502

exec = function(cwd, cmd, ...)
  local tmpfile = path.tmpname()
  if ... then cmd = cmd .. ' ' .. string.format(...) end
  cmd = cmd .. ' >"' .. tmpfile .. '" 2>&1'

  local p
  if cwd and (cwd ~= "") and (cwd ~= ".") then
    p = path.currentdir()
    path.chdir(cwd)
  end
  local res1,res2,res2 = os.execute(cmd)
  if p then path.chdir(p) end

  local data = read_file(tmpfile)
  path.remove(tmpfile)

  if res2 == nil then -- with Lua 5.1, os.execute returns only one value
    return res1==0, res1, data
  end

  return res1, res2, data
end

end
-----------------------------------------------------------

local function curl_json_upload_app(fname, url)
  local path_name, base_name = path.splitpath(fname)
  local tmp = path.tmpname()
  local ok, status, msg = exec(path_name, "curl", '--output %s --form "json_file=@%s;type=application/json" %s', tmp, base_name, url)
  local data = read_file(tmp)
  path.remove(tmp)

  if not (ok and data) then return nil, msg or status end

  return true, data
end

local function curl_json_upload_lib(fname, url)
  local curl, curl_utils = prequire "cURL", prequire "cURL.utils"
  if not (curl and curl_utils) then return curl_json_upload_app(fname, url) end

  local easy
  local ok, ret = pcall(function()
    local cainfo, capath = curl_utils.find_ca_bundle()
    easy = curl.easy{
      url      = url,
      cainfo   = cainfo,
      capath   = capath,
      httppost = curl.form():add_file("json_file", fname, "application/json", "json_file"),
    }

    if curl.version_info("features").SSL then
      easy:setopt_ssl_verifypeer(true)
      easy:setopt_ssl_verifyhost(2)
    end

    local res = {}
    easy
      :setopt_writefunction(table.insert, res)
      :perform()
    return table.concat(res)
  end)

  if easy then easy:close() end
  if not ok then return nil, tostring(ret) end
  return true, ret
end

local curl_json_upload = curl_json_upload_lib

local function upload_json_file(fname, url)
  local ok, data = curl_json_upload(fname, url)

  if not ok then return nil, data end

  local resp, err = json_decode(data)
  if not resp then return nil, "JSON decode error:\n" .. err .. "\n" .. data end

  if resp.error then return nil, resp.message, -1 end

  return resp, data
end

return {
  exec             = exec;
  read_file        = read_file;
  upload_json_file = upload_json_file;
  json = {
    encode     = json_encode,
    decode     = json_decode,
    init_array = json_init_array,
    load_file  = json_load_file,
    null       = json_null(),
  };
}
