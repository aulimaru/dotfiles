return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- disable netrw at the very start of your init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true

    -- config
    require("nvim-tree").setup({
        view = {
            width = 30,
        },
        renderer = {
            group_empty = true
        },
        filters = {
            dotfiles = true,
        },
    })

    -- keymaps
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<CR>")
    vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeClose<CR>")
    -- vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>")
  end
}
