hl.window_rule({
    name = "wechat-1",
    match = { class = "wechat" },
    float = true,
    no_blur = true,
    tag = "+alpha_1",
})

hl.window_rule({
    name = "wechat-2",
    match = {
        class = "wechat",
        title = "微信（测试版）",
    },
    tile = true,
})

hl.window_rule({
    name = "wechat-3",
    match = {
        class = "wechat",
        title = "wechat",
    },
    float = true,
    border_size = 0,
})

hl.window_rule({
    name = "librewolf-1",
    match = { class = "librewolf" },
    tag = "+alpha_1",
})

hl.window_rule({
    name = "no-opacity",
    match = { tag = "alpha_1" },
    opacity = "1.0 override 1.0 override 1.0 override",
})

hl.window_rule({
    name = "footclient-1",
    match = { class = "footclient" },
    tag = "+term",
})

hl.window_rule({
    name = "foot-1",
    match = { class = "foot" },
    tag = "+term",
})

hl.window_rule({
    name = "keepassxc-1",
    match = {
        class = "org.keepassxc.KeePassXC",
        float = true,
    },
    pin = true,
})

hl.window_rule({
    name = "hide-xwaylandvideobridge",
    match = { class = "^(xwaylandvideobridge)$" },
    opacity = "0.0 override",
    no_anim = true,
    no_initial_focus = true,
    max_size = { 1, 1 },
    no_blur = true,
    no_focus = true,
})
