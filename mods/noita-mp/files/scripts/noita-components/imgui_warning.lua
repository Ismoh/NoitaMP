-- https://github.com/dextercd/Noita-Component-Explorer/blob/main/component-explorer/entities/imgui_warning.lua
run_count = run_count or 0

local msg = "NoitaMP: Couldn't find ImGui. Make sure it's installed and ABOVE NoitaMP in load order!"

print(msg)
GamePrint(msg)
GamePrintImportant("Missing ImGui.", msg)

run_count = run_count + 1

if run_count > 30 then
    EntityKill(GetUpdatedEntityID())
end
