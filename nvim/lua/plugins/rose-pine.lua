return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "dawn", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = false,
				extend_background_behind_borders = true,

				enable = {
					terminal = true,
					migrations = true, -- Handle deprecated options automatically
				},

				styles = {
					bold = true,
					italic = true,
					transparency = true,
				},

				groups = {
					border = "muted",
					link = "iris",
					panel = "surface",

					error = "love",
					hint = "iris",
					info = "foam",
					note = "pine",
					todo = "rose",
					warn = "gold",

					git_add = "foam",
					git_change = "rose",
					git_delete = "love",
					git_dirty = "rose",
					git_ignore = "muted",
					git_merge = "iris",
					git_rename = "pine",
					git_stage = "iris",
					git_text = "rose",
					git_untracked = "subtle",

					h1 = "iris",
					h2 = "foam",
					h3 = "rose",
					h4 = "gold",
					h5 = "pine",
					h6 = "foam",
				},

				highlight_groups = {
					LineNr4 = { fg = "#3B4261" },
					LineNr3 = { fg = "#445464" },
					LineNr2 = { fg = "pine" },
					LineNr1 = { fg = "foam" },
					CursorLine = { bg = "surface" },
					NotifyBackground = { bg = "surface" }, -- nvim-notify background
					-- this highlight group is used by colorful-winsep.nvim to set a border color on active window
					NvimSeparator = { fg = "rose" },
					--[[ this generates an error in the rose-pine highlighter fn
        LineNrCurr = { fg = "#BDEEF9", style = { "bold" } },
      ]]
					-- ActiveWindow = { bg = "base" }, -- make the active window bg opaque
				},
				before_highlight = function(group, highlight, palette)
					-- Disable all undercurls
					-- if highlight.undercurl then
					--     highlight.undercurl = false
					-- end
					--
					-- Change palette colour
					-- if highlight.fg == palette.pine then
					--     highlight.fg = palette.foam
					-- end
				end,
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
				vim.cmd("colorscheme rose-pine-main")
				vim.schedule(function()
					vim.cmd("silent Lazy reload tiny-inline-diagnostic.nvim")
				end)
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
				vim.cmd("colorscheme rose-pine-dawn")
				vim.schedule(function()
					vim.cmd("silent Lazy reload tiny-inline-diagnostic.nvim")
				end)
			end,
		},
	},
}
