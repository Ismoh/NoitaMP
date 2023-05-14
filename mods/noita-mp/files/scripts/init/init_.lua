-- Init lua scripts to set necessary defaults, like lua paths, logger init and extensions
print("Initialise paths, globals and extensions..")
local varargs = { ... }
if varargs and #varargs > 0 then
    if require then
        print("ERROR: Do not add any arguments when running this script in-game!")
    else
        print("'varargs' of init_.lua, see below:")
        print(unpack(varargs))
    end
else
    print("no 'varargs' set.")
end

dofile("mods/noita-mp/files/scripts/extensions/tableExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/stringExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/mathExtensions.lua")
if require then
    dofile("mods/noita-mp/files/scripts/extensions/ffiExtensions.lua")
end
dofile("mods/noita-mp/files/scripts/extensions/globalExtensions.lua")
if require then
    dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
end


if not _G.Logger then
    if not require then
        _G.Logger = dofile_once("mods/noita-mp/files/scripts/util/Logger.lua")
    else
        ---Globally accessible Logger in _G.Logger.
        ---@alias _G.Logger Logger
        _G.Logger = require("Logger")
    end
    Logger.info(Logger.channels.initialize, "Logger initialised!")
else
    Logger.info(Logger.channels.initialize, "_G.Logger was already initialised!")
end

if not _G.Utils then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        -- _G.Utils = dofile_once("mods/noita-mp/files/scripts/util/Utils.lua")
    else
        ---Globally accessible Utils in _G.Utils.
        ---@alias _G.Utils Utils
        _G.Utils = require("Utils")
    end
end
if not _G.FileUtils then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        -- _G.FileUtils = dofile_once("mods/noita-mp/files/scripts/util/FileUtils.lua")
    else
        ---Globally accessible FileUtils in _G.FileUtils.
        ---@alias _G.FileUtils FileUtils
        _G.FileUtils = require("FileUtils")
    end
end
if not _G.MinaUtils then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.MinaUtils = dofile_once("mods/noita-mp/files/scripts/util/MinaUtils.lua")
    else
        ---Globally accessible MinaUtils in _G.MinaUtils.
        ---@alias _G.MinaUtils MinaUtils
        _G.MinaUtils = require("MinaUtils")
    end
end

if not _G.EntityCache then
    if not require then
    else
        ---Globally accessible EntityCache in _G.EntityCache.
        ---@alias _G.EntityCache EntityCache
        _G.EntityCache = require("EntityCache")
        --require("luaExtensions")
    end
end

if not _G.NetworkCacheUtils then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.NetworkCacheUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkCacheUtils.lua")
    else
        ---Globally accessible NetworkCacheUtils in _G.NetworkCacheUtils.
        ---@alias _G.NetworkCacheUtils NetworkCacheUtils
        _G.NetworkCacheUtils = require("NetworkCacheUtils")
    end
end

if not _G.EntitySerialisationUtils then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.EntitySerialisationUtils = dofile_once("mods/noita-mp/files/scripts/util/EntitySerialisationUtils.lua")
    else
        ---Globally accessible EntitySerialisationUtils in _G.EntitySerialisationUtils.
        ---@alias _G.EntitySerialisationUtils EntitySerialisationUtils
        _G.EntitySerialisationUtils = require("EntitySerialisationUtils")
    end
end

if not _G.EntityCacheUtils then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.EntityCacheUtils = dofile_once("mods/noita-mp/files/scripts/util/EntityCacheUtils.lua")
    else
        ---Globally accessible EntityCacheUtils in _G.EntityCacheUtils.
        ---@alias _G.EntityCacheUtils EntityCacheUtils
        _G.EntityCacheUtils = require("EntityCacheUtils")
    end
end

if not _G.EntityUtils then
    if not require then
        _G.EntityUtils = dofile_once("mods/noita-mp/files/scripts/util/EntityUtils.lua")
    else
        ---Globally accessible EntityUtils in _G.EntityUtils.
        ---@alias _G.EntityUtils EntityUtils
        _G.EntityUtils = require("EntityUtils")
    end
end

if not _G.GlobalsUtils then
    if not require then
        _G.GlobalsUtils = dofile_once("mods/noita-mp/files/scripts/util/GlobalsUtils.lua")
    else
        ---Globally accessible GlobalsUtils in _G.GlobalsUtils.
        ---@alias _G.GlobalsUtils GlobalsUtils
        _G.GlobalsUtils = require("GlobalsUtils")
    end
end

if not _G.NetworkVscUtils then
    if not require then
        _G.NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")
    else
        ---Globally accessible NetworkVscUtils in _G.NetworkVscUtils.
        ---@alias _G.NetworkVscUtils NetworkVscUtils
        _G.NetworkVscUtils = require("NetworkVscUtils")
    end
