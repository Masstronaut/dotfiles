return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local function should_skip_treesitter(lang)
				local ok, err = pcall(vim.treesitter.query.get, lang, "highlights")
				return not ok and tostring(err):match('Invalid node type "tab"') ~= nil
			end

			-- Install parsers for common languages
			local parsers = {
				"lua",
				"vim",
				"vimdoc",
				"query",
				"regex",
				"markdown",
				"javascript",
				"typescript",
				"prisma",
				"python",
				"rust",
				"go",
				"json",
				"yaml",
				"toml",
				"bash",
				"svelte",
				"astro",
				"html",
				"css",
				"lua",
				"vim",
				"vimdoc",
			}

			require("nvim-treesitter").install(parsers)

			-- Enable treesitter features for specific filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = parsers,
				callback = function(ev)
					local buf = ev.buf
					local lang = ev.match

					-- Schedule after buffer load to prevent other plugins from overriding settings
					vim.schedule(function()
						if not vim.api.nvim_buf_is_valid(buf) then
							return
						end
						if vim.bo[buf].filetype ~= lang then
							return
						end
						if should_skip_treesitter(lang) then
							return
						end

						-- Bind Treesitter to the original buffer/filetype pair so
						-- later filetype changes on scratch/plugin buffers do not
						-- accidentally start a parser for the wrong language.
						local ok = pcall(vim.treesitter.start, buf, lang)
						if not ok then
							return
						end

						-- Enable treesitter-based indentation
						vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

						for _, win in ipairs(vim.fn.win_findbuf(buf)) do
							vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local", win = win })
							vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { scope = "local", win = win })
							vim.api.nvim_set_option_value("foldenable", true, { scope = "local", win = win })
							vim.api.nvim_set_option_value("foldlevel", 99, { scope = "local", win = win })
						end
					end)
				end,
			})

			-- Set up basic textobjects using vim.treesitter
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function()
					local buf = vim.api.nvim_get_current_buf()

					-- Function textobjects
					vim.keymap.set({ "x", "o" }, "af", function()
						vim.treesitter.query.omnifunc(0, "@function.outer")
					end, { buffer = buf, desc = "Select around function" })

					vim.keymap.set({ "x", "o" }, "if", function()
						vim.treesitter.query.omnifunc(0, "@function.inner")
					end, { buffer = buf, desc = "Select inside function" })

					-- Class textobjects
					vim.keymap.set({ "x", "o" }, "ac", function()
						vim.treesitter.query.omnifunc(0, "@class.outer")
					end, { buffer = buf, desc = "Select around class" })

					vim.keymap.set({ "x", "o" }, "ic", function()
						vim.treesitter.query.omnifunc(0, "@class.inner")
					end, { buffer = buf, desc = "Select inside class" })
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		branch = "master",
		opts = {
			enable = true,
			multiwindow = false,
			max_lines = 0,
			min_window_height = 10,
			line_numbers = true,
			multiline_threshold = 10,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
			on_attach = nil,
		},
	},
}
