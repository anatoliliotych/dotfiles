-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'OneHalfDark'

-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 50000

config.keys = {
{ key = 'k', mods = 'CMD', action = act.ClearScrollback 'ScrollbackAndViewport', },
}


-- and finally, return the configuration to wezterm
return config
