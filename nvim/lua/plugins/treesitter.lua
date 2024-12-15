return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	build = ":TSUpdate",
	config = function()
		-- Setup treesitter for indentation, highlighting, etc. for the languages I use
		local tsconfig = require("nvim-treesitter.configs")
		tsconfig.setup({
			ensure_installed = {
				"regex",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			textobjects = {
				select = { -- Add language-aware function and class text objects
					enable = true,
					lookahead = true, -- same behavior as built-in text objects
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
			},
		})
	end,
}
