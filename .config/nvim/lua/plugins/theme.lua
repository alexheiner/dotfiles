-- return {
-- 	"AlexvZyl/nordic.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		local nordic = require("nordic")
-- 		nordic.setup({
-- 			after_palette = function(palette)
-- 				local U = require("nordic.utils")
-- 				palette.bg_visual = U.blend(palette.magenta.dim, palette.bg, 0.30)
-- 			end,
-- 			italic_comments = false,
-- 		})
--
-- 		nordic.load()
-- 	end,
-- }
-- return {
--   {
--     "catppuccin/nvim",
--     name = "catppuccin",
--     priority = 1000,
--     config = function()
--       require("catppuccin").setup({
--         color_overrides = {
--           mocha = {
--             base = "#000000",
--             mantle = "#000000",
--             crust = "#000000",
--           },
--         },
--       })
--       vim.cmd.colorscheme("catppuccin")
--     end
--   }
-- }
-- return {
-- 	"projekt0n/github-nvim-theme",
-- 	name = "github-theme",
-- 	lazy = false, -- make sure we load this during startup if it is your main colorscheme
-- 	priority = 1000, -- make sure to load this before all the other start plugins
-- 	config = function()
-- 		require("github-theme").setup({})
--
-- 		vim.cmd("colorscheme github_dark_default")
-- 	end,
-- }
return {
	"bluz71/vim-moonfly-colors",
	name = "moonfly",
	lazy = false,
	priority = 1000,
  config = function ()
 		vim.cmd("colorscheme moonfly")
  end
}
