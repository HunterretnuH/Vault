return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewToggleFiles" },
    keys = function()
        local diffviewOpenCustom = function()
            local revision = vim.fn.input("Revision: ")
            local paths = vim.fn.input("Paths to check: ", vim.fn.getcwd() .. "/", "file")
            vim.cmd("DiffviewOpen " .. revision .. " -- ", paths)
        end

        local diffviewFileHistoryCustom = function()
            local command = vim.fn.input("[paths] [options]: ")
            vim.cmd("DiffviewOpen " .. command)
        end

        return {
            { "<leader>dd", function() vim.cmd("DiffviewOpen") end,        desc = "Diff view open", },
            { "<leader>dD", diffviewOpenCustom,                            desc = "Diff view open - custom rev/filter", },
            { "<leader>dh", function() vim.cmd("DiffviewFileHistory") end, desc = "History show - file history", },
            { "<leader>dH", diffviewFileHistoryCustom,                     desc = "History show - custom path" },
            { "<leader>dq", function() vim.cmd("DiffviewClose") end,       desc = "Quit diff view", },
            { "<leader>dr", function() vim.cmd("DiffviewRefresh") end,     desc = "Refresh current diffview", },
        }
    end,
    config = function()
        vim.api.nvim_create_augroup("MyDiffViewAutocmd", { clear = true })
        vim.api.nvim_create_autocmd("User", {
            pattern = "DiffviewViewOpened",
            group = "MyDiffViewAutocmd",
            callback = function()
                vim.keymap.set( { "n" }, "<leader>df", function() vim.cmd('DiffviewFocusFiles') end, { desc = "Files panel focus" })
                vim.keymap.set( { "n" }, "<leader>dF", function() vim.cmd('DiffviewToggleFiles') end, { desc = "Files panel toggle" })
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "DiffviewViewClosed",
            group = "MyDiffViewAutocmd",
            callback = function()
                vim.keymap.del( "n", "<leader>df")
                vim.keymap.del( "n", "<leader>dF")
            end,
        })
    end,
}
