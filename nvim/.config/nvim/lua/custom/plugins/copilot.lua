-- [[ Configure Copilot ]]
--
vim.keymap.set('n', '<leader>c', ':Copilot<CR>', { desc= '[C]opilot' })
vim.keymap.set('i', '<M-.>',     '<Plug>(copilot-next)', { desc = 'Copilot next suggestion'})
vim.keymap.set('i', '<M-,>',     '<Plug>(copilot-previous)', { desc = 'Copilot previous suggestion'})

-- Remap tab key to CTRL+J
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

return {
    {
        "github/copilot.vim",
    },
}