end

if not _G.NetworkUtils then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.NetworkUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkUtils.lua")
    else
        ---Globally accessible NetworkUtils in _G.NetworkUtils.
        ---@alias _G.NetworkUtils NetworkUtils
        _G.NetworkUtils = require("NetworkUtils")
    end
end

if not _G.NoitaComponentUtils then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        _G.NoitaComponentUtils = dofile_once("mods/noita-mp/files/scripts/util/NoitaComponentUtils.lua")
    else
        ---Globally accessible NoitaComponentUtils in _G.NoitaComponentUtils.
        ---@alias _G.NoitaComponentUtils NoitaComponentUtils
        _G.NoitaComponentUtils = require("NoitaComponentUtils")
    end
end

if not _G.NuidUtils then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.NuidUtils = dofile_once("mods/noita-mp/files/scripts/util/NuidUtils.lua")
    else
        ---Globally accessible NuidUtils in _G.NuidUtils.
        ---@alias _G.NuidUtils NuidUtils
        _G.NuidUtils = require("NuidUtils")
    end
end

if not _G.GuidUtils then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.GuidUtils = dofile_once("mods/noita-mp/files/scripts/util/GuidUtils.lua")
    else
        ---Globally accessible GuidUtils in _G.GuidUtils.
        ---@alias _G.GuidUtils GuidUtils
        _G.GuidUtils = require("GuidUtils")
    end
end

if not _G.NoitaMpSettings then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.NoitaMpSettings = dofile_once("mods/noita-mp/files/scripts/util/NoitaMpSettings.lua")
    else
        ---Globally accessible NoitaMpSettings in _G.NoitaMpSettings.
        ---@alias _G.NoitaMpSettings NoitaMpSettings
        _G.NoitaMpSettings = require("NoitaMpSettings")
    end
end

if not _G.CustomProfiler then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.CustomProfiler = dofile_once("mods/noita-mp/files/scripts/util/CustomProfiler.lua")
    else
        ---Globally accessible CustomProfiler in _G.CustomProfiler.
        ---@alias _G.CustomProfiler CustomProfiler
        _G.CustomProfiler = require("CustomProfiler")
    end
end

if not _G.Server then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.Server = dofile_once("mods/noita-mp/files/scripts/server/Server.lua")
    else
        ---Globally accessible Server in _G.Server.
        ---@alias _G.Server Server
        _G.Server = require("Server")
    end
end

if not _G.Client then
    -- If require is not available, we are in Noita Components lua context and should use dofile_once instead.
    -- But make sure to load files only when needed, to avoid loading them into memory.
    if not require then
        --_G.Client = dofile_once("mods/noita-mp/files/scripts/client/Client.lua")
    else
        ---Globally accessible Client in _G.Client.
        ---@alias _G.Client Client
        _G.Client = require("Client")
    end
end

if require then
    _G.whoAmI = function()
        if Server:amIServer() then
            return Server.iAm
        end
        if Client:amIClient() then
            return Client.iAm
        end
        return "UNKNOWN"
    end
end


---Checks if mandatory mods are installed and enabled.
local checkMandatoryDependencyMods = function()
    if require then
        local activeMods = ModGetActiveModIDs()
        print(Utils.pformat(activeMods))

        if not ModIsEnabled("NoitaDearImGui") then
            error("Please install NoitaDearImGui mod: https://github.com/dextercd/Noita-Dear-ImGui/releases/tag/release-1.9.0", 2)
        end
        -- if not FileUtils.Exists(("%s\\..\\NoitaPatcher"):format(FileUtils.GetAbsoluteDirectoryPathOfNoitaMP())) then
        --     error("Please install NoitaPatcher mod: https://github.com/dextercd/NoitaPatcher/releases/tag/release-1.10.1", 2)
        -- end
        -- if not FileUtils.Exists(("%s\\..\\nsew"):format(FileUtils.GetAbsoluteDirectoryPathOfNoitaMP())) then
        --     error("Please install NSEW mod: https://github.com/dextercd/Noita-Synchronise-Expansive-Worlds/releases/tag/release-0.0.5", 2)
        -- end
        if not ModIsEnabled("EnableLogger") then
            error("Please install EnableLogger mod: https://steamcommunity.com/sharedfiles/filedetails/?id=2124936579&searchtext=logger", 2)
        end
        -- if not ModIsEnabled("minidump") then
        --     error("Please install minidump mod: https://github.com/dextercd/Noita-Minidump/releases/tag/release-1.1.2", 2)
        -- end
    end
end

checkMandatoryDependencyMods()










-- function toBinString(s)
--     bytes = { string.byte(s, i, string.len(s)) }
--     binary = ""

--     for i, number in ipairs(bytes) do
--         c = 0

