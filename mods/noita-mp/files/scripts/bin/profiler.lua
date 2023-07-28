print("  _   _       _ _        __  __ _____    _____            __ _ _           ")
print(" | \\ | |     (_) |      |  \\/  |  __ \\  |  __ \\          / _(_) |          ")
print(" |  \\| | ___  _| |_ __ _| \\  / | |__) | | |__) | __ ___ | |_ _| | ___ _ __ ")
print(" | . ` |/ _ \\| | __/ _` | |\\/| |  ___/  |  ___/ '__/ _ \\|  _| | |/ _ \\ '__|")
print(" | |\\  | (_) | | || (_| | |  | | |      | |   | | | (_) | | | | |  __/ |   ")
print(" |_| \\_|\\___/|_|\\__\\__,_|_|  |_|_|      |_|   |_|  \\___/|_| |_|_|\\___|_|   ")

print(" _   _       _ _       ___  _________  ______           __ _ _             ")
print("| \\ | |     (_) |      |  \\/  || ___ \\ | ___ \\         / _(_) |            ")
print("|  \\| | ___  _| |_ __ _| .  . || |_/ / | |_/ / __ ___ | |_ _| | ___ _ __   ")
print("| . ` |/ _ \\| | __/ _` | |\\/| ||  __/  |  __/ '__/ _ \\|  _| | |/ _ \\ '__|  ")
print("| |\\  | (_) | | || (_| | |  | || |     | |  | | | (_) | | | | |  __/ |     ")
print("\\_| \\_/\\___/|_|\\__\\__,_\\_|  |_/\\_|     \\_|  |_|  \\___/|_| |_|_|\\___|_|     ")

print(" _____     _ _       _____ _____    _____         ___ _ _                  ")
print("|   | |___|_| |_ ___|     |  _  |  |  _  |___ ___|  _|_| |___ ___          ")
print("| | | | . | |  _| .'| | | |   __|  |   __|  _| . |  _| | | -_|  _|         ")
print("|_|___|___|_|_| |__,|_|_|_|__|     |__|  |_| |___|_| |_|_|___|_|           ")

print("    _   __      _ __        __  _______     ____             _____ __         ")
print("   / | / /___  (_) /_____ _/  |/  / __ \\   / __ \\_________  / __(_) /__  _____")
print("  /  |/ / __ \\/ / __/ __ `/ /|_/ / /_/ /  / /_/ / ___/ __ \\/ /_/ / / _ \\/ ___/")
print(" / /|  / /_/ / / /_/ /_/ / /  / / ____/  / ____/ /  / /_/ / __/ / /  __/ /    ")
print("/_/ |_/\\____/_/\\__/\\__,_/_/  /_/_/      /_/   /_/   \\____/_/ /_/_/\\___/_/     ")

print("  _  _     _ _        __  __ ___   ___          __ _ _         ")
print(" | \\| |___(_) |_ __ _|  \\/  | _ \\ | _ \\_ _ ___ / _(_) |___ _ _ ")
print(" | .` / _ \\ |  _/ _` | |\\/| |  _/ |  _/ '_/ _ \\  _| | / -_) '_|")
print(" |_|\\_\\___/_|\\__\\__,_|_|  |_|_|   |_| |_| \\___/_| |_|_\\___|_|  ")

print("┳┓  •   ┳┳┓┏┓  ┏┓    ┏•┓    ")
print("┃┃┏┓┓╋┏┓┃┃┃┃┃  ┃┃┏┓┏┓╋┓┃┏┓┏┓")
print("┛┗┗┛┗┗┗┻┛ ┗┣┛  ┣┛┛ ┗┛┛┗┗┗ ┛ ")

print("")
print(" Why Profiler?! Because NoitaMP 'nom nom' your memory. :KAPPA: Just skill issue! :( ")
print("")

local params = { ... }
print("params", table.concat(params, ", "))

local pid = params[1]
print("pid", pid)

local noitaRootPath = io.popen("cd .. && cd .. && cd"):read("*l")
print("noitaRootPath", noitaRootPath)

dofile(noitaRootPath .. "/mods/noita-mp/files/scripts/init/init_package_loading.lua")

local lfs = require("lfs")

local pathToMods = lfs.currentdir() .. "/../.."
print("pathToMods: " .. pathToMods)

local gDofile = dofile
dofile        = function(path)
    if path:sub(1, 4) == "mods" then
        local pathToMod = pathToMods .. "/" .. path
        print("dofile path: " .. pathToMod)
        return gDofile(pathToMod)
    else
        return gDofile(path)
    end
end

-- dofile("mods/noita-mp/files/scripts/init/init_.lua") DO NOT LOAD ALL DEPENDENCIES!
dofile("mods/noita-mp/files/scripts/extensions/tableExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/stringExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/mathExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/globalExtensions.lua")

if not _G.ModSettingGet then
    _G.ModSettingGet = function(id)
        if not id then
            return "UNKNOWN ModSettingGet id - FIX ME!"
        end
        if string.contains(id, "noita-mp.log_level_") then
            return { "trace", "debug, info, warn", "TRACE" }
        end
    end
end

if not _G.Logger then
    _G.Logger = require("Logger")
end

local winapi = require("winapi")

local run    = function()
    local P = winapi.process_from_id(pid)
    local exitCode = P:get_exit_code()
    print("exitCode", exitCode)
    while exitCode ~= 0 do

        local memoryNomNomTable = {}
        for i = 1, 10000000000000000000000, 1 do
            memoryNomNomTable[i] = " Why Profiler?! Because NoitaMP 'nom nom' your memory. :KAPPA: Just skill issue! :( "
            print("i")
            print("memory usage", math.ceil(collectgarbage("count")).." KB")
        end

        exitCode = P:get_exit_code()
    end
    print("Noita is not running!")
    os.exit(0)
end

run()
