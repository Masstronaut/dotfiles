return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>fe",
      "<cmd>Neotree reveal<cr>",
      desc = "File: Reveal in Explorer (Neotree)",
    },
  },
  opts = {
    close_if_last_window = true,
    window = {
      position = "right",
      mappings = {
        ["p"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignore = false,
        hide_by_name = {
          ".git",
        },
      },
    },
    enable_git_status = true,
    event_handlers = {
      {
        -- Don't render line numbers in the neotree buffer
        event = "neo_tree_buffer_enter",
        handler = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.statuscolumn = ""
        end,
      },
    },
  },
}
