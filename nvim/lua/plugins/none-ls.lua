local function config_exists(config_file_names, path)
  -- Use the buffer's directory, fallback to cwd
  local search_dir = path and vim.fs.dirname(path) or vim.fn.getcwd()

  -- Search upward from the file's directory
  local found = vim.fs.find(config_file_names, {
    path = search_dir,
    upward = true,
    type = "file",
  })

  return #found > 0
end

local eslint_config_files = {
  ".eslintrc.js",
  ".eslintrc.json",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
}
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      debug = false,
      sources = {
        -- Conditional formatters based on config file presence
        require("none-ls.diagnostics.eslint_d").with({
          condition = function(utils)
            local bufname = utils.bufname or utils.filename or vim.api.nvim_buf_get_name(0)
            local result = config_exists(eslint_config_files, bufname)
            return result
          end,
        }),
      },
    })
  end,
}
