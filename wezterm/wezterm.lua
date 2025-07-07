local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.font = wezterm.font("Hack Nerd Font")
config.font_size = 14

-- Setup the rose pine color scheme
local function color_scheme()
  local appearance = wezterm.gui.get_appearance()
  if appearance:find("Dark") then
    config.window_background_opacity = 0.95
    return wezterm.plugin.require("https://github.com/neapsix/wezterm").main
  else
    config.window_background_opacity = 0.95
    return wezterm.plugin.require("https://github.com/neapsix/wezterm").dawn
  end
end
config.colors = color_scheme().colors()
config.colors.tab_bar.background = wezterm.color.parse(config.colors.tab_bar.background)

-- Window configuration
config.macos_window_background_blur = 12

config.window_close_confirmation = "AlwaysPrompt"
config.default_workspace = "home"
-- top bar / decoration config (hide it)
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.status_update_interval = 1000
wezterm.on("update-right-status", function(window, pane)
  local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")
  --@param path string
  local basepath = function(path)
    return path:gsub(os.getenv("HOME"), "~")
  end

  local cwd = basepath(pane:get_current_working_dir().path)
  local cmd = pane:get_foreground_process_name():gsub(".*[/\\]", "")
  -- Make it italic and underlined
  window:set_right_status(wezterm.format({
    { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
    { Text = "  " },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
    { Text = "  " },
    -- { Text = date }, -- uncomment to debug if rendering is working
  }))
end)
wezterm.on("update-right-status", function(window, pane)
  --@param path string
end)

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

return config
