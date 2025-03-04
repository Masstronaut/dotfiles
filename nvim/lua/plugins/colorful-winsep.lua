return {
	"nvim-zh/colorful-winsep.nvim",
	dependencies = { "rose-pine/neovim" },
	config = function()
		local rose_pine = require("rose-pine.palette")
		require("colorful-winsep").setup({
			-- [[
			-- The colors don't seem to work here and it gets overwritten as black. Not sure why.
			-- It's manually set using the `NvimSeparator` highlight group in `plugins/rose-pine.lua`.
			-- ]]
			hi = {
				bg = rose_pine.foam,
				fg = rose_pine.foam,
			},
		})
	end,
	event = { "WinLeave" },
}
