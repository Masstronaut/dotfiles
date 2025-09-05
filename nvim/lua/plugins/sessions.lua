return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { '<leader>ls', '<cmd>SessionSearch<CR>', desc = 'Session search' },
  },
  opts = {
    auto_session_suppress_dirs = {
      "~/",
      "~/Downloads",
    },
    auto_session_use_git_branch = true,
    session_lens = {
      load_on_setup = true,
      theme_conf = { border = true },
      previewer = true,
    },
  },
}
