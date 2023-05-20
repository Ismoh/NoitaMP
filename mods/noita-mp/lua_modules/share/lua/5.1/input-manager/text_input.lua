local text_input = {}
local utf8 = require("lua-utf8")
local input = require("input-manager.input")

text_input.create = function(gui, x, y, width, default_text, character_limit, allowed_characters, banned_characters, z_index)
    local input_instance = {}
    input_instance.gui = gui
    input_instance.x = x
    input_instance.y = y
    input_instance.width = width
    input_instance.default_text = default_text
    input_instance.character_limit = character_limit or 0
    input_instance.allowed_characters = {}
    input_instance.banned_characters = {}
    input_instance.z_index = z_index or 0
    input_instance.text = default_text or ""
    input_instance.cursor_pos = 0
    input_instance.cursor_timer = 0
    input_instance.cursor_visible = true
    input_instance.focus = false
    input_instance.id = 159023

    allowed_characters = allowed_characters or nil

    print("Creating text input with allowed characters: " .. tostring(allowed_characters))

    -- add allowed characters

    if(allowed_characters ~= nil)then
        for char_index = 1, utf8.len(allowed_characters) do
            local character = utf8.sub(allowed_characters, char_index, char_index)
            input_instance.allowed_characters[character] = true
        end
    end

    -- add banned characters

    if(banned_characters ~= nil)then
        for char_index = 1, utf8.len(banned_characters) do
            local character = utf8.sub(banned_characters, char_index, char_index)
            input_instance.banned_characters[character] = true
        end
    end

    input_instance.new_id = function(self)
        self.id = self.id + 1
        return self.id
    end

    input_instance.start_frame = function(self)
        self.id = 0
    end

    input_instance.transform = function(self, x, y, width)
        self.width = width
        self.x = x
        self.y = y
    end

    input_instance.update = function(self)

        local mouse_x, mouse_y = input:GetUIMousePos(self.gui)
        local left_clicked = input:WasMousePressed("left")

        -- check if we are clicking on the input
        if(left_clicked and mouse_x >= self.x + 2 and mouse_x <= (self.x + 2) + (self.width - 4) and mouse_y >= self.y + 2 and mouse_y <= self.y + 12)then
            self.focus = true
            print("Chat input selected.")
        elseif(left_clicked)then
            self.focus = false
        end

        if(not self.focus)then
            return
        end

        -- calculate cursor visibility
        self.cursor_timer = self.cursor_timer + 1
        if (self.cursor_timer > 30) then
            self.cursor_timer = 0
            self.cursor_visible = not self.cursor_visible
        end

        --print(json.stringify(input:GetChars()))
        
        --[[
        if(left_clicked)then
            -- calculate the cursor position
            local cursor_x = mouse_x - (self.x + 2)
            local cursor_pos = 0
            local text_width = 0


        end
        ]]


        if(input:GetInput("space"))then

            -- make sure we are not over the character limit
            if(self.character_limit > 0 and utf8.len(self.text) >= self.character_limit)then
                return
            end

            self.text = utf8.sub(self.text, 1, self.cursor_pos) .. " " .. utf8.sub(self.text, self.cursor_pos + 1)
            self.cursor_pos = self.cursor_pos + 1
            if(self.cursor_pos > utf8.len(self.text))then
                self.cursor_pos = utf8.len(self.text)
            end
        elseif(input:GetInput("backspace"))then
            self.text = utf8.sub(self.text, 1, self.cursor_pos - 1) .. utf8.sub(self.text, self.cursor_pos + 1)
            self.cursor_pos = math.max(0, self.cursor_pos - 1)
        elseif(input:GetInput("delete"))then
            self.text = utf8.sub(self.text, 1, self.cursor_pos) .. utf8.sub(self.text, self.cursor_pos + 2)
        elseif(input:GetInput("left") and (input:IsKeyDown("left ctrl") or input:IsKeyDown("right ctrl")))then
            -- skip back one word
            local new_cursor_pos = self.cursor_pos
            while(new_cursor_pos > 0)do
                new_cursor_pos = new_cursor_pos - 1
                local char = utf8.sub(self.text, new_cursor_pos, new_cursor_pos)
                if(char == " ")then
                    break
                end
            end
            self.cursor_pos = new_cursor_pos
        elseif(input:GetInput("right") and (input:IsKeyDown("left ctrl") or input:IsKeyDown("right ctrl")))then
            -- skip forward one word
            local new_cursor_pos = self.cursor_pos
            while(new_cursor_pos < utf8.len(self.text))do
                new_cursor_pos = new_cursor_pos + 1
                local char = utf8.sub(self.text, new_cursor_pos, new_cursor_pos)
                if(char == " ")then
                    break
                end
            end
            self.cursor_pos = new_cursor_pos
        elseif(input:GetInput("left"))then
            self.cursor_pos = math.max(0, self.cursor_pos - 1)
        elseif(input:GetInput("right"))then
            self.cursor_pos = math.min(self.cursor_pos + 1, utf8.len(self.text))
        else
            local chars = input:GetChars() or {}

            for k, v in ipairs(chars)do

                -- make sure we are not over the character limit
                if(self.character_limit > 0 and utf8.len(self.text) >= self.character_limit)then
                    return
                end

                print("Char: " .. tostring(v))
                if (#(self.allowed_characters) == 0 or self.allowed_characters[v]) then
                    if (self.banned_characters[v]) then
                        return
                    end
                    self.text = utf8.sub(self.text, 1, self.cursor_pos) .. v .. utf8.sub(self.text, self.cursor_pos + 1)
                    self.cursor_pos = self.cursor_pos + 1
                end
            end
        end

    end

    input_instance.draw = function(self)
        self:start_frame()

        local scroll_container_id = 35238523 + GameGetFrameNum() % 2
        GuiBeginScrollContainer(self.gui, scroll_container_id, self.x + 2, self.y + 2, self.width - 4, 15, false, 2, 2)

        -- split text at cursor position
        local text_before_cursor = utf8.sub(self.text, 1, self.cursor_pos)
        local text_after_cursor = utf8.sub(self.text, self.cursor_pos + 1)
        local text_width, text_height = GuiGetTextDimensions(self.gui, self.text)

        -- Check if the text_width is more significant than the container width, then get the cursor width
        local cursor_width = 0
        if text_width > self.width then
            local text_before_cursor = utf8.sub(self.text, 1, self.cursor_pos)
            cursor_width = GuiGetTextDimensions(self.gui, text_before_cursor)
        end

        -- calculate text offset
        local text_offset_x = math.max(0, cursor_width - (self.width - 6))

        GuiLayoutBeginHorizontal(self.gui, -text_offset_x, -1, true)

        if(self.focus)then
            -- draw text before cursor
            GuiText(self.gui, 0, 0, text_before_cursor)

            -- draw cursor
            GuiImage(self.gui, self:new_id(), -2, 1, "mods/noita-mp/files/data/ui_gfx/in_game/input_cursor.png", self.cursor_visible and 1 or 0, 1, 1)

            -- draw text after cursor
            GuiText(self.gui, -2, 0, text_after_cursor)
        else
            GuiText(self.gui, 0, 0, self.text)
        end
        GuiLayoutEnd(self.gui)



        GuiEndScrollContainer(self.gui)
    end

    return input_instance
end

return text_input
