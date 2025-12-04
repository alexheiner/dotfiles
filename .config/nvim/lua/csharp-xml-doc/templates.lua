local M = {}

-- Get the indentation of the current line
function M.get_indent(line)
	return line:match("^%s*") or ""
end

-- Generate a simple summary-only comment (for classes, properties, fields, etc.)
function M.generate_simple(indent, type_params)
	type_params = type_params or {}

	local lines = {
		indent .. "/// <summary>",
		indent .. "/// ",
		indent .. "/// </summary>",
	}

	-- Add typeparam tags for generic types (classes, interfaces, structs)
	for _, type_param in ipairs(type_params) do
		table.insert(lines, indent .. "/// <typeparam name=\"" .. type_param.name .. "\"></typeparam>")
	end

	return lines
end

-- Generate a method/function XML comment with type params, params, returns, and exceptions
function M.generate_method(indent, type_params, params, return_type, exceptions)
	local lines = {
		indent .. "/// <summary>",
		indent .. "/// ",
		indent .. "/// </summary>",
	}

	-- Add parameter tags
	for _, param in ipairs(params) do
		table.insert(lines, indent .. "/// <param name=\"" .. param.name .. "\"></param>")
	end

	-- Add typeparam tags for generic methods (after params, before returns)
	for _, type_param in ipairs(type_params) do
		table.insert(lines, indent .. "/// <typeparam name=\"" .. type_param.name .. "\"></typeparam>")
	end

	-- Add returns tag for non-void methods
	if return_type and return_type ~= "void" then
		table.insert(lines, indent .. "/// <returns></returns>")
	end

	-- Add exception tags
	for _, exception in ipairs(exceptions) do
		table.insert(lines, indent .. "/// <exception cref=\"" .. exception .. "\"></exception>")
	end

	return lines
end

-- Calculate the cursor position (line offset, column) for the summary tag
function M.get_summary_cursor_position(start_line, indent)
	-- Position is on line 2 (0-indexed: line 1), after "/// " (indent + 4)
	return {
		line = start_line + 1,
		col = #indent + 4,
	}
end

return M
