-- Ruby LSP client setup
-- Note: This requires the ruby-lsp gem (lsp server) to be installed.
return {
  -- Utilize nvim-lspconfig for simple basic setup
  require'lspconfig'.ruby_lsp.setup{
    settings = {},
    on_attach = function()
      --Hover
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})

      -- Go to definition
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
      vim.keymap.set("n", "gv", "<cmd>vsplit | lua vim.lsp.buf.definition<CR>", {buffer=0})

      -- Code action
      vim.keymap.set({"n", "v"}, "<leader>c", vim.lsp.buf.code_action, {buffer=0})

      -- Refactors
      vim.keymap.set("n", "<leader><F2>", vim.lsp.buf.rename, {buffer=0})
    end,
  }
}
