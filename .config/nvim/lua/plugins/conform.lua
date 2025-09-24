return {
  {
    'stevearc/conform.nvim',
    opts = {},
    keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>gf",
      function()
        -- require("conform").format({ async = true })
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          typescript = { "biome", lsp_format = "first" },
          typescriptreact = { "biome", lsp_format = "first" },
          javascript = { "biome", lsp_format = "first" },
          javascriptreact = { "biome", lsp_format = "first" },
          go = { "goimports", "gofmt" },
          cs = { "csharpier", lsp_format = "first" }
        },
        formatters = {
          csharpier = {
            command = "dotnet",
            args = { "csharpier", "format", "--write-stdout" }
          }
        },
        format_on_save = {
          lsp_format = "fallback",
        }
      })
    end
  }
}
