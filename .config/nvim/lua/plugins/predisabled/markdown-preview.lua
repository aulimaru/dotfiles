return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
    keys = {
        {
            "<leader>p",
            ft = "markdown",
            "<cmd>MarkdownPreviewToggle<cr>",
            desc = "Markdown Preview",
        },
    },
    config = function()
        vim.g.mkdp_browser = "/usr/bin/librewolf"
        vim.g.mkdp_theme = "dark"
        vim.cmd([[do FileType]])
    end,
}
