vim.g.mapleader = " "

-- Tab open/close keybinds
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { noremap = true, silent = true, desc = "New tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { noremap = true, silent = true, desc = "Close tab" })
vim.keymap.set("n", "<leader>tt", "<cmd>tabnext<CR>", { noremap = true, silent = true, desc = "Next tab" })
vim.keymap.set("n", "<leader>tT", "<cmd>tabNext<CR>", { noremap = true, silent = true, desc = "Previous tab" })

-- Pane management keybinds that are a little easier to use.
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<CR>", { noremap = true, silent = true, desc = "Focus left pane" })
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<CR>", { noremap = true, silent = true, desc = "Focus lower pane" })
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<CR>", { noremap = true, silent = true, desc = "Focus upper pane" })
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<CR>", { noremap = true, silent = true, desc = "Focus right pane" })
--[[ can't differentiate between C-H and C-h, so trying without pane movements for a bit. They don't play well with edgy anyway.
vim.keymap.set("n", "<C-H>", "<cmd>wincmd H<CR>", { noremap = true, silent = true, desc = "Move pane left" })
vim.keymap.set("n", "<C-J>", "<cmd>wincmd J<CR>", { noremap = true, silent = true, desc = "Move pane down" })
vim.keymap.set("n", "<C-K>", "<cmd>wincmd K<CR>", { noremap = true, silent = true, desc = "Move pane up" })
vim.keymap.set("n", "<C-L>", "<cmd>wincmd L<CR>", { noremap = true, silent = true, desc = "Move pane right" })
--]]

-- gets the current [count] for a motion. If the count is 0 (not set) it will default to the minimum provided value.
--@param min number
local min_count = function(min)
	local count = vim.v.count
	if count == 0 then
		count = min
	end
	return count
end

-- Set up pane resizing keybinds
vim.keymap.set("n", "<leader>w+", function()
	local count = min_count(2)
	vim.cmd("resize +" .. count .. "<cr>")
end, { noremap = true, silent = true, desc = "Increase pane height" })
vim.keymap.set("n", "<leader>w-", function()
	local count = min_count(2)
	vim.cmd("resize -" .. count .. "<cr>")
end, { noremap = true, silent = true, desc = "Decrease pane height" })
vim.keymap.set("n", "<leader>w<", function()
	local count = min_count(2)
	vim.cmd("vertical resize +" .. count .. "<cr>")
end, { noremap = true, silent = true, desc = "Decrease pane width" })
vim.keymap.set("n", "<leader>w>", function()
	local count = min_count(2)
	vim.cmd("vertical resize -" .. count .. "<cr>")
end, { noremap = true, silent = true, desc = "Increase pane width" })

-- move lines up and down in insert and normal mode
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<cmd>m .+1<CR>", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<cmd>m .-2<CR>", { noremap = true, silent = true, desc = "Move line up" })

-- source the current file (reload it) in neovim. Useful when updating nvim configs
vim.keymap.set(
	"n",
	"<leader><leader>x",
	"<cmd>source %<CR>",
	{ noremap = true, silent = true, desc = "Source current file" }
)

-- highlight text when yanking
--   try it with yap in normal mode to get an idea
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight text when yanking",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })
-- open a small terminal on the bottom of the screen with <leader>st
vim.keymap.set("n", "<leader>st", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 15)
end)

-- write a file without running hooks (ie formatter)
-- useful for codeblocks that get autoformatted in markdown
vim.keymap.set(
	"n",
	"<leader>fw",
	"<cmd>noautocmd w<CR>",
	{ noremap = true, silent = true, desc = "File - Write without formatting" }
)
