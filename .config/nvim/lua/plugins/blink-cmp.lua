return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"nvim-tree/nvim-web-devicons",
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		"onsails/lspkind.nvim",
	},
	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = "enter" },

		appearance = {
			nerd_font_variant = "mono",
		},

		signature = { enabled = true },

		completion = {
			documentation = { auto_show = false },
			menu = {},
		},

		sources = {
			default = { "lsp", "lazydev", "path", "buffer", "snippets" },
			-- default = { "lsp", "path", "buffer", "snippets" },
			-- default = { "avante", "lsp", "path", "easy-dotnet", "snippets", "buffer" },
			per_filetype = {
				sql = { "snippets", "dadbod", "buffer" },
			},
			providers = {
				-- ["easy-dotnet"] = {
				-- 	name = "easy-dotnet",
				-- 	enabled = true,
				-- 	module = "easy-dotnet.completion.blink",
				-- 	score_offset = 10000,
				-- 	async = true,
				-- },
				dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
			},
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
