local keymap = vim.keymap -- for conciseness
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    opts.desc = "Show documentation"
    keymap.set("n", "K", vim.lsp.buf.hover, opts)

    opts.desc = "Show LSP definition"
    keymap.set("n", "gd", vim.lsp.buf.definition, opts)

    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

    opts.desc = "Show LSP references"
    keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

    opts.desc = "Code rename"
    keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

    opts.desc = "Show line diagnostics"
    keymap.set("n", "<leader>cd", vim.diagnostic.open_float)

    opts.desc = "Go to previous diagnostic"
    keymap.set("n", "[g", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts)

    opts.desc = "Go to next diagnostic"
    keymap.set("n", "]g", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts)
  end,
})

local severity = vim.diagnostic.severity

vim.diagnostic.config({ virtual_text = true })

vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = " ",
      [severity.WARN] = " ",
      [severity.HINT] = "󰠠 ",
      [severity.INFO] = " ",
    },
  },
})
