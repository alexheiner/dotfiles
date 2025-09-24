return {
	{
		enabled = true,
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			vim.opt.termguicolors = true
			require("bufferline").setup()
			vim.keymap.set("n", "<M-.>", "<Cmd>BufferLineCycleNext<CR>", {})
      vim.keymap.set("n", "<M-,>", "<Cmd>BufferLineCyclePrev<CR>", {})

      -- closing
			vim.keymap.set("n", "<M-r>", "<Cmd>BufferLineCloseRight<CR>", {})
      vim.keymap.set("n", "<M-l>", "<Cmd>BufferLineCloseLeft<CR>", {})
      vim.keymap.set("n", "<M-o>", "<Cmd>BufferLineCloseOthers<CR>", {})

      vim.keymap.set("n", "<M-p>", "<Cmd>BufferLineTogglePin<CR>", {})

		end,
	},
}
