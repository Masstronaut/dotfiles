return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Install parsers for common languages
      local parsers = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "regex",
        "markdown",
        "javascript",
        "typescript",
        "python",
        "rust",
        "go",
        "json",
        "yaml",
        "toml",
        "bash",
        "svelte",
        "astro",
        "html",
        "css",
        "lua",
        "vim",
        "vimdoc",
      }

      require'nvim-treesitter'.install(parsers)

      -- Enable treesitter features for specific filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          -- Schedule after buffer load to prevent other plugins from overriding settings
          vim.schedule(function()
            -- Enable treesitter highlighting
            vim.treesitter.start()
            -- Enable treesitter folding
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldenable = true
            vim.wo.foldlevel = 99
            -- Enable treesitter-based indentation
            vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
          end)
        end,
      })

      -- Set up basic textobjects using vim.treesitter
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          local buf = vim.api.nvim_get_current_buf()

          -- Function textobjects
          vim.keymap.set({ "x", "o" }, "af", function()
            vim.treesitter.query.omnifunc(0, "@function.outer")
          end, { buffer = buf, desc = "Select around function" })

          vim.keymap.set({ "x", "o" }, "if", function()
            vim.treesitter.query.omnifunc(0, "@function.inner")
          end, { buffer = buf, desc = "Select inside function" })

          -- Class textobjects
          vim.keymap.set({ "x", "o" }, "ac", function()
            vim.treesitter.query.omnifunc(0, "@class.outer")
          end, { buffer = buf, desc = "Select around class" })

          vim.keymap.set({ "x", "o" }, "ic", function()
            vim.treesitter.query.omnifunc(0, "@class.inner")
          end, { buffer = buf, desc = "Select inside class" })
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    branch = "main",
    opts = {
      enable = true,
      multiwindow = false,
      max_lines = 0,
      min_window_height = 10,
      line_numbers = true,
      multiline_threshold = 10,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
      on_attach = nil,
    },
  },
}
