local M = {}

local theme = require("hyprland.lua.theme")
local layout_binds = require("hyprland.lua.layout-binds")

local main_mod = "SUPER"
local app_launcher = "pkill wofi || wofi -c " .. theme.wofi_config .. " -s " .. theme.wofi_theme
local clipboard = [[pkill wofi || cliprust -g wofi -t "Index\tPreview" list | wofi -I -d -Dimage_size=256 -s ]] .. theme.wofi_theme .. [[ -k /dev/null | { read -r output && cliprust decode <<< "$output" | { [ $? -eq 0 ] && wl-copy; }; }]]

function M.setup(layout)
    layout_binds.setup(main_mod, layout)

hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd("foot"))
hl.bind(main_mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("emacsclient -c"))
hl.bind(main_mod .. " + M", hl.dsp.exec_cmd("swaylock -C " .. theme.swaylock_config))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd(app_launcher))
hl.bind(main_mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(main_mod .. " + P", hl.dsp.exec_cmd(clipboard))
hl.bind(main_mod .. " + SHIFT + P", hl.dsp.exec_cmd("~/.config/hypr/scripts/monitor_profiles.sh --reconcile"))
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(main_mod .. " + T", hl.dsp.exec_cmd("hyprpicker -a"))
	hl.bind(main_mod .. " + I", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_hypridle_mode.sh"))
hl.bind(main_mod .. " + O", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipocr.sh | wl-copy"))
hl.bind(main_mod .. " + SHIFT + X", hl.dsp.exec_cmd([[hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:stash", follow = false })']]))
hl.bind(main_mod .. " + X", hl.dsp.exec_cmd("pkill wofi || ~/.config/hypr/scripts/restore-stash-window.sh"))
hl.bind("ALT + Tab", hl.dsp.focus({ last = true }))

for workspace = 1, 10 do
    local key = workspace % 10
    hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
end

hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(main_mod .. " + N", hl.dsp.exec_cmd("swaync-client --toggle-panel"))
hl.bind(main_mod .. " + SHIFT + M", hl.dsp.exec_cmd("hyprctl --instance 0 'dispatch exec swaylock'"), { locked = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind(main_mod .. " + up", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind(main_mod .. " + down", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))

hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd("mpc toggle"), { locked = true })
hl.bind(main_mod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind(main_mod .. " + SHIFT + PERIOD", hl.dsp.exec_cmd("mpc next"), { locked = true })
hl.bind(main_mod .. " + SHIFT + COMMA", hl.dsp.exec_cmd("mpc prev"), { locked = true })

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh down"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness.sh up"))

local screenshot_path = [[~/pictures/Screenshot_$(date +"%Y%m%d%H%M%S").png]]
hl.bind("Print", hl.dsp.exec_cmd([=[pkill slurp || grim -g "$(slurp -w 0 -d)" - | wl-copy -t image/png]=]))
hl.bind("ALT + Print", hl.dsp.exec_cmd([=[pkill slurp || grim -g "$(slurp -w 0 -d)" ]=] .. screenshot_path))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("pkill slurp || grim - | wl-copy -t image/png"))
hl.bind("ALT + SHIFT + Print", hl.dsp.exec_cmd("pkill slurp || grim " .. screenshot_path))
end

return M
