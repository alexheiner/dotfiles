local queries = require("csharp-xml-doc.queries")

local M = {}

-- Node types that should have XML documentation
M.SUPPORTED_NODES = {
	"method_declaration",
	"constructor_declaration",
	"class_declaration",
	"interface_declaration",
	"struct_declaration",
	"enum_declaration",
	"property_declaration",
	"field_declaration",
}

-- Check if a node type is supported
function M.is_supported_node(node_type)
	for _, supported_type in ipairs(M.SUPPORTED_NODES) do
		if node_type == supported_type then
			return true
		end
	end
	return false
end

-- Find the declaration node at or above the cursor
function M.find_declaration_node(node)
	local current = node
	while current do
		local node_type = current:type()
		if M.is_supported_node(node_type) then
			return current
		end
		current = current:parent()
	end
	return nil
end

-- Extract parameter information from a method/constructor using Treesitter query
function M.extract_parameters(node)
	local params = {}

	if not queries.PARAMETERS then
		return params
	end

	-- Find the immediate parameter_list child to avoid capturing nested method parameters
	local param_list_node = nil
	for child in node:iter_children() do
		if child:type() == "parameter_list" then
			param_list_node = child
			break
		end
	end

	if not param_list_node then
		return params
	end

	local bufnr = 0
	for id, capture_node in queries.PARAMETERS:iter_captures(param_list_node, bufnr) do
		local capture_name = queries.PARAMETERS.captures[id]
		if capture_name == "param.name" then
			local param_name = vim.treesitter.get_node_text(capture_node, bufnr)
			table.insert(params, { name = param_name })
		end
	end

	return params
end

-- Extract return type from a method declaration using Treesitter query
function M.extract_return_type(node)
	local node_type = node:type()

	-- Constructors don't have return types
	if node_type == "constructor_declaration" then
		return nil
	end

	-- For methods, use query to find the return type
	if node_type == "method_declaration" then
		if not queries.RETURN_TYPE then
			return nil
		end

		local bufnr = 0
		for id, capture_node in queries.RETURN_TYPE:iter_captures(node, bufnr) do
			local capture_name = queries.RETURN_TYPE.captures[id]
			if capture_name == "return.type" then
				return vim.treesitter.get_node_text(capture_node, bufnr)
			end
		end
	end

	return nil
end

-- Find all exception types thrown in a method body using Treesitter query
function M.extract_exceptions(node)
	local exceptions = {}
	local seen = {}

	-- Find the method body
	local body_node = nil
	for child in node:iter_children() do
		if child:type() == "block" or child:type() == "arrow_expression_clause" then
			body_node = child
			break
		end
	end

	if not body_node or not queries.EXCEPTIONS then
		return exceptions
	end

	-- Use query to find all throw statements in the body
	local bufnr = 0
	for id, capture_node in queries.EXCEPTIONS:iter_captures(body_node, bufnr) do
		local capture_name = queries.EXCEPTIONS.captures[id]
		if capture_name == "exception.type" then
			local exception_type = vim.treesitter.get_node_text(capture_node, bufnr)
			-- Deduplicate exceptions
			if not seen[exception_type] then
				seen[exception_type] = true
				table.insert(exceptions, exception_type)
			end
		end
	end

	return exceptions
end

-- Extract generic type parameters from a declaration using Treesitter query
function M.extract_type_parameters(node)
	local type_params = {}
	local node_type = node:type()

	-- Skip type parameters for properties and fields
	if node_type == "property_declaration" or node_type == "field_declaration" then
		return type_params
	end

	if not queries.TYPE_PARAMETERS then
		return type_params
	end

	-- Find the immediate type_parameter_list child to avoid capturing nested type parameters
	local type_param_list_node = nil
	for child in node:iter_children() do
		if child:type() == "type_parameter_list" then
			type_param_list_node = child
			break
		end
	end

	if not type_param_list_node then
		return type_params
	end

	local bufnr = 0
	for id, capture_node in queries.TYPE_PARAMETERS:iter_captures(type_param_list_node, bufnr) do
		local capture_name = queries.TYPE_PARAMETERS.captures[id]
		if capture_name == "type_param.name" then
			local param_name = vim.treesitter.get_node_text(capture_node, bufnr)
			table.insert(type_params, { name = param_name })
		end
	end

	return type_params
end

-- Check if XML documentation already exists above the node
function M.has_existing_documentation(node)
	local start_row = node:start()

	if start_row == 0 then
		return false
	end

	-- Check the line above the declaration
	local prev_line = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, false)[1]

	if prev_line and prev_line:match("^%s*///%s*") then
		return true
	end

	return false
end

-- Determine if this is a method-like declaration that needs params/returns/exceptions
function M.is_method_like(node_type)
	return node_type == "method_declaration" or node_type == "constructor_declaration"
end

return M
