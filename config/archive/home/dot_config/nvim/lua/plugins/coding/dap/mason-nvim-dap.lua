return {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {"williamboman/mason.nvim", "mfussenegger/nvim-dap"},
    config = function()
        require('mason-nvim-dap').setup()
    end
}
-- TODO:
-- * make sure mason-nvim-dap is loaded after mason.nvim
