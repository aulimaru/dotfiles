local M = {}

function M.setup(main_mod)
    hl.bind(main_mod .. " + Q", hl.dsp.window.close())

    local directions = {
        H = "left",
        L = "right",
        K = "up",
        J = "down",
    }

    for key, direction in pairs(directions) do
        hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ direction = direction }))
        hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
    end

    for workspace = 1, 10 do
        local key = workspace % 10
        hl.bind(
            main_mod .. " + SHIFT + " .. key,
            hl.dsp.window.move({ workspace = workspace })
        )
    end
end

return M
