return {
  "rmagatti/auto-session",
  dependencies = { 'nvim-telescope/telescope.nvim'},
  config = function ()
    require("auto-session").setup({
      auto_session_suppress_dirs = {
        "~/",
        "~/Downloads",
      },
      session_lens = {
        buftypes_to_ignore = {},
        load_on_setup = true,
        theme_conf = {border = true},
        previewer = true,
      },
      auto_session_use_git_branch = true,
    })
    vim.keymap.set('n',"<Leader>ls", require("auto-session.session-lens").search_session , {})
  end
}
