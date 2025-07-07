return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    branch = "main",
    lazy = false, -- Treesitter does not support lazy loading
    build = ":TSUpdate",
    config = function()
      -- Setup treesitter for indentation, highlighting, etc. for the languages I use
      local tsconfig = require("nvim-treesitter.configs")
      tsconfig.setup({
        ensure_installed = {
          "regex",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {    -- Add language-aware function and class text objects
            enable = true,
            lookahead = true, -- same behavior as built-in text objects
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable = true,         -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = false,   -- Enable multiwindow support.
      max_lines = 0,         -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 10, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 10, -- Maximum number of lines to show for a single context
      trim_scope = "outer",  -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor",       -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20,  -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
  },
}
