local wezterm = require 'wezterm'

local config = wezterm.config_builder()
local act = wezterm.action

config.color_scheme = 'OneHalfDark'

config.scrollback_lines = 50000

config.font_size = 22

config.keys = {
{ key = 'k', mods = 'CMD', action = act.ClearScrollback 'ScrollbackAndViewport', },
{ key = '/', mods = 'CTRL', action=wezterm.action.SendString("\x1f") },
}

return config
