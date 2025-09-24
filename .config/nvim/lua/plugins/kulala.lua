return {
	"mistweaverco/kulala.nvim",
	keys = {
		{ "<leader>Rs", desc = "Send request" },
		{ "<leader>Ra", desc = "Send all requests" },
		{ "<leader>Rb", desc = "Open scratchpad" },
	},
	ft = { "http", "rest" },
	opts = {
		-- your configuration comes here
    environment_scope = "b",
		global_keymaps = true,
    kulala_keymaps = true,
		global_keymaps_prefix = "<leader>R",
		kulala_keymaps_prefix = "",
	},
  pickers = {
  snacks = {
    layout = function()
      local has_snacks, snacks_picker = pcall(require, "snacks.picker")
      return not has_snacks and {}
        or vim.tbl_deep_extend("force", snacks_picker.config.layout("telescope"), {
          reverse = true,
          layout = {
            { { win = "list" }, { height = 1, win = "input" }, box = "vertical" },
            { win = "preview", width = 0.6 },
            box = "horizontal",
            width = 0.8,
          },
        })
    end,
  },
},
}
