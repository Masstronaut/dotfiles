return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			automatic_installation = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")
			mason_lspconfig.setup({
				automatic_installation = true,
				handlers = {
					-- Default handler for all servers
					function(server_name)
						lspconfig[server_name].setup({
							capabilities = capabilities,
						})
					end,
					-- Map tsserver to ts_ls to prevent duplicates
					["tsserver"] = function()
						lspconfig.ts_ls.setup({
							capabilities = capabilities,
						})
					end,
				},
			})
			-- Set up the hover window to have a border
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show LSP hover info" })
			vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Code: go to Definition" })
			--      I think viewing references via telescope is nicer
			--      so this is configured in telescope.lua
			--      vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "Code: go to Reference" })
			vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Actions" })
			vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, { desc = "reName symbol (rename)" })
			vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format file" })
			-- automatically format files on write
			-- Create an autocommand group to hold the command for formatting
			local format_group = vim.api.nvim_create_augroup("AutoFormat", { clear = true })
			-- Create the autocommand that runs the LSP formatting when a buffer is written to disk
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = format_group,
				pattern = "*", -- match all files
				callback = function()
					vim.lsp.buf.format({ async = false }) -- format the file synchronously before write
				end,
			})
		end,
	},
}
