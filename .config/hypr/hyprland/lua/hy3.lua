local M = {}

function M.configure()
    if hl.plugin.hy3 == nil then
        return
    end

    hl.config({
        plugin = {
            hy3 = {
                no_gaps_when_only = 0,
                node_collapse_policy = 2,
                group_inset = 10,
                tab_first_window = false,
                tabs = {
                    height = 16,
                    padding = 4,
                    from_top = false,
                    radius = 1,
                    border_width = 2,
                    render_text = true,
                    text_center = true,
                    text_font = "Sans",
                    text_height = 8,
                    text_padding = 3,
                    colors = {
                        active = "rgba(7aa2f740)",
                        active_border = "rgba(7aa2f7ee)",
                        active_text = "rgba(ffffffee)",
                        focused = "rgba(60606040)",
                        focused_border = "rgba(808080ee)",
                        focused_text = "rgba(ffffffee)",
                        inactive = "rgba(30303020)",
                        inactive_border = "rgba(606060aa)",
                        inactive_text = "rgba(ffffffee)",
                        urgent = "rgba(ff223340)",
                        urgent_border = "rgba(ff2233ee)",
                        urgent_text = "rgba(ffffffee)",
                        locked = "rgba(90903340)",
                        locked_border = "rgba(909033ee)",
                        locked_text = "rgba(ffffffee)",
                    },
                    blur = true,
                    opacity = 1.0,
                },
                autotile = {
                    enable = false,
                    ephemeral_groups = true,
                    trigger_width = 0,
                    trigger_height = 0,
                    workspaces = "all",
                },
            },
        },
    })
end

return M
