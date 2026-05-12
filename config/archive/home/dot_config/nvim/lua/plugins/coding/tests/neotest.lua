return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        -- test adapters
        "nvim-neotest/neotest-plenary",
        "alfaix/neotest-gtest",
        "rcasia/neotest-bash"
    },
    config = function ()
        require("neotest").setup({
            adapters = {
                require("neotest-plenary"),
                require("neotest-bash"),
                require("neotest-gtest").setup({}),
            },
        })
    end,
    keys = function()
        local map = require('map')
        map.group(   '<leader>n',                                       { group = "[n]eotest" })
        map.map('n', '<leader>nr', map.func('neotest.run.run'),         { desc = "[r]un test under cursor" })
        map.map('n', '<leader>ns', map.cmd('Neotest summary'),          { desc = "[s]ummary" })
        --require("neotest").run.run()
        --require("neotest").run.run(vim.fn.expand("%"))
        --require("neotest").run.run({strategy = "dap"})
        --require("neotest").run.stop()
        --require("neotest").run.attach()
        return map.exportKeys()
    end
}

-- TODO: Add automatic installation of bashunit to .lib/bashunit
