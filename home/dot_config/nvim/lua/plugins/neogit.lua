return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "sindrets/diffview.nvim", -- optional - Diff integration
        "folke/snacks.nvim", -- optional
    },
    lazy = true,
    cmd = { 'Neogit' },
    keys = {
        { "<leader>gg", function()
                local root = LazyVim.root.get({ normalize = true })
                require("neogit").open({ cwd = root })
            end,                                                                            desc = "NEOGIT (open)" },
        { '<leader>gGc', function() require('neogit').open( { "commit" } ) end,             desc = "Commit open" },
        { '<leader>gGs', function() require('neogit').open( { kind = "vsplit_left" } ) end, desc = "Split - open in vsplit" },
        { '<leader>gGr', function() require('neogit').open(
                            { cmd = vim.fn.input("Path to repository: ",
                            vim.fn.getcwd() .. "/", "file") }) end,                         desc = "Custom Repository" },

    },
    config = function()
        require('neogit').setup({
            graph_style = "kitty",
        })
    end
}
