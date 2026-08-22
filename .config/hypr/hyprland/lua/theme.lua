local M = {
    wallpaper = "dolomite-mountains-milky-way-4k-italy_3840x2160.jpg",
    wofi_theme = "~/.config/wofi/themes/tokyonight-night.css",
    wofi_config = "~/.config/wofi/configs/tokyonight-night",
    swaylock_config = "~/.config/swaylock/themes/tokyonight-night",
}

hl.config({
    general = {
        gaps_in = 7,
        gaps_out = 14,
        gaps_workspaces = 0,
        border_size = 3,
        col = {
            active_border = {
                colors = { "rgba(3d59a1cc)", "rgba(9d7cd8cc)" },
                angle = 45,
            },
            inactive_border = "rgba(a9b1d688)",
        },
    },

    decoration = {
        rounding = 0,
        inactive_opacity = 0.80,
        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("overshot", {
    type = "bezier",
    points = { { 0.05, 0.9 }, { 0.1, 1.05 } },
})

hl.curve("exit", {
    type = "bezier",
    points = { { 0.9, -0.2 }, { 0.95, 0.05 } },
})

hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "overshot", style = "popin 70%" })
hl.animation({ leaf = "windowsOut", enabled = false, speed = 2, bezier = "exit", style = "slide" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "default", style = "slidefade 3%" })

return M
