return {
    "folke/which-key.nvim",
    keys = function()
        local map = require("map")
        map.map({'n'}, '<leader><c-/>', function() require("which-key").show({ global = false }) end, { desc = "Buffer Local Keymaps (which-key)" })
        map.exportKeys()
    end,
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
    end,
    opts = {
        notify = false
        -- your configuration comes here or leave it empty to use the default settings
    }
}
