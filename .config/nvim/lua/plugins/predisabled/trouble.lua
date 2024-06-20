return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
         -- your configuration comes here
         -- or leave it empty to use the default settings
         -- refer to the configuration section below
    },
    config = function ()
        vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>")
        vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
        vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>")
        vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>")
        vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>")
        vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>")
    end,
}
