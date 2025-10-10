return {
  "stevearc/conform.nvim",
  config = function()
    local js_formatters = { "prettierd", "prettier", stop_after_first = true, lsp_fallback = true }
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = js_formatters,
        typescript = js_formatters,
        json = js_formatters,
        html = js_formatters,
        css = js_formatters,
        scss = js_formatters,
        markdown = js_formatters,
        yaml = js_formatters,
        bash = { "shfmt" },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 500,
      },
    })
    vim.keymap.set("n", "<leader>cf", function()
      conform.format({
        lsp_format = "fallback",
      })
    end)
  end,
}
