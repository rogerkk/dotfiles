return {
    -- "rogerkk/ale",
    -- branch = 'patch-1',

    "dense-analysis/ale",

    config = function()
      local g = vim.g
      local b = vim.b
      
      g.ale_ruby_rubocop_auto_correct_all = 1

      g.ale_linters = {
         ruby = {'rubocop', 'reek', 'ruby'},
         --erb =  {'erblint'},
         --javascript = {'eslint'}
      }

      g.ale_fix_on_save = 1
      g.ale_fixers = {
        ruby  = {'trim_whitespace', 'remove_trailing_lines', 'rubocop'},
        ['*'] = {'trim_whitespace', 'remove_trailing_lines'}
      }
         
      g.ale_sign_error   = '❌'
      g.ale_sign_warning = '⚠️ '
    end
}
