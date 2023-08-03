--------------------------------------------------------------------------------
-- Copyright (c) 2011, 2014 Sierra Wireless and others.
-- All rights reserved. This program and the accompanying materials
-- are made available under the terms of the Eclipse Public License v1.0
-- which accompanies this distribution, and is available at
-- http://www.eclipse.org/legal/epl-v10.html
--
-- Contributors:
--     Sierra Wireless - initial API and implementation
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Uses Metalua capabilities to indent code and provide source code offset
-- semantic depth.
--
-- @module formatter
--
--------------------------------------------------------------------------------

local M = {}
require 'metalua.loader'
local math = require 'math'
local mlc  = require 'metalua.compiler'.new()
local Q    = require 'metalua.treequery'

local COMMENT = '--'

--------------------------------------------------------------------------------
-- Format utilities
--------------------------------------------------------------------------------

---
-- Comment adjusted first line and first offset of a node.
--
-- @return #int, #int
local function getfirstline(node, ignorecomments)
  -- Consider preceding comments as part of current chunk
  -- WARNING: This is NOT the default in Metalua
  local first, offset
  local offsets = node.lineinfo
  if offsets.first.comments and not ignorecomments then
    first = offsets.first.comments.lineinfo.first.line
    offset = offsets.first.comments.lineinfo.first.offset
  else
    -- Regular node
    first = offsets.first.line
    offset = offsets.first.offset
  end
  return first, offset
end

---
-- Last line of a node.
--
-- @return #int
local function getlastline(node)
  return node.lineinfo.last.line , node.lineinfo.last.offset
end

local function indent(cfg, st, startline, startindex, endline, parent)

  -- Indent following lines when current one does not start with first statement
  -- of current block.
  if not cfg.source:sub(1,startindex-1):find("[\r\n]%s*$") then
    startline = startline + 1
  end

  -- Nothing interesting to do
  if endline < startline then
    return
  end

  -- Indent block first line
  st.indentation[startline] = true

  -- Restore indentation
  if not st.unindentation[endline+1] then
    -- Only when not performed by a higher node
    st.unindentation[endline+1] = getfirstline(parent)
  end
end

---
-- Indent all lines of an expression list.
local function indentexprlist(cfg, st, node, parent, ignorecomments)
  local endline = getlastline(node)
  local startline, startindex = getfirstline(node, ignorecomments)
  indent(cfg, st, startline, startindex, endline, parent)
end

