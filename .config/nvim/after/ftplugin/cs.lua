-- C# XML Documentation Comment Plugin
-- This file is automatically loaded when opening C# files

local ts = require("csharp-xml-doc.treesitter")
local templates = require("csharp-xml-doc.templates")

-- Main function to insert XML documentation
local function insert_xml_comment()
	-- Get the current node
	local node = vim.treesitter.get_node()
	if not node then
		vim.notify("No syntax node found at cursor", vim.log.levels.WARN)
		return
	end

	-- Find the declaration node
	local declaration_node = ts.find_declaration_node(node)
	if not declaration_node then
		vim.notify("Cursor is not on a supported declaration", vim.log.levels.WARN)
		return
	end

	-- Check if documentation already exists
	if ts.has_existing_documentation(declaration_node) then
		vim.notify("XML documentation already exists", vim.log.levels.INFO)
		return
	end

	local node_type = declaration_node:type()
	local start_row = declaration_node:start()

	-- Get the current line to determine indentation
	local current_line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]
	local indent = templates.get_indent(current_line)

	local comment_lines
	local cursor_pos

	-- Generate appropriate comment based on node type
	if ts.is_method_like(node_type) then
		-- Extract method information
		local type_params = ts.extract_type_parameters(declaration_node)
		local params = ts.extract_parameters(declaration_node)
		local return_type = ts.extract_return_type(declaration_node)
		local exceptions = ts.extract_exceptions(declaration_node)

		comment_lines = templates.generate_method(indent, type_params, params, return_type, exceptions)
		cursor_pos = templates.get_summary_cursor_position(start_row, indent)
	else
		-- Simple comment for classes, properties, fields, etc.
		local type_params = ts.extract_type_parameters(declaration_node)
		comment_lines = templates.generate_simple(indent, type_params)
		cursor_pos = templates.get_summary_cursor_position(start_row, indent)
	end

	-- Insert the comment lines above the declaration
	vim.api.nvim_buf_set_lines(0, start_row, start_row, false, comment_lines)

	-- Move cursor to the summary line
	vim.api.nvim_win_set_cursor(0, { cursor_pos.line + 1, cursor_pos.col })

	-- Enter insert mode
	vim.cmd("startinsert")
end

-- Set up the keymap for this buffer
vim.keymap.set("n", "<leader>xc", insert_xml_comment, {
	buffer = true,
	desc = "Insert C# XML documentation comment",
})

vim.keymap.set("n", "<leader>sbq", function()
	local easy_dotnet = require("easy-dotnet")
	easy_dotnet.build_solution_quickfix()
end, { desc = "Build Solution Quickfix" })

vim.keymap.set("n", "<leader>bq", function()
	local easy_dotnet = require("easy-dotnet")
	easy_dotnet.build_quickfix()
end, { desc = "Build Quickfix" })

vim.keymap.set("n", "<leader>tr", function()
	local easy_dotnet = require("easy-dotnet")
	easy_dotnet.testrunner()
end, { desc = "Open Test Runner" })

vim.keymap.set("n", "<leader>rtr", function()
	local easy_dotnet = require("easy-dotnet")
	easy_dotnet.testrunner_refresh()
end, { desc = "Open Test Runner" })
