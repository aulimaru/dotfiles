hl.config({
    input = {
        kb_layout = "us",
        kb_options = "caps:escape",
        follow_mouse = 1,
        touchpad = {
            disable_while_typing = false,
            natural_scroll = true,
            scroll_factor = 0.5,
        },
    },

    misc = {
        disable_hyprland_logo = true,
        allow_session_lock_restore = true,
    },

    debug = {
        disable_logs = false,
        suppress_errors = false,
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },

    xwayland = {
        force_zero_scaling = false,
    },
})