--         while (number > 0) do
--             binary = (number % 2) .. binary
--             number = number - (number % 2)
--             number = number / 2
--             c = c + 1
--         end

--         while (c < 8) do
--             binary = "0" .. binary
--             c = c + 1
--         end
--     end

--     return binary
-- end

-- function toBin(s)
--     binary = toBinString(s)
--     ret = {}
--     c = 1

--     for i = 1, string.len(binary) do
--         char = string.sub(binary, i, i)

--         if (tonumber(char) == 0) then
--             ret[c] = 0
--             c = c + 1
--         elseif (tonumber(char) == 1) then
--             ret[c] = 1
--             c = c + 1
--         elseif (tonumber(char)) then
--             print("Error: expected \'0\' or \'1\' but got \'", char, "\'.")
--         end
--     end

--     return ret
-- end

-- function toBinAndBack(s)
--     local bin = toBin(s)
--     local r = {}
--     for i = 1, #bin, 8 do
--         local n = 0
--         for j = 0, 7 do
--             n = n + (2 ^ (7 - j)) * bin[i + j]
--         end
--         r[#r + 1] = n
--     end
--     for i = 1, #r do
--         r[i] = string.char(r[i])
--     end
--     return table.concat(r):reverse()
-- end

-- -- local function hexdecode(hex)
-- --     return (hex:gsub("%x%x", function(digits)
-- --         return string.char(tonumber(digits, 16))
-- --     end))
-- -- end

-- -- local function hexencode(str)
-- --     return (str:gsub(".", function(char)
-- --         return string.format("%2x", char:byte())
-- --     end))
-- -- end

-- -- print(hexdecode(hexencode("Hello, World!")))

-- -- -- local bytemarkers = { { 0x7FF, 192 }, { 0xFFFF, 224 }, { 0x1FFFFF, 240 } }
-- -- -- function utf8(decimal)
-- -- --     if type(decimal) ~= "number" then
-- -- --         decimal = hexencode(decimal)
-- -- --     end
-- -- --     if decimal < 128 then return string.char(decimal) end
-- -- --     local charbytes = {}
-- -- --     for bytes, vals in ipairs(bytemarkers) do
-- -- --         if decimal <= vals[1] then
-- -- --             for b = bytes + 1, 2, -1 do
-- -- --                 local mod = decimal % 64
-- -- --                 decimal = (decimal - mod) / 64
-- -- --                 charbytes[b] = string.char(128 + mod)
-- -- --             end
-- -- --             charbytes[1] = string.char(vals[2] + decimal)
-- -- --             break
-- -- --         end
-- -- --     end
-- -- --     return table.concat(charbytes)
-- -- -- end

-- -- -- function utf8frompoints(...)
-- -- --     local chars, arg = {}, { ... }
-- -- --     for i, n in ipairs(arg) do chars[i] = utf8(arg[i]) end
-- -- --     return table.concat(chars)
-- -- -- end

-- -- -- FileUtils.WriteFile(("%s%s%s"):format(FileUtils.GetDesktopDirectory(), pathSeparator, "utf8.txt"),
-- --     -- utf8frompoints(72, 233, 108, 108, 246, 32, 8364, 8212))
-- -- --> Héllö €—

-- -- REMOVE this
-- if require then
--     local base64 = require("base64")
--     local b64str =
--     "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cyxyYWRpb2FjdGl2ZV9nYXNfc3RhdGljLHJvY2tfc3RhdGljX3JhZGlvYWN0aXZlLHJvY2tfc3RhdGljX3BvaXNvbixpY2VfcmFkaW9hY3RpdmVfc3RhdGljLGljZV9yYWRpb2FjdGl2ZV9nbGFzcyxpY2VfYWNpZF9zdGF0aWMsaWNlX2FjaWRfZ2xhc3Mscm9ja19zdGF0aWNfY3Vyc2VkLHBvb19nYXMAAABdMC4wMDQsMC4wMDQsMC4wMDEsMC4wMDA4LDAuMDAwNywwLjAwMSwwLjAwMSwwLjAwMSwwLjAwMSwwLjAwMSwwLjAwMSwwLjAwMSwwLjAwMSwwLjAwNSwwLjAwMDAxAAEBAAAABG1lYXQAAAAjZGF0YS9yYWdkb2xscy9sb25nbGVnL2ZpbGVuYW1lcy50eHQAAAAEbWVhdAAAAADAwAAAAAAAAAAAAAxibG9vZF9mYWRpbmcAAAAFYmxvb2QBP4AAAP////8AAABJZGF0YS9wYXJ0aWNsZXMvYmxvb2RzcGxhdHRlcnMvYmxvb2RzcGxhdHRlcl9kaXJlY3Rpb25hbF9wdXJwbGVfJFsxLTNdLnhtbAAAAD1kYXRhL3BhcnRpY2xlcy9ibG9vZHNwbGF0dGVycy9ibG9vZHNwbGF0dGVyX3B1cnBsZV8kWzEtM10ueG1sAAAAAAEAAAAAAAAAAAEBAAAAAAAAAAAAAD8AAAAAAAAEOZ1JUj5MzM2AAAAAgAAAAP//2PAAAAASR2FtZVN0YXRzQ29tcG9uZW50AQEAAAAAAAAAB2xvbmdsZWcAAAAXPz9TVEEvc3RhdHNfbG9uZ2xlZy54bWwAAAAAAAAAAAAAAAATR2Vub21lRGF0YUNvbXBvbmVudAEBAAAAAAAAAA8AAAAA/////wFBIAAAAAAAAA9IaXRib3hDb21wb25lbnQBAQAAAAAAAQDAoAAAQKAAAMDAAABAwAAAAAAAAAAAAAA/gAAAAAAAEEhvdHNwb3RDb21wb25lbnQBAQAAAAlzaG9vdF9wb3MAAAAAwIAAAAEAAAAAAAAAEkl0ZW1DaGVzdENvbXBvbmVudAEAAAAAAAAAAAIAAAADAAAAAQEAAAAAAAAAAAAAAAAQo9h5AAAADEx1YUNvbXBvbmVudAEBAAAAAAAAAAAAAAAAAAD/////AAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAhZGF0YS9zY3JpcHRzL2l0ZW1zL2Ryb3BfbW9uZXkubHVhAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/////wAAAAAUUGF0aEZpbmRpbmdDb21wb25lbnQBAQAAAAAAAAB4AJiWfwACNmgAAjZoRImAAAAAABQAAAAUAAAARgAAABRBAAAAAAEAAAAAAAAAAEPIAABDSAAAP4AAAELIAABCcAAAAAAABkCgAABBcAAAP4AAAEDgAABBoAAAP4AAAEEgAADCcAAAP4AAAEIgAADCDAAAP4AAAEJwAADCIAAAP4AAAEJwAABClgAAP4AAAAAAAB5QYXRoRmluZGluZ0dyaWRNYXJrZXJDb21wb25lbnQBAQAAAAAAAAAQAAAAAMDAAAAAAAAAAAAAF1Nwcml0ZUFuaW1hdG9yQ29tcG9uZW50AQEAAAAAAAAACWNoYXJhY3RlcgAAAAAPU3ByaXRlQ29tcG9uZW50AQEAAAAJY2hhcmFjdGVyAAAAHGRhdGEvZW5lbWllc19nZngvbG9uZ2xlZy54bWwAAEDAAABBQAAAAAAAAAAAAAAAAAAAAAAAAD+AAAABAAAAAAAAAAR3YWxrAAAAAAAAAAC/gAAAAQEAAD+AAAA/gAAAAAAAABVTcHJpdGVTdGFpbnNDb21wb25lbnQBAQAAAAAAAAAAAQAAAAEAAAAA/////wAAABlTdGF0dXNFZmZlY3REYXRhQ29tcG9uZW50AQEAAAAAAAAAKQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEVZlbG9jaXR5Q29tcG9uZW50AQEAAAAAAAAAAEPIAAA9TMzNPwzMzUR6AAABAAEAAQAAAAA/gAAAAAAAAAAAAAAAAAAA"
--     local decoded = base64.decode(b64str)

--     local test = toBinAndBack(decoded)

--     print(Utils.pformat(decoded))
--     FileUtils.WriteBinaryFile(("%s%s%s"):format(FileUtils.GetDesktopDirectory(), pathSeparator, "poly.txt"), decoded)

--     local utf8 = require("lua-utf8")

--     print(utf8.escape("%123%u123%{123}%u{123}%xABC%x{ABC}"))
--     print(utf8.escape("%%123%?%d%%u"))

--     local f = assert(io.open(("%s%s%s"):format(FileUtils.GetDesktopDirectory(), pathSeparator, "poly.txt"), "rb"))
--     local output = io.open(("%s%s%s"):format(FileUtils.GetDesktopDirectory(), pathSeparator, "poly2.txt"), "w")
--     local block = 10
--     while true do
--         local bytes = decoded--f:read(block)
--         if not bytes then break end
--         for b in string.gfind(bytes, ".") do
--             if b == "D" then
--                 print("issue")
--             end
--             local byteAsNumber = utf8.byte(b)
--             local byteAsHex = string.format("%02X ", utf8.byte(b))
--             local str = utf8.escape("%" .. string.format("%s", byteAsNumber))
--             print(str)
--             output:write(str)
--         end
--         output:write(string.rep("   ", block - string.len(bytes) + 1))
--         output:write(string.gsub(bytes, "%c", "."), "\n")
--     end
-- end
