local M = {}

function M.setup(main_mod)
    local hy3 = hl.plugin.hy3
    if hy3 == nil then
        return
    end

    hl.bind(main_mod .. " + Q", hy3.kill_active())
    hl.bind(main_mod .. " + SHIFT + Q", hl.dsp.exec_cmd("kill -9 $(hyprctl activewindow -j | jq '.pid')"))

    hl.bind(main_mod .. " + G", hy3.change_group("toggletab"))
    hl.bind(main_mod .. " + A", hy3.change_focus("top"))
    hl.bind(main_mod .. " + D", hy3.change_focus("bottom"))
    hl.bind(main_mod .. " + W", hy3.change_focus("raise"))
    hl.bind(main_mod .. " + S", hy3.change_focus("lower"))

    hl.bind(main_mod .. " + code:34", hy3.focus_tab({ direction = "l" }))
    hl.bind(main_mod .. " + code:35", hy3.focus_tab({ direction = "r" }))

    local directions = {
        H = "l",
        L = "r",
        K = "u",
        J = "d",
    }

    for key, direction in pairs(directions) do
        hl.bind(main_mod .. " + " .. key, hy3.move_focus(direction, { visible = true }))
        hl.bind(main_mod .. " + SHIFT + " .. key, hy3.move_window(direction))
        hl.bind(main_mod .. " + CTRL + SHIFT + " .. key, hy3.move_window(direction, { visible = true }))
    end

    for workspace = 1, 10 do
        local key = workspace % 10
        hl.bind(main_mod .. " + SHIFT + " .. key, hy3.move_to_workspace(tostring(workspace)))
    end
end

return M
