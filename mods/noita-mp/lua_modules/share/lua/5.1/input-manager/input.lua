local minhook = dofile("mods/noita-mp/lua_modules/share/lua/5.1/input-manager/minhook.lua")("mods/noita-mp/lua_modules/lib/lua/5.1")
minhook.initialize()

local SDL = dofile("mods/noita-mp/lua_modules/share/lua/5.1/input-manager/sdl2_ffi.lua")
local ffi = require("ffi")

local game_controller = nil
SDL.SDL_StartTextInput()


local TryInitController = function()
    if game_controller == nil then
        local num_joysticks = SDL.SDL_NumJoysticks()
        local game_controller = nil
        for i = 0, num_joysticks - 1 do
            if SDL.SDL_IsGameController(i) ~= 0 then
                game_controller = SDL.SDL_GameControllerOpen(i)
                if game_controller ~= nil then
                    break
                end
            end
        end
    end
end

TryInitController()

local input = {
    pressed = {},
    inputs = {},
    released = {},
    held = {},
    chars = {},
    mouse = {
        x = 0,
        y = 0,
        held = {},
        pressed = {},
        released = {}
    },
    controller = {
        pressed = {},
        released = {},
        held = {},
        left_stick = {x = 0, y = 0},
        right_stick = {x = 0, y = 0},
        triggers = {left = 0, right = 0}
    },
    frame_finished = false
}

input.Reset = function(self)
    self.pressed = {}
    self.inputs = {}
    self.released = {}
    self.chars = {}
    self.mouse.pressed = {}
    self.mouse.released = {}
    self.controller.pressed = {}
    self.controller.released = {}
    self.controller.held = {}
    --[[self.controller.left_stick = {x = 0, y = 0}
    self.controller.right_stick = {x = 0, y = 0}
    self.controller.triggers = {left = 0, right = 0}]]
end

input.Clear = function (self)
    self.pressed = {}
    self.inputs = {}
    self.released = {}
    self.held = {}
    self.chars = {}
    self.mouse.pressed = {}
    self.mouse.released = {}
    self.mouse.held = {}
    self.mouse.x = 0
    self.mouse.y = 0
    self.controller.pressed = {}
    self.controller.released = {}
    self.controller.held = {}
    self.controller.left_stick = {x = 0, y = 0}
    self.controller.right_stick = {x = 0, y = 0}
    self.controller.triggers = {left = 0, right = 0}
end


local mouse_map = {
    "left",
    "middle",
    "right",
    "x1",
    "x2"
}

local controller_map = {
    "invalid",
    "a",
    "b",
    "x",
    "y",
    "back",
    "guide",
    "start",
    "left_stick",
    "right_stick",
    "left_shoulder",
    "right_shoulder",
    "up",
    "down",
    "left",
    "right",
    "misc",
    "paddle1",
    "paddle2",
    "paddle3",
    "paddle4",
    "max"
}


local SDL_PollEvent_hook
SDL_PollEvent_hook = minhook.create_hook(SDL.SDL_PollEvent, function(event)
    local success, result = pcall(function()
        if(input.frame_finished)then
            input:Reset()
            input.frame_finished = false
        end

        local ret = SDL_PollEvent_hook.original(event)
        if ret == 0 then
            input.frame_finished = true
            return 0
        end

        if event.type == SDL.SDL_TEXTINPUT then
            local char = ffi.string(event.text.text)
            --print(char)
            table.insert(input.chars, char)
        elseif event.type == SDL.SDL_KEYDOWN then
            local key_name = ffi.string(SDL.SDL_GetKeyName(event.key.keysym.sym)):lower()

            --print(key_name)

            input.inputs[key_name] = GameGetFrameNum()
            if not input.held[key_name] then
                input.pressed[key_name] = GameGetFrameNum()
                --print(key_name)
            end
            input.held[key_name] = GameGetFrameNum()
        elseif event.type == SDL.SDL_KEYUP then
            local key_name = ffi.string(SDL.SDL_GetKeyName(event.key.keysym.sym)):lower()
            if(input.held[key_name])then
                input.released[key_name] = true
                input.held[key_name] = nil
            end
        elseif event.type == SDL.SDL_MOUSEMOTION then
            input.mouse.x = event.motion.x
            input.mouse.y = event.motion.y
        elseif event.type == SDL.SDL_MOUSEBUTTONDOWN then
            local map_button = mouse_map[event.button.button]
            input.mouse.held[map_button] = true
            input.mouse.pressed[map_button] = true
        elseif event.type == SDL.SDL_MOUSEBUTTONUP then
            local map_button = mouse_map[event.button.button]
            input.mouse.held[map_button] = nil
            input.mouse.released[map_button] = true
        elseif event.type == SDL.SDL_CONTROLLERBUTTONDOWN then
            local button_id = tonumber(event.cbutton.button) + 2
            local button = controller_map[button_id]

            mp_log:print(tostring(button))
            if not input.controller.held[button] then
                input.controller.pressed[button] = GameGetFrameNum()
            end
            input.controller.held[button] = GameGetFrameNum()
        elseif event.type == SDL.SDL_CONTROLLERBUTTONUP then
            local button_id = tonumber(event.cbutton.button) + 2
            local button = controller_map[button_id]

            if input.controller.held[button] then
                input.controller.released[button] = true
                input.controller.held[button] = nil
            end
        elseif event.type == SDL.SDL_CONTROLLERAXISMOTION then
            local axis = event.caxis.axis
            local value = event.caxis.value / 32767
            -- Depending on the axis, set the input for left or right thumbstick
            if axis == SDL.SDL_CONTROLLER_AXIS_LEFTX then
                input.controller.left_stick.x = value
            elseif axis == SDL.SDL_CONTROLLER_AXIS_LEFTY then
                input.controller.left_stick.y = value
            elseif axis == SDL.SDL_CONTROLLER_AXIS_RIGHTX then
                input.controller.right_stick.x = value
            elseif axis == SDL.SDL_CONTROLLER_AXIS_RIGHTY then
                input.controller.right_stick.y = value
            elseif axis == SDL.SDL_CONTROLLER_AXIS_TRIGGERLEFT then
                input.controller.triggers.left = value
            elseif axis == SDL.SDL_CONTROLLER_AXIS_TRIGGERRIGHT then
                input.controller.triggers.right = value
            end
        end

        return ret
    end)

    if success then
        return result
    end

    print("Input error: " .. result)
    return 0
end)

