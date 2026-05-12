---@type LazySpec
return {
    "mikavilpas/yazi.nvim",
    version = "*", -- use the latest stable version
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
        -- Open in the current file directory
        {
            vim.g.tabLeader .. "l",
            "<cmd>Yazi<cr>",
            mode = { "n", "v" },
            desc = "Explorer (locate current file)",
        },
        -- Open in the current root directory
        {
            vim.g.tabLeader .. "e",
            function()
                require("yazi").yazi(nil, LazyVim.root(), { reveal_path = vim.api.nvim_buf_get_name(0) })
            end,
            mode = { "n", "v" },
            desc = "Explorer (root dir)",
        },
        {
            -- Open in the current working directory
            vim.g.tabLeader .. "E",
            "<cmd>Yazi<cr>",
            mode = { "n", "v" },
            desc = "Explorer (cwd)",
        },
        -- Resume last Explorer
        {
            vim.g.tabLeader .. "R",
            "<cmd>Yazi toggle<cr>",
            mode = { "n", "v" },
            desc = "Resume Explorer",
        },
    },
    ---@type YaziConfig | {}
    opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = false,
        keymaps = {
            show_help = "<f1>",
        },
    },
    -- -- 👇 if you use `open_for_directories=true`, this is recommended
    -- init = function()
    --   -- mark netrw as loaded so it's not loaded at all.
    --   --
    --   -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    --   vim.g.loaded_netrwPlugin = 1
    -- end,
}
