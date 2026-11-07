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
            vim.g.tabLeader .. "e",
            "<cmd>Yazi<cr>",
            mode = { "n", "v" },
            desc = "Explorer (locate current file)",
        },
        -- Open in the current root directory
        {
            vim.g.tabLeader .. "E",
            function()
                require("yazi").yazi(nil, LazyVim.root())
            end,
            mode = { "n", "v" },
            desc = "Explorer (root dir)",
        },
        {
            -- Open in the current working directory
            vim.g.tabLeader .. "ę",
            "<cmd>Yazi cwd<cr>",
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
            -- yazi.nvim registers a terminal-mode (`t`) buffer-local map for
            -- `cycle_open_buffers` on <Tab> (default). That map intercepts
            -- <Tab> inside the yazi float and uses it to cycle Neovim buffers,
            -- so <Tab> never reaches Yazi itself. Disable it so <Tab> is passed
            -- through to Yazi, where keymap.toml defines the <Tab> tab-leader.
            cycle_open_buffers = false,
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
