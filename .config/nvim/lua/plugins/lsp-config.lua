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
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {},
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

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
			})

			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
			})

			vim.lsp.config("jsonls", {
				capabilities = capabilities,
			})

			vim.lsp.config("gopls", {
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

			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
			})

			vim.lsp.config("biome", {
				capabilities = capabilities,
			})

			vim.lsp.config("terraformls", {
				capabilities = capabilities,
			})

			vim.lsp.config("tflint", {
				capabilities = capabilities,
			})

			vim.lsp.config("kulala_ls", {
				capabilities = capabilities,
			})

			vim.lsp.config("gh_actions_ls", {
				capabilities = capabilities,
			})

			vim.lsp.config("kulala_ls", {
				capabilities = capabilities,
			})

			-- lua
			-- lspconfig.lua_ls.setup({
			-- 	capabilities = capabilities,
			-- })
			--
			-- lspconfig.biome.setup({
			-- 	capabilities = capabilities,
			-- })
			--
			-- -- typescript
			-- lspconfig.ts_ls.setup({
			-- 	capabilities = capabilities,
			-- })
			--
			-- -- tailwindcss
			-- lspconfig.tailwindcss.setup({
			-- 	capabilities = capabilities,
			-- })
			--
			-- -- json
			-- lspconfig.jsonls.setup({
			-- 	capabilities = capabilities,
			-- })
			--
			-- -- github actions
			-- lspconfig.gh_actions_ls.setup({
			-- 	capabilities = capabilities,
			-- })
			--
			-- lspconfig.kulala_ls.setup({
			-- 	capabilities = capabilities,
			-- })
			--
			-- -- terraform
			-- lspconfig.terraformls.setup({
			-- 	capabilities = capabilities,
			-- })
			-- lspconfig.tflint.setup({
			-- 	capabilities = capabilities,
			-- })
			--
			-- lspconfig.yamlls.setup({})
			--
			-- lspconfig.gopls.setup({
			-- 	capabilities = capabilities,
			-- 	filetypes = { "go", "gomod" },
			-- 	settings = {
			-- 		gopls = {
			-- 			analyses = {
			-- 				unusedparams = true,
			-- 			},
			-- 		},
			-- 	},
			-- })

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
