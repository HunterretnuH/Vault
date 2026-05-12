################################# MAPPINGS ##################################
-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--#1 Global keymaps
    --#2 Remove/Replace/Reload: modeline
    vim.keymap.set({'n'}, '<leader>uM', ':doautocmd BufRead<CR>',     { desc = 'Reload Modeline', silent = true })
    vim.keymap.set({'n'}, '<leader>Mw', ':%s/\\s\\+$//<CR>:noh<CR>',  { desc = 'Remove whitespaces at the EOL'})
    vim.keymap.set({'n'}, '<leader>Mc', ':%s/\\r//g<CR>:noh<CR>',     { desc = 'Remove carriage returns'})
    vim.keymap.set({'n'}, '<leader>Mt', ':%s/\\t/    /g<CR>:noh<CR>', { desc = 'Replace tabs with 4 spaces'})
    vim.keymap.set({'n'}, '<leader>MT', ':%s/\\t/    /g<CR>:noh<CR>', { desc = 'Replace tabs with 2 spaces'})

    --#2 Save: buffer, all buffers
    local save_file_and_notify = function()
        vim.cmd('w')
        vim.notify("Saved buffer", vim.log.levels.INFO)
    end
    local save_all_files_and_notify = function()
        vim.cmd('wa')
        vim.notify("Saved all buffers", vim.log.levels.INFO)
    end
    vim.keymap.set({'n', 'i'}, '<C-s>',   save_file_and_notify,      { desc = 'Save buffer',      silent = true })
    vim.keymap.set({'n', 'i'}, '<C-S-s>', save_all_files_and_notify, { desc = 'Save all buffers', silent = true })

    --#2 General keybindings without group
    vim.keymap.set({'i'}, '<C-BS>',     '<C-w>',             { desc = 'Delete words with Ctrl + Backspace', silent = true })
    vim.keymap.set({'v'}, '<leader>p',  '"_dP',              { desc = 'Paste into selection', silent = true })
    vim.keymap.set({'n', 'i'}, '<C-q>', '<ESC>:q<CR>',       { desc = 'Quit',       silent = true })
    vim.keymap.set({'n'}, '<C-S-q>',    '<ESC>:q!<CR>',      { desc = 'Force Quit', silent = true })

    --#2 Command-line window mappings
    local function cmd_window_mappings()
        vim.keymap.set({'n'}, 'q', ':q<CR>', { buffer = true }) -- noremap <silent> : :
    end
    vim.api.nvim_create_autocmd( {"CmdwinEnter"}, { callback = cmd_window_mappings } )

    --#2 Terminal mappings
    vim.keymap.set({'t'}, '<ESC><ESC>', '<C-\\><C-n>',       { desc = 'Exit terminal' })
    if not vim.g.vscode then
    vim.keymap.set({"n","t"}, "<C-S-/>",function() Snacks.terminal.focus(nil) end, { desc = "Terminal (cwd)" })
    end
    -- Allow Ctrl+Shift+X to clear the terminal inside Neovim
    vim.keymap.set('t', '<C-S-X>', [[<C-l>]], { desc = "Clear terminal" })

    --#2 Show mappings
    vim.keymap.set({'n'}, '<leader>Sr',    '<cmd>LazyRoot<cr>',      { desc = 'Root + cwd + ...', silent = true })

    --#2 Navigation - includes tmux
    -- Source: https://github.com/aserowy/tmux.nvim/issues/92
    if not vim.g.vscode then
        vim.keymap.set("n", "<C-h>", "<cmd>lua require'tmux'.move_left()<cr>",   { desc = "Go to left window" })
        vim.keymap.set("n", "<C-j>", "<cmd>lua require'tmux'.move_bottom()<cr>", { desc = "Go to lower window" })
        vim.keymap.set("n", "<C-k>", "<cmd>lua require'tmux'.move_top()<cr>",    { desc = "Go to upper window" })
        vim.keymap.set("n", "<C-l>", "<cmd>lua require'tmux'.move_right()<cr>",  { desc = "Go to right window" })
    end

--#1 Deleted Lazyvim Keymaps
    -- Buffer control mappings
    vim.keymap.del({"n"}, "<leader>bb")
    vim.keymap.del({"n"}, "<leader>bd")
    vim.keymap.del({"n"}, "<leader>bD")
    vim.keymap.del({"n"}, "<leader>bo")

    -- Tabs control mappings
    vim.keymap.del({"n"}, "<leader><Tab>d")
    vim.keymap.del({"n"}, "<leader><Tab>f")
    vim.keymap.del({"n"}, "<leader><Tab>l")
    vim.keymap.del({"n"}, "<leader><Tab>o")
    vim.keymap.del({"n"}, "<leader><Tab>[")
    vim.keymap.del({"n"}, "<leader><Tab>]")
    vim.keymap.del({"n"}, "<leader><Tab><Tab>")

    -- File/Find group
    vim.keymap.del({"n"}, "<leader>fn")
    vim.keymap.del({"n"}, "<leader>ft")
    -- TODO: Add mapping for opening terminal in cwd and generally some multiple terminals plugin
    vim.keymap.del({"n"}, "<leader>fT")
    vim.keymap.del({"n"}, "<leader>fc")
    vim.keymap.del({"n"}, "<leader>fe")
    vim.keymap.del({"n"}, "<leader>fE")

    -- Search group
    -- HACK: It should be disabled if such keys aren't registred instead of vscode variable guard
    if not vim.g.vscode then
    vim.keymap.del({"n"}, "<leader>n")
    vim.keymap.del({"n"}, "<leader>sn")
    vim.keymap.del({"n"}, "<leader>sna")
    vim.keymap.del({"n"}, "<leader>snd")
    vim.keymap.del({"n"}, "<leader>snh")
    vim.keymap.del({"n"}, "<leader>snl")
    vim.keymap.del({"n"}, "<leader>snt")

    -- Code group
    vim.keymap.del("n", "<leader>cm")
    vim.keymap.del("n", "<leader>l")
    vim.keymap.del("n", "<leader>L")
    end

    --#2 Alternative mappings for deleted
    vim.keymap.set("n", "<leader>al", "<cmd>Lazy<cr>", { desc = "Lazy (plugins)" })
    vim.keymap.set("n", "<leader>ae", "<cmd>LazyExtra<cr>", { desc = "Lazy Extras" })
    vim.keymap.set("n", "<leader>am", "<cmd>Mason<cr>", { desc = "Mason (LSP)" })
    vim.keymap.set("n", "<leader>aL", function() LazyVim.news.changelog() end, { desc = "LazyVim Changelog" })
    vim.keymap.set("n", "<leader>al", "<cmd>Lazy<cr>", { desc = "Lazy (plugins)" })
    vim.keymap.set("n", "<leader>ae", "<cmd>LazyExtra<cr>", { desc = "Lazy Extras" })
    vim.keymap.set("n", "<leader>sn", function() Snacks.picker.notifications() end, { desc = "Notifications" })
    -- HACK: Setting keybinding in plugin config file causes load order problem - 50% of the time keybinding isn't working.
    vim.keymap.set("n", "<leader>fp", function() require('telescope').extensions.project.project() end, { desc = "Projects (custom)" })

