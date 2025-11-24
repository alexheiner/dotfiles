return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			local patterns_ignore = {
				"node_modules",
				".git",
				"obj",
				"bin",
				".next",
			}
			require("telescope").setup({
				defaults = {
					mappings = {
						n = {
							["dd"] = actions.delete_buffer,
						},
					},
				},
				pickers = {
					live_grep = {
						file_ignore_patterns = patterns_ignore,
					},
					find_files = {
						file_ignore_patterns = patterns_ignore,
					},
				},
				file_ignore_patterns = patterns_ignore,
			})
			-- vim.keymap.set("n", "<leader>ff", function()
			-- 	builtin.find_files({
			-- 		hidden = true,
			-- 	})
			-- end, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Telescope git status" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
