local function config_exists(config_file_names)
  for _, config_file_name in ipairs(config_file_names) do
    if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. config_file_name) == 1 then
      return true
    end
  end
  return false
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
local prettier_config_files = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yaml",
  ".prettierrc.yml",
  ".prettierrc.js",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  ".prettierrc.toml",
}
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local conditional_sources = {}
    if config_exists(prettier_config_files) then
      table.insert(conditional_sources, null_ls.builtins.formatting.prettierd)
    end
    if config_exists(eslint_config_files) then
      table.insert(conditional_sources, require("none-ls.diagnostics.eslint")) --[[ requires none-ls-extras.nvim ]]
    end
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.shfmt,
        -- expand the conditional_sources table
        unpack(conditional_sources),
      },
    })
  end,
}