--#1 VSCODE
    --#2 Opening files in VScode
    -- TODO: If neovim isn't connected to server, then start server, connect to it and restore session; need to make server names better - more unique and still consistant
    vim.keymap.set('n', '<leader>vc', function()
        local file = vim.fn.expand('%:p')
        local line = vim.fn.line('.')
        local col = vim.fn.col('.')
        -- Use the current working directory to tell VS Code which project window to target
        local cwd = vim.fn.getcwd()

        -- Construct the command:
        -- -r: reuse the window matching the path
        -- -g: goto line/col
        local cmd = string.format("code -r -g '%s' '%s:%d:%d'", cwd, file, line, col)

        vim.fn.jobstart(cmd, { detach = true })
    end, { desc = "Return to specific VS Code instance" })

    --#2 Vscode-Only Keymaps
    if vim.g.vscode then
        local vscode = require("vscode")
        local tl = vim.g.tabLeader

        ----------------------------------------------------------------
        -- NAVIGATION (Next/Prev/First/Last)
        ----------------------------------------------------------------
        -- We map both bufLeader and tabLeader to the same actions in VSCode
        local function map(key, cmd)
            vim.keymap.set("n", key, function() vscode.call(cmd) end)
        end

        map(tl .. "j", "workbench.action.previousEditor")
        map(tl .. "k", "workbench.action.nextEditor")
        map(      "H", "workbench.action.previousEditor")
        map(      "L", "workbench.action.nextEditor")
        map(tl .. "J", "workbench.action.firstEditorInGroup")
        map(tl .. "K", "workbench.action.lastEditorInGroup")

        ----------------------------------------------------------------
        -- MOVE (Step / To Edges)
        ----------------------------------------------------------------
        map(tl .. "h", "workbench.action.moveEditorLeftInGroup")
        map(tl .. "l", "workbench.action.moveEditorRightInGroup")
        map(tl .. "H", "workbench.action.moveEditorToFirstPosition") -- FAIL
        map(tl .. "L", "workbench.action.moveEditorToLastPosition")  -- FAIL

        ----------------------------------------------------------------
        -- CREATE & CLOSE
        ----------------------------------------------------------------
        -- New file/buffer
        map(tl .. "n",  "workbench.action.files.newUntitledFile")
        -- Close Active
        map(tl .. "q",  "workbench.action.closeActiveEditor")
        -- Close Others/Bulk
        map(tl .. "Qo", "workbench.action.closeOtherEditors")
        map(tl .. "Qh", "workbench.action.closeEditorsToTheLeft")
        map(tl .. "Ql", "workbench.action.closeEditorsToTheRight")

        ----------------------------------------------------------------
        -- PICKER / SWITCH
        ----------------------------------------------------------------
        -- Switch to last used editor (Equivalent to <cmd>e #<CR>)
        local recent_tab_toggle = true
        vim.keymap.set("n", tl .. "w", function()
            if recent_tab_toggle then
                vscode.call("workbench.action.openPreviousRecentlyUsedEditorInGroup")
            else
                vscode.call("workbench.action.openNextRecentlyUsedEditorInGroup")
            end
            recent_tab_toggle = not recent_tab_toggle
        end, { desc = "Toggle recent tab" })

        -- Find buffer (Open the VSCode "Open Editors" picker)
        map(tl .. ";", "workbench.action.showAllEditors")

        ----------------------------------------------------------------
        -- PINNING
        ----------------------------------------------------------------
        map(tl .. "p", "workbench.action.pinEditor")
        map(tl .. "P", "workbench.action.unpinEditor")


        map("<leader>e",      "workbench.view.explorer")
        map("<C-S-1><Tab>",   "workbench.action.toggleSidebarVisibility")
        map("<C-S-1><Space>", "workbench.action.togglePanel")
        map("<C-S-1><CR>",    "workbench.action.toggleAuxiliaryBar")


        map("<C-q>",          "notebook.cell.quitEdit")
    end

-- vim: foldmethod=marker foldmarker=--#,--+ textwidth=120 colorcolumn=121 nowrap foldlevel=0

