-- Pre-compiled Treesitter queries for C# XML documentation
local M = {}

-- Safe query parsing with error handling
local function safe_parse(language, query_string, query_name)
	local ok, query = pcall(vim.treesitter.query.parse, language, query_string)
	if not ok then
		vim.notify(
			string.format("C# XML Doc: Failed to parse %s query: %s", query_name, query),
			vim.log.levels.WARN
		)
		return nil
	end
	return query
end

-- Pre-compile all queries at module load time
M.PARAMETERS = safe_parse("c_sharp", [[
	(parameter_list
		(parameter
			name: (identifier) @param.name))
]], "parameters")

M.RETURN_TYPE = safe_parse("c_sharp", [[
	(method_declaration
		returns: (_) @return.type)
]], "return_type")

M.EXCEPTIONS = safe_parse("c_sharp", [[
	[
		(throw_statement
			(object_creation_expression
				type: (_) @exception.type))
		(throw_expression
			(object_creation_expression
				type: (_) @exception.type))
	]
]], "exceptions")

M.TYPE_PARAMETERS = safe_parse("c_sharp", [[
	(type_parameter_list
		(type_parameter
			(identifier) @type_param.name))
]], "type_parameters")

return M
