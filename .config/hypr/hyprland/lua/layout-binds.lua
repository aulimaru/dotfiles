local M = {}

function M.setup(main_mod, layout)
    if layout == "hy3" then
        require("hyprland.lua.hy3-binds").setup(main_mod)
    else
        require("hyprland.lua.dwindle-binds").setup(main_mod)
    end
end

return M
