return {
    "nvim-telescope/telescope.nvim",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').load_extension('fzf')
        vim.keymap.set('n', '<leader>ff', "<cmd>Telescope find_files<cr>")
        vim.keymap.set('n', '<leader>fb', "<cmd>Telescope buffers<cr>")
    end,
}
