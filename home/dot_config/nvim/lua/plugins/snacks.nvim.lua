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
            { "<leader>ac", LazyVim.pick.config_files(),                                            desc = "Config Files (find)" },
            { "<leader>e", function() Snacks.explorer({ cwd = LazyVim.root() }) end,                desc = "Explorer Snacks (root dir)" },
            { "<leader>E", function() Snacks.explorer() end,                                        desc = "Explorer Snacks (cwd)" },
            -- Required to locate file in case LazyVim.root isn't set
            { "<leader>ę",
                function()
                    local pickers = Snacks.picker.get({ source = "explorer" })
                    if #pickers > 0 then
                      pickers[1]:close()
                    else
                      Snacks.explorer.reveal({ cwd = LazyVim.root() })
                    end
                end,
                                                                                                    desc = "Explorer Snacks (current file)" },
            { "<leader>fP", function() Snacks.picker.projects() end,                                desc = "Projects (auto detected)" },
            {
                "<leader>ft",
                function()
                    ---@type snacks.picker.finder.Item[]
                    local items = {}
                    local current_buf = vim.api.nvim_get_current_buf()
                    for _, term in ipairs(Snacks.terminal.list()) do
                        local buf = term.buf
                        if buf and vim.api.nvim_buf_is_valid(buf) then
                            local meta = vim.b[buf].snacks_terminal or {}
                            local id = meta.id or ""
                            local title = vim.b[buf].term_title or ""
                            local cmd = meta.cmd
                            if type(cmd) == "table" then
                                cmd = table.concat(cmd, " ")
                            end
                            local label = ("%s: %s"):format(id, cmd or title or "shell")
                            items[#items + 1] = {
                                text = ("%s %s %s"):format(id, label, buf),
                                buf = buf,
                                label = label,
                                cwd = meta.cwd,
                                current = buf == current_buf,
                            }
                        end
                    end
                    table.sort(items, function(a, b)
                        return tostring(a.label) < tostring(b.label)
                    end)
                    Snacks.picker({
                        title = "Terminals",
                        items = items,
                        format = function(item)
                            local ret = {}
                            ret[#ret + 1] = { "  ", "SnacksPickerIcon" }
                            ret[#ret + 1] = { item.label, item.current and "SnacksPickerBufNr" or "SnacksPickerLabel" }
                            if item.cwd then
                                ret[#ret + 1] = { "  " }
                                ret[#ret + 1] = { vim.fn.fnamemodify(item.cwd, ":~"), "SnacksPickerDir" }
                            end
                            return ret
                        end,
                        preview = "file",
                        confirm = function(picker, item)
                            picker:close()
                            if item and item.buf and vim.api.nvim_buf_is_valid(item.buf) then
                                local meta = vim.b[item.buf].snacks_terminal or {}
                                if meta.id then
                                    vim.g.last_term_count = meta.id
                                end
                                for _, term in ipairs(Snacks.terminal.list()) do
                                    if term.buf == item.buf then
                                        term:show():focus()
                                        return
                                    end
                                end
                            end
                        end,
                    })
                end,
                desc = "Terminals (picker)",
            },
        },
        opts = {
            picker = {
                enabled = true,
                hidden = true,
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
                    -- Native buffer search action
                    buffer_search = function(picker)
                        vim.api.nvim_feedkeys("/", "n", false)
                    end,
                    -- Copy the current item's cwd-relative path to the + register.
                    -- Handy for pasting a path into the agentic.nvim prompt (p).
                    copy_relative_path = function(picker, item)
                        item = item or picker:current()
                        local path = item and (item.file or item.text)
                        if not path then
                            return
                        end
                        local rel = vim.fn.fnamemodify(path, ":.")
                        vim.fn.setreg("+", rel)
                        vim.notify(
                            "Copied to +: " .. rel,
                            vim.log.levels.INFO
                        )
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
                            [",/"] = "buffer_search", -- Trigger native Vim search in any picker list window
                        },
                    },
                },
                sources = {
                    files = {
                        hidden = true,
                        win = {
                            -- Bind Y in BOTH sub-windows to copy_relative_path so
                            -- it consistently yanks a cwd-relative path into the +
                            -- register (for pasting into the agentic prompt with p).
                            -- Snacks has no default Y action; the "Y works in the
                            -- list" behaviour was plain normal-mode line-yank of the
                            -- rendered row, which is inconsistent -- so we override
                            -- it explicitly here.
                            input = {
                                keys = {
                                    ["Y"] = { "copy_relative_path", mode = { "n" } },
                                },
                            },
                            list = {
                                keys = {
                                    ["Y"] = { "copy_relative_path", mode = { "n" } },
                                },
                            },
                        },
                    },
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
                                    ["<localleader>g"] = { "picker_grep" },
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
