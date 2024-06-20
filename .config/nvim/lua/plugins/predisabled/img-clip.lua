return {
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    opts = {
        -- add options here
        -- or leave it empty to use the default settings
    },
    config = function()
        vim.keymap.set("n",  "<leader>ip", "<cmd>PasteImage<cr>")
    end,
}
