return {
    {
        "folke/snacks.nvim",
        -- https://github.com/folke/snacks.nvim/discussions/1583#discussioncomment-12517485
        --   show preview on right side, instead of in File Explorer
        -- TODO: Remap all one by one to my old leader for search/find, but first I need a plan
        -- keys = function()
        --     local sl = vim.g.seekerLeader
        --     return {
        --             { sl .. b,      function() require("flash").jump() end,              desc = "Flash",               mode = { "n", "x", "o" } },
        --
        --     }
        -- end,
        keys = {
            { "<leader>ac", LazyVim.pick.config_files(),                             desc = "Config Files (find)" },
            { "<leader>e", function() Snacks.explorer({ cwd = LazyVim.root() }) end, desc = "Explorer Snacks (root dir)", },
            { "<leader>E", function() Snacks.explorer() end,                         desc = "Explorer Snacks (cwd)", },
            { "<leader>fP", function() Snacks.picker.projects() end,                 desc = "Projects (auto detected)", },
        },
        opts = {
            picker = {
                enabled = true,
                actions = {
                    -- Explorer
                    confirm_and_close = function(picker)
                        picker:action("confirm")
                        picker:action("close")
                    end,
                    confirm_nofocus = function(picker)
                        picker:action("confirm")
                        picker:focus()
                    end,
                    change_current_dir_for_tab = function(picker)
                        picker:action("tcd")
                    end,
                },
                win = {
                    input = {
                        keys = {
                            ["<esc>"] = false,
                            ["<C-q>"] = false,
                            ["Q"] = { "qflist" },
                        },
                    },
                    list = {
                        keys = {
                            ["<esc>"] = false,
                            ["<C-q>"] = false,
                            ["Q"] = { "qflist" },
                        },
                    },
                },
                sources = {
                    explorer = {
                        win = {
                            list = {
                                keys = {
                                    -- Modified/new keybindings
                                    ["L"] = "confirm_and_close",
                                    ["<CR>"] = "confirm",
                                    ["l"] = "confirm_nofocus",
                                    ["zo"] = "confirm_nofocus",
                                    ["zc"] = "explorer_close",
                                    ["zM"] = "explorer_close_all",
                                    [">"] = { "change_current_dir_for_tab" },
                                    ["oo"] = "explorer_open",
                                    ["ov"] = "edit_vsplit",
                                    ["oh"] = "edit_split",
                                    ["<localleader>/"] = { "picker_grep" },
                                    ["<localleader>tf"] = { "toggle_follow" },
                                    ["<localleader>th"] = { "toggle_hidden" },
                                    ["<localleader>ti"] = { "toggle_ignored" },
                                    ["<C-m>"] = { "toggle_maximize" },
                                    ["<C-r>"] = { "update" },
                                    ["i"] = { "inspect" },
                                    ["<C-w>W"] = { "cycle_win" },
                                    mode = { "n", "i" }, -- TODO: Remap - temporary
                                    -- TODO: Add keybindings for yanking path: yy, yn, yp, yP, yN
                                    -- Disabled keybindings
                                    ["<C-s>"] = false,
                                    ["<C-v>"] = false,
                                    ["Z"] = false,
                                    ["o"] = false,
                                    ["<S-CR>"] = false,
                                    ["<Space>/"] = false,
                                    ["I"] = false,
                                    ["zb"] = false,
                                    ["zt"] = false,
                                    ["<M-w>"] = false,
                                    ["u"] = false,
                                    ["<M-d>"] = false,
                                    ["<M-f>"] = false,
                                    ["<M-h>"] = false,
                                    ["<M-i>"] = false,
                                    ["<M-m>"] = false,
                                    ["<M-p>"] = false,
                                    ["<C-c>"] = false,
                                    ["<Up>"] = false,
                                    ["<Down>"] = false,
                                    ["<C-n>"] = false,
                                    ["<C-p>"] = false,
                                },
                            },
                        },
                        layout = {
                            -- cycle = true,
                            -- Show preview in main window and don't make preview default
                            preview = { main = true, enabled = false },
                        },
                    },
                    buffers = {
                        win = {
                            input = {
                                keys = {
                                    -- ["<c-x>"] = { "bufdelete", mode = { "n", "i" } },
                                    ["dd"] = { "bufdelete", mode = { "n" } },
                                    ["K"] = { "select_and_prev" },
                                    ["J"] = { "select_and_next" },
                                },
                            },
                            list = { keys = { ["dd"] = "bufdelete", mode = { "n" } } },
                        },
                    },
                },
            },
        },
    },
    {
        "folke/snacks.nvim",
        opts = function(_, opts)
            -- Find the default "p" (Projects) and change its key to "P"
            for _, button in ipairs(opts.dashboard.preset.keys) do
                if button.key == "p" then
                    button.key = "P"
                    button.desc = "Projects (auto detected)"
                end
            end

            table.insert(opts.dashboard.preset.keys, 3, {
                icon = " ",
                key = "p",
                desc = "Projects",
                action = function()
                    require("telescope").extensions.project.project()
                end,
            })

            table.insert(opts.dashboard.preset.keys, 5, {
                icon = " ",
                key = "w",
                desc = "Wiki",
                action = function()
                    local env = require("env")
                    require("lazy").load({ plugins = { "wiki.vim" } })
                    vim.cmd(":e " .. env.wiki.primary_wiki_path .. "index.md")
                end,
            })

        end,
    },
}
