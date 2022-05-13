local function new_string_buffer(str)
  if str == nil then
    error("String is nil", 2)
  end
  local index = 1
  local buffer = {}
  buffer.peek = function(self, offset, amount)
    offset = offset or 0
    amount = amount or 1
    local ch = str:sub(index+offset, index+offset+(amount-1))
    if ch == "" then
      return nil
    else
      return ch
    end
  end
  -- Read current char, then advance to next char
  buffer.read = function(self, amount)
    amount = amount or 1
    local str
    for i=1, amount do
      if not buffer:is_done() then
        str = (str or "") .. buffer:peek()
        index = index + 1
      end
    end
    return str
  end
  buffer.is_done = function(self, offset)
    offset = offset or 0
    return buffer:peek(offset) == nil
  end
  buffer.set_pos = function(self, pos)
    pos = tonumber(pos)
    if not pos then
      error("pos must be a number", 2)
    end
    self.index = pos
  end
  buffer.skip_while = function(self, predicate)
    while not buffer:is_done() and predicate(self) do
      buffer:read()
    end
  end
  buffer.read_while = function(self, predicate)
    local out
    while not buffer:is_done() and predicate(buffer) do
      out = out or ""
      -- print('buffer:peek() (' .. tostring(buffer:peek()) .. ':'.. type(buffer:peek()) .. ')')
      out = out .. buffer:read()
    end
    return out
  end
  -- Tries to find a certain sequence and returns the offset from current position if found, otherwise nil
  buffer.find = function(self, look_for)
    if type(look_for) ~= "string" then
      error("Argument must be a string", 2)
    end
    local offset = 0
    while not buffer:is_done(offset) and buffer:peek(offset, #look_for) ~= look_for do
      offset = offset + 1
    end
    if buffer:is_done(offset) then
      return nil
    else
      return offset
    end
  end
  buffer.skip = function(self, n)
    index = index + (n or 1)
  end
  buffer.skip_string = function(self, str)
    index = index + (n or 1)
  end
  buffer.pos = function(self)
    return index
  end
  buffer.look_ahead = function(self, look_for)
    if type(look_for) ~= "string" then
      error("Argument must be a string", 2)
    end
    for i=0, #look_for-1 do
      local ch = look_for:sub(i+1, i+1)
      if ch ~= buffer:peek(i) then
        return false
      end
    end
    return true
  end
  buffer.str = str
  return buffer
end

return new_string_buffer