---
-- Indents `Local and `Set
local function assignments(cfg, st, node)

  -- Indent only when node spreads across several lines
  local nodestart = getfirstline(node, true)
  local nodeend = getlastline(node)
  if nodestart >= nodeend then
    return
  end

  -- Format it
  local lhs, exprs = unpack(node)
  if #exprs == 0 then
    -- Regular `Local handling
    indentexprlist(cfg, st, lhs, node)
    -- Avoid problems and format functions later.
  elseif not (#exprs == 1 and exprs[1].tag == 'Function') then

    -- for local, indent lhs
    if node.tag == 'Local' then

      -- Else way, indent LHS and expressions like a single chunk.
      local endline = getlastline(exprs)
      local startline, startindex = getfirstline(lhs, true)
      indent(cfg, st, startline, startindex, endline, node)

    end

    -- In this chunk indent expressions one more.
    indentexprlist(cfg, st, exprs, node)
  end
end

---
-- Indents parameters
--
-- @param callable  Node containing the params
-- @param firstparam first parameter of the given callable
local function indentparams(cfg, st, firstparam, lastparam, parent)

  -- Determine parameters first line
  local paramstartline,paramstartindex = getfirstline(firstparam)

  -- Determine parameters last line
  local paramlastline = getlastline(lastparam)

  -- indent
  indent(cfg, st, paramstartline, paramstartindex, paramlastline, parent)
end

---
-- Indent all lines of a chunk.
local function indentchunk(cfg, st, node, parent)

  -- Get regular start
  local startline, startindex = getfirstline(node[1])

  -- Handle trailing comments as they were statements
  local endline
  local lastnode = node[#node]
  if lastnode.lineinfo.last.comments then
    endline = lastnode.lineinfo.last.comments.lineinfo.last.line
  else
    endline = lastnode.lineinfo.last.line
  end

  indent(cfg, st, startline, startindex, endline, parent)
end

--------------------------------------------------------------------------------
-- Expressions formatters
--------------------------------------------------------------------------------
local case = { }

function case.String(cfg, st, node)
  local firstline, _ = getfirstline(node,true)
  local lastline = getlastline(node)
  for line=firstline+1, lastline do
    st.indentation[line]=false
  end
end

function case.Table(cfg, st, node)

  if not cfg.indenttable then
    return
  end

  -- Format only inner values across several lines
  local firstline, firstindex = getfirstline(node,true)
  local lastline = getlastline(node)
  if #node > 0 and firstline < lastline then

    -- Determine first line to format
    local firstnode = unpack(node)
    local childfirstline, childfirstindex = getfirstline(firstnode)

    -- Determine last line to format
    local lastnode = #node == 1 and firstnode or node[ #node ]
    local childlastline = getlastline(lastnode)

    -- Actual formating
    indent(cfg, st, childfirstline, childfirstindex, childlastline, node)
  end
end

--------------------------------------------------------------------------------
-- Statements formatters
--------------------------------------------------------------------------------
function case.Call(cfg, st, node)
  local expr, firstparam = unpack(node)
  if firstparam then
    indentparams(cfg, st, firstparam, node[#node], node)
  end
end

function case.Do(cfg, st, node, parent)
  -- Ignore empty node
  if #node == 0 or not parent then
    return
  end
  indentchunk(cfg, st, node, parent)
end

function case.Forin(cfg, st, node)
  local ids, iterator, _ = unpack(node)
  indentexprlist(cfg, st, ids, node)
  indentexprlist(cfg, st, iterator, node)
end

function case.Fornum(cfg, st, node)
  -- Format from variable name to last expressions
  local var, init, limit, range = unpack(node)
  local startline, startindex   = getfirstline(var)

  -- Take range as last expression, when not available limit will do
  local lastexpr = range.tag and range or limit
  indent(cfg, st, startline, startindex, getlastline(lastexpr), node)
end

function case.Function(cfg, st, node)
  local params, chunk = unpack(node)
  indentexprlist(cfg, st, params, node)
end

function case.Index(cfg, st, node, parent)

  -- Bug 422778 - [ast] Missing a lineinfo attribute on one Index
  -- the following if is a workaround avoid a nil exception but the formatting
  -- of the current node is avoided.
  if not node.lineinfo then
    return
  end
  -- avoid indent if the index is on one line
  local nodestartline = node.lineinfo.first.line
  local nodeendline = node.lineinfo.last.line
  if nodeendline == nodestartline then
    return
  end

  local left, right = unpack(node)
  -- Bug 422778 [ast] Missing a lineinfo attribute on one Index
  -- the following line is a workaround avoid a nil exception but the
  -- formatting of the current node is avoided.
  if left.lineinfo then
    local leftendline, leftendoffset = getlastline(left)
    -- For Call,Set and Local nodes we want to indent to end of the parent node
    -- not only the index itself
    local parentisassignment = parent.tag == 'Set' or parent.tag == 'Local'
    local parenthaschild = parent[1] and #parent[1] ==  1
    if (parent[1] == node and parent.tag == 'Call') or
      (parentisassignment and parenthaschild and parent[1][1] == node)
    then
      local parentendline = getlastline(parent)
      indent(cfg, st, leftendline, leftendoffset+1, parentendline, parent)
    else
      local rightendline = getlastline(right)
      indent(cfg, st, leftendline, leftendoffset+1, rightendline, node)
    end
  end

end

function case.If(cfg, st, node)
  -- Indent only conditions, chunks are already taken care of.
  local nodesize = #node
  for conditionposition=1, nodesize-(nodesize%2), 2 do
    indentexprlist(cfg, st, node[conditionposition], node)
  end
end

function case.Invoke(cfg, st, node)
  local expr, str, firstparam = unpack(node)

  --indent str
  local exprendline, exprendoffset = getlastline(expr)
  local nodeendline = getlastline(node)
  indent(cfg, st, exprendline, exprendoffset+1, nodeendline, node)

  --indent parameters
  if firstparam then
    indentparams(cfg, st, firstparam, node[#node], str)
  end

end

function case.Repeat(cfg, st, node)
  local _, expr = unpack(node)
  indentexprlist(cfg, st, expr, node)
end

function case.Return(cfg, st, node, parent)
  if #node > 0 then
    indentchunk(cfg, st, node, parent)
  end
end

case.Local = assignments
case.Set   = assignments

function case.While(cfg, st, node)
  local expr, _ = unpack(node)
  indentexprlist(cfg, st, expr, node)
end

--------------------------------------------------------------------------------
-- Calculate all indent level
-- @param Source code to analyze
-- @return #table {linenumber = indentationlevel}
-- @usage local depth = format.indentLevel("local var")
--------------------------------------------------------------------------------
local function getindentlevel(source, indenttable)

  if not loadstring(source, 'CheckingFormatterSource') then
    return
  end

  -----------------------------------------------------------------------------
  -- Walk through AST
  --
  -- Walking the AST, we store which lines deserve one and always one
  -- indentation.
  --
  -- We will not indent back. To obtain a smaller indentation, we will refer to
  -- a less indented preceding line.
  --
  -- Why so complicated?
  -- We use two tables as `state` simply for handling the case of one line
  -- indentation.
  -- We choose to use reference to a preceding line to avoid handling
  -- indent-back computation and mistakes. When leaving a node after formatting
  -- it, we simply use indentation of before entering this node.
  -----------------------------------------------------------------------------
  local configuration = {
    indenttable = indenttable,
    source = source
  }

  --
  local state = {
    -- Indentations line numbers
    indentation = { },
    -- Key:   Line number to indent back.
    -- Value: Previous line number, it has the indentation depth wanted.
    unindentation = { }
  }

  local function onNode(...)
    local tag = (...).tag
    if not tag then case.Do(configuration, state, ...) else
      local f = case[tag]
      if f then f(configuration, state, ...) end
    end
  end

  local ast = mlc:src_to_ast(source)
  Q(ast) :foreach(onNode)

  -- Built depth table
  local currentdepth = 0
  local depthtable = {}
  for line=1, getlastline(ast[#ast]) do

    -- Restore depth
    if state.unindentation[line] then
      currentdepth = depthtable[state.unindentation[line]]
    end

    -- Indent
    if state.indentation[line] then
      currentdepth = currentdepth + 1
      depthtable[line] = currentdepth
    elseif state.indentation[line] == false then
      -- Ignore any kind of indentation
      depthtable[line] = false
    else
      -- Use current indentation
      depthtable[line] = currentdepth
    end

  end
  return depthtable
end

--------------------------------------------------------------------------------
-- Trim white spaces before and after given string
--
-- @usage local trimmedstr = trim('          foo')
-- @param #string string to trim
-- @return #string string trimmed
--------------------------------------------------------------------------------
local function trim(string)
  local pattern = "^(%s*)(.*)"
  local _, strip =  string:match(pattern)
  if not strip then return string end
  local restrip
  _, restrip = strip:reverse():match(pattern)
  return restrip and restrip:reverse() or strip
end

--------------------------------------------------------------------------------
-- Provides position of next end of line
--
-- @param #string str Where to seek for end of line
-- @param #number strstart Search starting index
-- @return #number, #number Start and end of end of line
-- @return #nil When no end of line is found
--------------------------------------------------------------------------------
local delimiterposition = function (str, strstart)
  local starts = {}
  local ends = {}
  for _, delimiter in ipairs({'\r\n', '\n', '\r'}) do
    local dstart, dend = str:find(delimiter, strstart, true)
    if dstart and not ends[dstart] then
      starts[#starts + 1] = dstart
      ends[dstart] = dend
    end
  end
  if #starts > 0 then
    local min = math.min( unpack(starts) )
    return min, ends[min]
  end
end

--------------------------------------------------------------------------------
-- Indent Lua Source Code.
--
-- @function [parent=#formatter] indentcode
-- @param #string source Source code to format
-- @param #string delimiter Delimiter used in resulting formatted source
-- @param indenttable true if you want to indent in table
-- @param ...
-- @return #string Formatted code
-- @return #nil, #string In case of error
-- @usage indentCode('local var', '\n', true, '\t')
-- @usage indentCode('local var', '\n', true, --[[tabulationSize]]4, --[[indentationSize]]2)
--------------------------------------------------------------------------------
function M.indentcode(source, delimiter,indenttable, ...)

  --
  -- Create function which will generate indentation
  --
  local tabulation
  if select('#', ...) > 1 then
    local tabSize = select(1, ...)
    local indentationSize = select(2, ...)
    -- When tabulation size and indentation size is given, tabulation is
    -- composed of tabulation and spaces
    tabulation = function(depth)
      local range = depth * indentationSize
      local tabCount = math.floor(range / tabSize)
      local spaceCount = range % tabSize
      local tab = '\t'
      local space = ' '
      return tab:rep(tabCount) .. space:rep(spaceCount)
    end
  else
    local char = select(1, ...)
    -- When tabulation character is given, this character will be duplicated
    -- according to length
    tabulation = function (depth) return char:rep(depth) end
  end

  -- Delimiter position table
  -- Initialization represent string's start offset
  local positions = {0}

  -- Handle shebang
  local shebang = source:match('^#')
  if shebang then
    -- Simply comment shebang when formating
    source = table.concat({COMMENT, source})
  end

  -- Check code validity
  local status, message = loadstring(source,"isCodeValid")
  if not status then return status, message end

  --
  -- Seek for delimiters positions
  --
  local sourcePosition = 1
  repeat
    -- Find end of line
    local delimiterStart, delimiterEnd = delimiterposition(source,
      sourcePosition)
    if delimiterStart then
      if delimiterEnd < #source then
        positions[#positions + 1] = delimiterStart
      end
      sourcePosition = delimiterEnd + 1
    end
  until not delimiterStart

  -- No need for indentation, when no delimiter has been found
  if #positions < 2 then
    return shebang and source:sub(1 + #COMMENT) or source
  end

  -- calculate indentation
  local linetodepth = getindentlevel(source, indenttable)

  -- Concatenate string with right indentation
  local indented = {}
  for position=1, #positions do
    -- Extract source code line
    local offset = positions[position]
    -- Get the interval between two positions
    local rawline
    if positions[position + 1] then
      rawline = source:sub(offset + 1, positions[position + 1] -1)
    else
      -- From current position to end of line
      rawline = source:sub(offset + 1)
    end

    -- Trim white spaces
    local indentcount = linetodepth[position]
    if not indentcount then
      indented[#indented+1] = rawline
    else
      -- Indent only when there is code on the line
      local line = trim(rawline)
      if #line > 0 then

        -- Prefix with right indentation
        if indentcount > 0 then
          indented[#indented+1] = tabulation( indentcount )
        end

        -- Append trimmed source code
        indented[#indented+1] = line
      end
    end

    -- Append new line
    if position < #positions then
      indented[#indented+1] = delimiter
    end
  end

  -- Ensure single final new line
  if #indented > 0 and not indented[#indented]:match('%s$') then
    indented[#indented + 1] = delimiter
  end

  -- Uncomment shebang when needed
  local formattedcode = table.concat(indented)
  if shebang and #formattedcode then
    return formattedcode:sub(1 + #COMMENT)
  end
  return formattedcode
end

return M
