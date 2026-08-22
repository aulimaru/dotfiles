local M = {}

function M.setup()
    -- External monitor topology is reconciled dynamically by monitor_profiles.sh.
    -- Keep only a safe fallback and internal-panel baseline here for config reloads.
    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = "auto",
    })

    hl.monitor({
        output = "eDP-1",
        mode = "2880x1800@120.00",
        position = "auto",
        scale = 1.5,
        bitdepth = 10,
    })

    hl.workspace_rule({
        workspace = "2",
        monitor = "eDP-1",
    })
end

return M
