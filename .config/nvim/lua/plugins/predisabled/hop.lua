return {
    'smoka7/hop.nvim',
    version = "*",
    config = function()
        require('hop').setup({
            keys = 'etovxqpdygfblzhckisuran'
        })
        vim.keymap.set("n", "<C-/>", "<cmd>HopPattern<CR>")
    end,
}
