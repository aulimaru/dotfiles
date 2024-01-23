return {
    'gaborvecsei/memento.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    config = function()
        vim.keymap.set("n", "<leader>h", "<cmd>lua require('memento').toggle()<CR>",{desc = "History Files"})
    end,
}
