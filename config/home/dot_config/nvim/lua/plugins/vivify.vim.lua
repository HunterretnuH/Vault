return {
    { "iamcco/markdown-preview.nvim", enabled = false },
    {
        "jannis-baum/vivify.vim",
        cmd = { "Vivify" },
        keys = {
            { "<leader>WP", function() vim.cmd("Vivify") end, desc = "Preview wiki/md in browser", },
        },
    },
}
