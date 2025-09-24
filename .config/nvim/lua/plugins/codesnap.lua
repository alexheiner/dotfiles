-- https://github.com/mistricky/codesnap.nvim
return {
	{
		"mistricky/codesnap.nvim",
		build = "make",
		keys = {
			{
				"<leader>cx",
				"<cmd>CodeSnap<cr>",
				mode = "x",
				desc = "Save selected code snapshot into clipboard",
			},
		},
		config = function()
			require("codesnap").setup({
				watermark = "",
			})
		end,
	},
}
