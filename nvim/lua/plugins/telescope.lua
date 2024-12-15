return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Find by grepping" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fF", function()
        builtin.find_files({ cwd = "/" })
      end, { desc = "Find Files (/)" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files (cwd)" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>en", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "Edit Neovim config" })

      -- code actions
      vim.keymap.set("n", "<leader>cr", builtin.lsp_references, { desc = "Code: show References" })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("noice")
    end,
  },
}
