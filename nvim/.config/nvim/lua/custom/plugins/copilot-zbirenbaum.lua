return {
  {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
         require("copilot").setup({
          panel = {
            enabled = true,
            auto_refresh = true,
            keymap = {
              jump_prev = "<M-,>",
              jump_next = "<M-.>",
              accept = "<C-j>",
              refresh = "gr",
              open = "<M-CR>"
            },
            layout = {
              position = "bottom", -- | top | left | right
              ratio = 0.3
            },
          },
          suggestion = {
            auto_trigger = true,
            keymap = {
              accept = "<C-j>",
              next = "<M-.>",
              prev = "<M-,>",
              dismiss = "<C-c>",
            },
          },
         })
      end,
  },
}
