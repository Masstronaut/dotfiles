---@param title string: the title of the window to focus
local focus_window = function(title)
  local all_win_ids = vim.api.nvim_list_wins()
  local edgy = require("edgy")           -- owns the window titles
  for _, win_id in ipairs(all_win_ids) do -- loop over all windows
    local win = edgy.get_win(win_id)     -- edgy window object has titles
    if win and win.view.get_title() == title then
      vim.api.nvim_set_current_win(win_id)
    end
  end
end
return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.laststatus = 3     -- show a single status line at the bottom
    vim.opt.splitkeep = "screen" -- prevents jumping when open/close sidebars
  end,
  keys = {
    { -- toggle the right sidebar tree nav
      "<Leader>pl",
      function()
        require("lazy").load({ plugins = { "neo-tree.nvim" } })
        require("edgy").toggle("right")

        -- uses vim.schedule to wait until opening neotree edgebar is done
        vim.schedule(function()
          focus_window("Files")
        end)
      end,
      desc = "Panes: Right (toggle)",
    },
    { -- focus the file tree pane
      "<leader>pf",
      function()
        require("lazy").load({ plugins = { "neo-tree.nvim" } })
        require("edgy").open("right")
        vim.cmd("Neotree reveal filesystem")
        vim.schedule(function()
          focus_window("Files")
        end)
      end,
      desc = "Panes: Filesystem (focus)",
    },
    {
      "<leader>pb",
      function()
        require("lazy").load({ plugins = { "neo-tree.nvim" } })
        require("edgy").open("right")
        vim.cmd("Neotree reveal buffers")
        -- uses vim.schedule to wait until opening neotree edgebar is done
        vim.schedule(function()
          focus_window("Buffers")
        end)
      end,
      desc = "Panes: Buffers (focus)",
    },
    {
      "<leader>pg",
      function()
        require("lazy").load({ plugins = { "neo-tree.nvim" } })
        require("edgy").open("right")
        vim.cmd("Neotree reveal git_status")
        -- uses vim.schedule to wait until opening neotree edgebar is done
        vim.schedule(function()
          focus_window("Git")
        end)
      end,
      desc = "Panes: Git (focus)",
    },
    { -- Toggle the bottom bar
      "<leader>pj",
      function()
        require("lazy").load({ plugins = { "trouble.nvim" } })
        require("edgy").toggle("bottom")
        vim.schedule(function()
          focus_window("Trouble")
        end)
      end,
      desc = "Panes: Bottom (toggle)",
    },
  },
  opts = {
    -- right sidebar tree nav (files, buffers, git, etc.)
    right = {
      -- Neo-tree filesystem always takes half the screen height
      {
        title = "Files",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "filesystem"
        end,
        open = "Neotree filesystem",
        size = { height = 0.5 },
        pinned = true,
      },
      {
        title = "Buffers",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "buffers"
        end,
        pinned = true,
        open = "Neotree position=top buffers",
        size = { height = 0.25 },
      },
      {
        title = "Git",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "git_status"
        end,
        pinned = true,
        open = "Neotree position=left git_status",
        size = { height = 0.25 },
      },
      -- any other neo-tree windows
      "neo-tree",
    },
    bottom = {
      "Trouble",
      {
        title = "Trouble",
        ft = "trouble",
        size = { height = 12 },
      },
      { ft = "qf", title = "QuickFix" },
      {
        ft = "help",
        size = { height = 20 },
        -- only show help buffers
        filter = function(buf)
          return vim.bo[buf].buftype == "help"
        end,
      },
    },
  },
}
