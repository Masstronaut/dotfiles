return {
	{
		"tpope/vim-fugitive",
		lazy = true,
		keys = {
			{ "<leader>gB", "<cmd>G blame<CR>", desc = "Git blame (neogit)" },
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed.
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
		lazy = true,
		keys = {
			{ "<leader>gs", "<cmd>Neogit kind=floating<CR>", desc = "Git status (neogit)" },
			{ "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Git commit (neogit)" },
			{ "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git pull (neogit)" },
			{ "<leader>gP", "<cmd>Neogit push<CR>", desc = "Git push (neogit)" },
			{ "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git Branches (telescope)" },
			{ "<leader>gd", "<cmd>Neogit diff<CR>", desc = "Git diff (neogit)" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		lazy = false, -- disable lazy loading
		config = function()
			local gs = require("gitsigns")
			gs.setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
				},
				current_line_blame = true,
			})
		end,
		keys = {
			{ "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Git Preview hunk" },
			-- { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Git blame current line" },
			-- { "<leader>gd", "<cmd>Gitsigns diffthis<cr>",                  desc = "Git Diff" },
			{ "[c", "<cmd>Gitsigns prev_hunk<CR>", desc = "Git prev hunk" },
			{ "]c", "<cmd>Gitsigns next_hunk<CR>", desc = "Git next hunk" },
			{ "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Git preview hunk" },
			{ "<leader>glb", "<cmd>Gitsigns blame_line<CR>", desc = "Git blame line" },
			{ "<leader>glh", "<cmd>Gitsigns toggle_linehl<CR>", desc = "Git toggle line highlight" },
		},
	},
}
