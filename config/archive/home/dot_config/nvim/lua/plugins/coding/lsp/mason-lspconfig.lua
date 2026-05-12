return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_insalled = { }
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        { "neovim/nvim-lspconfig" }
    },
    config = function(opts)
        require('mason-lspconfig').setup(opts)
    end
}


