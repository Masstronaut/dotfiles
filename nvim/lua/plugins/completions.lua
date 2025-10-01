return {
  {
    "hrsh7th/cmp-nvim-lsp",
  },
  {
    -- run `:Copilot setup` after install to set it up
    "github/copilot.vim",
    config = function()
      -- Disable default Tab mapping
      vim.g.copilot_no_tab_map = true
      -- Map Ctrl+y to accept Copilot suggestion
      vim.keymap.set("i", "<C-y>", 'copilot#Accept("")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      })
    end,
  },
  {
    -- expand snippets
    "L3MON4D3/LuaSnip",
    dependencies = {
      -- using this to expand them for the completions engine
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  -- Add completions for the command line (e.g. /, :, ?)
  { "hrsh7th/cmp-cmdline" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim" }, -- tailwind color swatches
    },
    config = function()
      -- setup the completions plugin
      local cmp = require("cmp")
      -- vscode's default snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
      -- Setup the insert mode completions
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = { name = "custom", selection_order = "near_cursor" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },             -- For luasnip users.
          { name = "lazydev", group_index = 0 }, -- For lazydev when editing nvim lua config files
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = require("tailwindcss-colorizer-cmp").formatter,
          fields = { "kind", "abbr", "menu" },
          expandable_indicator = true, -- draws a scroll bar
        },
      })
    end,
  },
}
