return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    keywords = {
      MASSTRONAUT = {
        icon = "",
        color = "info",
        alt = { "Masstronaut" },
      },
    },
  },
  keys = {
    { "<leader>xt", "<cmd>Trouble todo<cr>", desc = "Show Todos in trouble" },
  },
}
