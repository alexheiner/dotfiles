return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "jsonls", "gopls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		opts = {
			servers = {
				tailwindcss = {},
				terraformls = {},
			},
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local lspconfig = require("lspconfig")
			-- lua
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.biome.setup({
				capabilities = capabilities,
			})

			-- typescript
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			-- tailwindcss
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})

			-- json
			lspconfig.jsonls.setup({
				capabilities = capabilities,
			})

			-- github actions
			lspconfig.gh_actions_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.kulala_ls.setup({
				capabilities = capabilities,
			})

			-- terraform
			lspconfig.terraformls.setup({
				capabilities = capabilities,
			})
			lspconfig.tflint.setup({
				capabilities = capabilities,
			})

			lspconfig.yamlls.setup({})

			lspconfig.gopls.setup({
				capabilities = capabilities,
				filetypes = { "go", "gomod" },
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
					},
				},
			})

			-- keymaps
			-- vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "gr", function()
				local builtin = require("telescope.builtin")
				builtin.lsp_references()
			end)
			vim.keymap.set("n", "gD", function()
				vim.lsp.buf.definition()
				vim.cmd(":vsplit")
			end, {})
			vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {})

			-- set virtual diagnostic text
			vim.diagnostic.config({ virtual_text = true })
		end,
	},
	{
		"seblj/roslyn.nvim",
		ft = { "cs", "razor" },
		config = function()
			local mason_registry = require("mason-registry")

			local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
			local cmd = {
				"roslyn",
				"--stdio",
				"--logLevel=Information",
				"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
				"--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
				"--razorDesignTimePath="
					.. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
				"--extension",
				vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
			}
			-- local cmd = {
			-- 	"dotnet",
			-- 	"/Users/alexheiner/.local/share/nvim/roslyn2/Microsoft.CodeAnalysis.LanguageServer.dll",
			-- 	"--logLevel=Information",
			-- 	"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
			-- 	"--stdio",
			-- }
			vim.lsp.config("roslyn", {
				cmd = cmd,
				-- handlers = require("rzls.roslyn_handlers"),
				settings = {
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
					},
				},
				-- Add other options here
			})
			vim.lsp.enable("roslyn")
		end,
		init = function()
			vim.filetype.add({
				extension = {
					razor = "razor",
					cshtml = "razor",
				},
			})
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				tailwind = true,
			},
		},
	},
}
