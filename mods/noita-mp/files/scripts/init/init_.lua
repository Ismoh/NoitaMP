-- Init lua scripts to set necessary defaults, like lua paths, logger init and extensions
print("Initializing NoitaMP...")

print("Loading extensions...")
dofile("mods/noita-mp/files/scripts/extensions/tableExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/stringExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/mathExtensions.lua")
if require then
    dofile("mods/noita-mp/files/scripts/extensions/ffiExtensions.lua")
end
dofile("mods/noita-mp/files/scripts/extensions/globalExtensions.lua")
if require then
    print("Initializing package loading...")
    dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
end

---Checks if mandatory mods are installed and enabled.
---@param fileUtils FileUtils required
---@param utils Utils required
local checkMandatoryDependencyMods = function(fileUtils, utils)
    local activeMods = ModGetActiveModIDs()
    print("activeMods: " .. utils:pformat(activeMods))

    if not ModIsEnabled("NoitaDearImGui") then
        error("Please install NoitaDearImGui mod: https://github.com/dextercd/Noita-Dear-ImGui/releases/tag/release-1.9.0", 2)
    end
    if not fileUtils:Exists(("%s\\lua_modules\\lib\\lua\\5.1\\noitapatcher.dll"):format(fileUtils:GetAbsoluteDirectoryPathOfNoitaMP())) then
        error("Please install NoitaPatcher mod: https://github.com/dextercd/NoitaPatcher/releases/latest", 2)
    end
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


if require then
    local gui             = {} -- mocked gui
    ---@type Utils
    local utils           = require("Utils"):new()
    ---@type NoitaMpSettings
    local noitaMpSettings = require("NoitaMpSettings")
        :new(nil, nil, gui, nil, nil, nil, nil)
    ---@type FileUtils
    local fileUtils       = require("FileUtils")
        :new(nil, noitaMpSettings.customProfiler, nil, noitaMpSettings, nil, utils)

    if not _G.isTestLuaContext then
        checkMandatoryDependencyMods(fileUtils, utils)
    end

    noitaMpSettings.customProfiler:init()
end
