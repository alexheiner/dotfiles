-- https://github.com/lewis6991/gitsigns.nvim
return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require("gitsigns")
		gitsigns.setup()
		vim.keymap.set("n", "<leader>hp", ":Gitsigns preview_hunk<CR>")
		vim.keymap.set("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
		vim.keymap.set("n", "<leader>bl", function()
			gitsigns.blame_line({ full = true })
		end)
		vim.keymap.set("n", "<leader>gq", function()
			gitsigns.setqflist({target='all'})
		end)
		vim.keymap.set("n", "<leader>gl", function()
			gitsigns.setloclist({target='all'})
		end)
		vim.keymap.set("n", "<leader>bf", ":Gitsigns blame<CR>")
	end,
}
