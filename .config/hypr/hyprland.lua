require("hyprland.lua.general")
local monitors = require("hyprland.lua.monitors")
require("hyprland.lua.rules")
require("hyprland.lua.environment")

local theme = require("hyprland.lua.theme")
local layout = require("hyprland.lua.layout").select()
local binds = require("hyprland.lua.binds")
local autostart = require("hyprland.lua.autostart")

monitors.setup()
binds.setup(layout)
autostart.setup(theme)
