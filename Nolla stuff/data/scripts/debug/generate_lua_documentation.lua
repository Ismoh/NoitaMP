-- Work in progress!
-- TODO: Ensure all signatures have parseable grammar

-- read input from in_function_signatures
-- local parsed = parse( in_function_signatures )
-- out_html = generate_html( parsed )
-- out_json = generate_json( parsed )

-- make luacheck not complain about the supposedly missing global
if in_function_signatures == nil then
	in_function_signatures = {}
end

---
out_html = ""
--out_json = ""

local html_style = [[
	body{
		background-color: lightgray;
		font-family: monospace;
		font-size: large;
		padding: 10px;
		width: 100%;
	}
	table, th, td {
		table-layout: fixed;
		width: 100%;
		border: 1px solid gray;
		border-collapse: collapse;
		text-align: left;
		vertical-align: top;
		font-size: large;
		padding: 3px;
	}
	tr:hover {
		background-color: #f5f5f5;
	}
	.function{
		color:black;
		font-weight: bold;
	}
	.field_name{
		color:black;
		font-weight: normal;
	}
	.description{
		color:black;
		font-weight: normal;
		font-family: sans-serif;
		font-size: medium
	}
]]



local function split_and_classify(s)
	-- splits and classifies a function signature's contents for formatting

	--[[
	Function( parameter_name:type = default_value, ...) -> result_name:type,... [description]
	currently turns into:
	{
		func = {
			name = "",
			parameters = "",
		}
		return_values =
		{
			"",
			...
		}
		description = ""
	}
	--]]

	local t = {}

	-- identify sections
	local description_begin_idx = string.find(s, "%[")
	local description_end_idx = string.find(s, "%]")
	local return_values_idx = string.find(s, "->")

	-- store section contents
	
	-- store return values
	if return_values_idx then
		local end_idx = -1
		if description_begin_idx then end_idx = description_begin_idx - 2 end
		t.return_values = string.sub(s, return_values_idx+3, end_idx)

		t.return_values = t.return_values:gsub(",", ", ")
	else
		t.return_values = ""
	end

	-- store description
	if description_begin_idx and description_end_idx then
		t.description = string.sub(s, description_begin_idx+1, description_end_idx-1)
	else
		t.description = ""
	end

	-- function & parameters
	t.func = {}
	t.func.parameters = {}
	-- strip rest of string away so only function call portion remains
	if return_values_idx then
		s = string.sub(s, 0, return_values_idx - 2)
	elseif description_begin_idx then
		s = string.sub(s, 0, description_begin_idx - 1)
	else
		s = string.sub(s, 0, -1)
	end

	local parameters_begin_idx = string.find(s, "%(")
	local parameters_end_idx = string.find(s, "%)")
	
	-- store function name
	t.func.name = string.sub(s, 0, parameters_begin_idx - 1)

	-- store function parameters
	local parameters = string.sub(s, string.find(s, "%(")+1, string.find(s, "%)")-1)
	t.func.parameters = parameters

	--for p in string.gmatch(parameters, "([^,]+)") do -- split at comma
    --	t.func.parameters[#t.func.parameters+1] = p
    --end

	return t
end

local function parse(function_signatures)
	local out = {}
	for _,v in ipairs(function_signatures) do
		out[#out+1] = split_and_classify(v)
	end
	return out
end

local function generate_html(parsed)
	-- begin html
	-- creates a table with a function on each row
	local s = "<html>\n<head>\n<style>\n" .. html_style .. "</style>\n<body>\n"

	s = s .. "<table style=\"width:75%\">"
	-- functions
	for _,fn in pairs(parsed) do
		-- begin row
		s = s .. "<tr>\n"
		
		-- COLUMN: function and parameters
		s = s .. "<th>"
		s = s .. "<span class=\"function\">" .. fn.func.name .. "</span>("
		-- parameters
		s = s .. "<span class=\"field_name\">" .. fn.func.parameters .. "</span>"
		--for _,v in pairs(fn.func.parameters) do
		--	s = s .. "<span class=\"field_name\">" .. v .. ", </span>"
		--end
		s = s .. "<span class=\"func\">)</span>"
		s = s .. "</th>\n"

		-- COLUMN: return values
		s = s .. "<th>" -- next col
		s = s .. "<span class=\"field_name\">" .. fn.return_values .. "</span></th>"
		s = s .. "</th>\n"

		-- COLUMN: desc
		s = s .. "<th>" -- next col
		s = s .. "<span class=\"description\">" .. fn.description .. "</span></th>"
		s = s .. "</th>\n"

		-- end row
		s = s .. "</tr>\n"
	end

	-- end html
	s = s .. "\n</body></html>"
	return s
end

local parsed = parse(in_function_signatures)
out_html = generate_html(parsed)
