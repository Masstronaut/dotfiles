return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		spec = {
			{
				-- press <leader>b to show a list of all buffers
				"<leader>b",
				group = "buffers",
				expand = function()
					return require("which-key.extras").expand.buf()
				end,
			},
			{ -- expands into a list of commands to delete specific buffers
				"<leader>bd",
				group = "delete buffer",
				expand = function()
					-- modified from https://github.com/folke/which-key.nvim/blob/6c1584eb76b55629702716995cca4ae2798a9cca/lua/which-key/extras.lua#L31-L46
					-- to delete buffers instead of focusing hem
					local wkextras = require("which-key.extras") -- for helper fns
					local ret = {} ---@type wk.Spec[]
					local buffers = vim.tbl_filter(function(buf) -- filter out all
						return vim.bo[buf].buflisted -- unlisted buffers
					end, vim.api.nvim_list_bufs()) -- from the list

					for _, buf in ipairs(buffers) do
						local name = wkextras.bufname(buf)
						ret[#ret + 1] = {
							"",
							function()
								vim.api.nvim_buf_delete(buf, {}) -- delete the buffer
							end,
							desc = name, -- set description to filename
							icon = { cat = "file", name = name }, -- set icon based on filetype
						}
					end
					return wkextras.add_keys(ret)
				end,
			},
			{
				"<leader>bda",
				function()
					local buffers = vim.api.nvim_list_bufs()
					for _, buf in ipairs(buffers) do
						if vim.api.nvim_get_current_buf() ~= buf then
							vim.api.nvim_buf_delete(buf, {})
						end
					end
				end,
				desc = "Buffers: Delete All (others)",
			},
			{
				-- pane management hotkeys defined in edgy.lua
				"<leader>p",
				group = "Panes",
			},
			{
				-- git hotkeys defined in git.lua
				"<leader>g",
				group = "Git",
			},
			{
				"<leader>gh",
				group = "Git Hunk",
			},
			{
				"<leader>gl",
				group = "Git Line",
			},
			{
				"<leader>d",
				desc = "Debug",
			},
			{
				"<leader>c",
				group = "Code",
			},
			{
				"<leader>f",
				group = "Find/Files",
			},
			{
				"<leader>t",
				group = "Tabs",
			},
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
