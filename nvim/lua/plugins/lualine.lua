return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "rose-pine",
        globalstatus = true,
        always_show_tabline = true,
        disabled_filetypes = { winbar = { "NvimTree", "neo-tree", "dashboard", "Outline" } },
      },
      -- draw a bar with the filename at the top of the focused file buffer window
      winbar = {
        lualine_c = {
          {
            "filename",
            path = 1,
            color = function()
              local colors = require("lualine.themes." .. vim.g.colors_name)

              return {
                fg = vim.bo.modified and colors.insert.a.fg or colors.inactive.c.fg,
                bg = vim.bo.modified and colors.insert.a.bg or colors.inactive.c.bg,
                gui = vim.bo.modified and "bold" or "NONE",
              }
            end,
          },
        },
      },
      -- draw a bar with the filename at the top of each unfocused file buffer window
      inactive_winbar = {
        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },
      },
    })
  end,
}
