-- [[ Configure nvim-test ]]
vim.keymap.set('n', '<leader>t', ':TestNearest<CR>', { desc='Run nearest [t]est' })
vim.keymap.set('n', '<leader>T', ':TestFile<CR>', { desc='Run all [T]ests in file' })
vim.keymap.set('n', '<leader>a', ':TestSuite<CR>', { desc='Run [a]ll tests' })
vim.keymap.set('n', '<leader>l', ':TestLast<CR>', { desc='Run [l]ast test' })
vim.keymap.set('n', '<leader>g', ':TestVisit<CR>', {})

vim.g['test#strategy'] ='neovim'
vim.g['test#neovim#start_normal'] = 1 -- Start in normal mode
vim.g['test#ruby#rspec#executable'] ='docker exec -t -eRAILS_ENV=test legelisten-web-1 bundle exec rspec'

return {
  'vim-test/vim-test'
}
