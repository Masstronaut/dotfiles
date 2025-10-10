-- Basic vim editor config options
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.o.swapfile = false -- Disable swap files
vim.wo.relativenumber = true -- Enable relative line numbers
vim.wo.number = true -- Enable line numbers
vim.opt.cursorline = true -- Highlight the current line
vim.o.termguicolors = true -- Enable 24-bit RGB color
vim.o.smartindent = true -- Auto-indent new lines
vim.o.conceallevel = 2 -- Hide concealable text
vim.opt.scrolloff = 6 -- Keep 6 lines above/below cursor
vim.o.splitbelow = true -- Split windows below current window
vim.o.splitright = true -- Split windows right of the current window
vim.o.winborder = "rounded" -- Set window border style to rounded for floating windows

-- manually re-write the status line values so that:
-- 1. the current line number is inline with the relative line numbers
-- 2. The lines are suffixed with a pipe that can be colored.
vim.o.statuscolumn = '%s%=%#LineNr4#%{(v:relnum >= 4)?v:relnum." │ ":""}'
	.. '%#LineNr3#%{(v:relnum == 3)?v:relnum." │ ":""}'
	.. '%#LineNr2#%{(v:relnum == 2)?v:relnum." │ ":""}'
	.. '%#LineNr1#%{(v:relnum == 1)?v:relnum." │ ":""}'
	.. '%#LineNrCurr#%{(v:relnum == 0)?v:lnum." ┃ ":""}'

-- window resize commands

-- Toggle between hybrid & absolute line numbers
-- This first one disables relative line numbers when:
-- In insert mode
-- The window/pane is not focused
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = false
	end,
})
-- In normal mode, enable relative line numbers for easier navigation
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = true
	end,
})

-- When opening a terminal window, disable line numbers
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

require("vim-keybinds")
