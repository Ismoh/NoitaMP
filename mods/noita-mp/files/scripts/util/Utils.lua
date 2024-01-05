---Utils class for lazy developers.
---@class Utils
local Utils = {

    --[[ Attributes ]]

}

---Wait for n seconds.
---@see Utils.sleep
---@param s number seconds to wait
function Utils:wait(s)
    self:sleep(s)
end

---Wait for n seconds.
---@param s number seconds to wait. required
function Utils:sleep(s)
    if self:isEmpty(s) then
        error("Unable to wait if parameter 'seconds' is empty: " .. tostring(s))
    end
    if type(s) ~= "number" then
        error("Unable to wait if parameter 'seconds' isn't a number: " .. type(s))
    end
    if not require then
        -- http://lua-users.org/wiki/SleepFunction
        local ntime = os.clock() + s
        repeat
        until os.clock() > ntime
    else
        if self.ffi.os == "Windows" then
            self.ffi.C.Sleep(s * 1000)
        else
            self.ffi.C.poll(nil, 0, s * 1000)
        end
    end
end

---Checks if a variable is empty.
---@param var number|string|table|nil variable to check
---@return boolean true if empty, false otherwise
function Utils:isEmpty(var)
    -- if you change this also change NetworkVscUtils.lua
    -- if you change this also change tableExtensions.lua
    if var == nil then
        return true
    end
    if var == "" then
        return true
    end
    if type(var) == "table" and not next(var) then
        return true
    end
    return false
end

---Formats anything pretty.
---@param var number|string|table|nil variable to print
---@return number|string|table formatted variable
function Utils:pformat(var)
    return self.pprint.pformat(var, self.pprint.defaults)
end

---Reloads the whole world with a specific seed. No need to restart the game and use magic numbers.
---@param seed number max = 4294967295
function Utils:reloadMap(seed)
    SetWorldSeed(seed)
    BiomeMapLoad_KeepPlayer("mods/noita-mp/files/scripts/DefaultBiomeMap.lua", "data/biome/_pixel_scenes.xml")
end

---Copies a string to the clipboard.
---@param copy string string to copy to the clipboard. required
function Utils:copyToClipboard(copy)
    if not copy then
        error("Unable to copy to clipboard if parameter 'copy' is empty: " .. tostring(copy))
    end
    if type(copy) ~= "string" then
        error("Unable to copy to clipboard if parameter 'copy' isn't a string: " .. type(copy))
    end
    local command = nil
    if _G.is_windows then
        command = ('echo "%s" | clip'):format(copy)
    else
        command = ('echo "%s" | xclip -sel clip'):format(copy)
    end
    os.execute(command)
end

---Opens a url in the default browser.
---@param url string url to open. required
function Utils:openUrl(url)
    if not url then
        error("Unable to open url if parameter 'url' is empty: " .. tostring(url))
    end
    if type(url) ~= "string" then
        error("Unable to open url if parameter 'url' isn't a string: " .. type(url))
    end
    local command = nil
    if _G.is_windows then
        command = ("rundll32 url.dll,FileProtocolHandler %s"):format(url) -- command = ('explorer "%s"'):format(url)
    else
        command = ('open "%s"'):format(url)
    end
    os.execute(command)
end

local once = false
function Utils:new()
    ---@class Utils
    local utilsObject = setmetatable(self, Utils)

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not utilsObject.pprint then
        ---@type pprint
        utilsObject.pprint = require("pprint")
    end

    if not utilsObject.ffi then
        utilsObject.ffi = require("ffi")
    end

    if not once then
        utilsObject.ffi.cdef [[
        void Sleep(int ms);
        int poll(struct pollfd *fds, unsigned long nfds, int timeout);
    ]]
        once = true
    end

    return utilsObject
end

return Utils
