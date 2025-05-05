return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local rose_pine = require("rose-pine.palette")
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
                fg = vim.bo.modified and rose_pine.love or rose_pine.text,
                bg = vim.bo.modified and rose_pine.rose or rose_pine.highlight_high,
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
