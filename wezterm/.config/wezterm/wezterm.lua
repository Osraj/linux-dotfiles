local wezterm = require 'wezterm'
local theme = require('lua/rose-pine').moon
local font = require('lua/font')

-- config.enable_wayland = true

local config = {}


config.colors = theme.colors()
config.window_frame = theme.window_frame() -- needed only if using fancy tab bar
config.font = font.font
config.font_size = font.font_size
config.freetype_render_target = font.freetype_render_target
config.freetype_load_target = font.freetype_load_target
config.window_background_opacity = 0.95

return config


