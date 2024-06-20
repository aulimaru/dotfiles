return {
    "RRethy/vim-illuminate",
    opts = {
        delay = 100,
        large_file_cutoff = 2000,
        large_file_overrides = {
            providers = { "lsp" },
        },
    },
    config = function(_, opts)
        require("illuminate").configure(opts)
    end,
}
