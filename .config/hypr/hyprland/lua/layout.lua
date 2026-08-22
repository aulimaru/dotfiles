local M = {}

function M.select()
    if hl.plugin.hy3 ~= nil then
        hl.config({
            general = {
                layout = "hy3",
            },
        })
        require("hyprland.lua.hy3").configure()
        return "hy3"
    end

    hl.config({
        general = {
            layout = "dwindle",
        },
    })
    return "dwindle"
end

return M
