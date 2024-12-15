return {
	"catppuccin/nvim",
	lazy = false,
  enabled = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
			custom_highlights = function(colors)
        local light = vim.o.background == "light"
        if light then
					return {
						LineNr4 = { fg = "#3B4261" },
						LineNr3 = { fg = "#445464" },
						LineNr2 = { fg = "#5D9E97" },
						LineNr1 = { fg = "#7DAEB9" },
						LineNr0 = { fg = "#BDEEF9", style = { "bold" } },
					}
				end
				return {
					LineNr4 = { fg = colors.overlay0 },
					LineNr3 = { fg = colors.overlay1 },
					LineNr2 = { fg = colors.overlay2 },
					LineNr1 = { fg = colors.teal },
					LineNr0 = { fg = colors.blue, style = { "bold" } },
          CursorLine = { bg = colors.mantle}
				}
				--[[ rose pine colors
        return {
          LineNr4 = { fg = "#3B4261" },
          LineNr3 = { fg = "#445464" },
          LineNr2 = { fg = "#5D9E97" },
          LineNr1 = { fg = "#7DAEB9" },
          LineNr0 = { fg = "#BDEEF9", style = { "bold" } },
        }
        --]]
			end,
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
