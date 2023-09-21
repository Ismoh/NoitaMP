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
local checkMandatoryDependencyMods = function()
    local Utils           = require("Utils")

    local gui             = {} -- mocked gui
    ---@class NoitaMpSettings
    local noitaMpSettings = require("NoitaMpSettings")
        :new(nil, nil, gui, nil, nil, nil, nil)
    ---@class FileUtils
    local fileUtils       = require("FileUtils")
        :new(nil, noitaMpSettings.customProfiler, nil, noitaMpSettings, nil, nil)

    if require then
        local activeMods = ModGetActiveModIDs()
        print(Utils.pformat(activeMods))

        if not ModIsEnabled("NoitaDearImGui") then
            error("Please install NoitaDearImGui mod: https://github.com/dextercd/Noita-Dear-ImGui/releases/tag/release-1.9.0", 2)
        end
        if not fileUtils:Exists(("%s\\lua_modules\\lib\\lua\\5.1\\noitapatcher.dll"):format(fileUtils:GetAbsoluteDirectoryPathOfNoitaMP())) then
            error("Please install NoitaPatcher mod: https://github.com/dextercd/NoitaPatcher/releases/tag/release-1.10.1", 2)
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
end

checkMandatoryDependencyMods()