minhook.enable(SDL.SDL_PollEvent)

input.WasKeyPressed = function(self, key)
    if(key == nil)then
        return false
    end
    return self.pressed[key] ~= nil
end

input.IsKeyDown = function(self, key)
    if(key == nil)then
        return false
    end
    return self.held[key] ~= nil
end

input.WasKeyReleased = function(self, key)
    if(key == nil)then
        return false
    end
    return self.released[key] ~= nil
end

input.WasMousePressed = function(self, button)
    if(button == nil)then
        return false
    end
    if(type(button) == "number")then
        button = mouse_map[button]
    end
    return self.mouse.pressed[button] ~= nil
end

input.IsMouseDown = function(self, button)
    if(button == nil)then
        return false
    end
    if(type(button) == "number")then
        button = mouse_map[button]
    end
    return self.mouse.held[button] ~= nil
end

input.WasMouseReleased = function(self, button)
    if(button == nil)then
        return false
    end
    if(type(button) == "number")then
        button = mouse_map[button]
    end
    return self.mouse.released[button] ~= nil
end

input.WasGamepadButtonPressed = function(self, button)
    TryInitController()
    if(button == nil)then
        return false
    end
    return self.controller.pressed[button] ~= nil
end

input.IsGamepadButtonDown = function(self, button)
    TryInitController()
    if(button == nil)then
        return false
    end
    return self.controller.held[button] ~= nil
end

input.WasGamepadButtonReleased = function(self, button)
    TryInitController()
    if(button == nil)then
        return false
    end
    return self.controller.released[button] ~= nil
end

input.GetGamepadAxis = function(self, axis)
    TryInitController()
    if(axis == nil)then
        return 0
    end
    if(axis == "left_stick")then
        return self.controller.left_stick.x, self.controller.left_stick.y
    elseif(axis == "right_stick")then
        return self.controller.right_stick.x, self.controller.right_stick.y
    elseif(axis == "left_trigger")then
        return self.controller.triggers.left
    elseif(axis == "right_trigger")then
        return self.controller.triggers.right
    end
end

input.GetMousePos = function(self)
    return self.mouse.x, self.mouse.y
end

input.GetUIMousePos = function(self, gui)
    local input_manager = EntityGetWithName("input_manager")
    if(input_manager == nil or not EntityGetIsAlive(input_manager))then
        input_manager = EntityLoad("mods/noita-mp/files/data/entities/input_manager.xml")
    end

    local controls_component = EntityGetFirstComponentIncludingDisabled(input_manager, "ControlsComponent")
    local screen_width, screen_height = GuiGetScreenDimensions(gui)
    local mouse_raw_x, mouse_raw_y = ComponentGetValue2(controls_component, "mMousePositionRaw")
    local mx, my = mouse_raw_x * screen_width / 1280, mouse_raw_y * screen_height / 720

    return mx, my
end

input.GetInput = function(self, key)
    if(key == nil)then
        return false
    end
    return self.inputs[key]
end

input.GetChars = function(self)
    return self.chars
end

return input
