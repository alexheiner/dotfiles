return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	enabled = true,
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	init = function()
		vim.g.neotree = {
			auto_open = false,
		}
	end,
	config = function()
		require("neo-tree").setup({
			opts = {
				filesystem = {
					filtered_items = {
						visible = true,
					},
				},
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
					if node.type == "file" or node.type == "terminal" then
						local success, web_devicons = pcall(require, "nvim-web-devicons")
						local name = node.type == "terminal" and "terminal" or node.name
						if success then
							local devicon, hl = web_devicons.get_icon(name)
							icon.text = devicon or icon.text
							icon.highlight = hl or icon.highlight
						end
					end
				end,
				-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
				-- then these will never be used.
				default = "*",
				highlight = "NeoTreeFileIcon",
			},
		})
		vim.keymap.set("n", "<M-c>", function()
			require("neo-tree.command").execute({
				action = "close",
			})
		end, {})
	end,
}
