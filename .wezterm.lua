local wezterm = require 'wezterm'

local config = wezterm.config_builder()
local act = wezterm.action

config.color_scheme = 'OneHalfDark'

config.scrollback_lines = 50000

config.font_size = 22
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = { left = 5, right = 5, top = 5, bottom = 5 }
config.prefer_egl = true

config.keys = {
  { key = '/', mods = 'CTRL', action=act.SendString("\x1f") },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = false }, }
}

return config
