return {
	"rachartier/tiny-inline-diagnostic.nvim",

	event = "VeryLazy", -- Or `LspAttach`
	priority = 1000, -- needs to be loaded in first
	dependencies = { "rose-pine/neovim" },
	config = function()
		local rose_pine = require("rose-pine.palette")
		require("tiny-inline-diagnostic").setup({
			preset = "powerline",
			background = string.upper(rose_pine.base),
			mixing_color = rose_pine.base,
			--[[ set colors
			hi = {
				error = rose_pine.rose,
			},
      --]]
			options = {
				show_source = {
					enabled = true,
				},
				multilines = {
					enabled = true,
				},
				show_all_diags_on_cursorline = true,
				-- Add messages to diagnostics when multiline diagnostics are enabled
				-- If set to false, only signs will be displayed
				add_messages = true,

				-- custom formatter for diagnostic messages.
				format = function(diagnostic)
					return string.format("%s\n(%s)", diagnostic.message, diagnostic.source)
				end,
			},
		})
		vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
	end,
}
