-- codecompanion.nvim — TEMPORARY test config, prefix <leader>I (agentic.nvim uses <leader>i).
-- Uses only built-in commands/options, so it should survive plugin updates.
--
-- Adapters (all ACP): kiro (default, Auto) · kiro_sonnet · kiro_lite (0.05x credits) · claude_code
-- Kiro can't switch model/mode inside a chat (codecompanion only supports ACP config options),
-- so pick the model via the adapter. Claude Code supports `ga` model switching + /acp_session_options.
--
-- In a chat: ga adapter/model · { } prev/next chat · /resume (Claude) · /acp_session_options
--            #{buffer} #{diagnostics} · /file · @ file picker · ? all keymaps
-- Remapped like agentic: q hide · <C-c> stop · <localleader>D close (destroy)

-- <leader>Ia: reference the current file in the chat. It's listed under "> Context:" at the top of
-- the prompt (delete the line there to drop it); the agent gets "Referenced file: <path>" with the
-- next message and reads the file itself.
local function add_current_file()
    local path = vim.fn.expand("%:.")
    if path == "" or vim.bo.buftype ~= "" then
        return vim.notify("Not a file buffer", vim.log.levels.WARN)
    end
    local cc = require("codecompanion")
    local chat = cc.last_chat() or cc.chat()
    -- (source must not be "file"/"buffer": those tags are sent differently and would be dropped)
    chat:add_context({ content = "Referenced file: " .. path }, { source = "ref", id = "<file>" .. path .. "</file>" })
    chat.ui:open() -- no-op if already visible
end

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    -- stylua: ignore
    keys = {
        { "<leader>Ii", "<cmd>CodeCompanionChat Toggle<cr>",            desc = "Toggle chat" },
        { "<leader>In", "<cmd>CodeCompanionChat<cr>",                   desc = "New chat" },
        { "<leader>IN", function()
            vim.ui.select({ "kiro", "kiro_sonnet", "kiro_lite", "claude_code" }, { prompt = "New chat with:" }, function(a)
                if a then vim.cmd("CodeCompanionChat adapter=" .. a) end
            end)
        end, desc = "New chat (pick agent)" },
        { "<leader>Ic", "<cmd>CodeCompanionChat adapter=kiro_lite<cr>", desc = "New quick-ask chat (lite)" },
        { "<leader>Ia", add_current_file,                               desc = "Add file to chat" },
        { "<leader>IA", "<cmd>CodeCompanionActions<cr>",                desc = "Action palette",        mode = { "n", "v" } },
        { "<leader>Ie", "<cmd>CodeCompanion<cr>",                       desc = "Inline edit",           mode = { "n", "v" } },
    },
    opts = {
        adapters = {
            acp = {
                opts = { show_presets = false }, -- list only the adapters below
                kiro = "kiro",
                kiro_sonnet = function()
                    return require("codecompanion.adapters").extend("kiro", {
                        name = "kiro_sonnet", -- must match the key
                        formatted_name = "Kiro (Claude Sonnet 5.5)",
                        commands = { default = { "kiro-cli", "acp", "--model", "claude-sonnet-5.5" } },
                    })
                end,
                kiro_lite = function()
                    return require("codecompanion.adapters").extend("kiro", {
                        name = "kiro_lite",
                        formatted_name = "Kiro Lite",
                        commands = { default = { "kiro-cli", "acp", "--model", "qwen3-coder-next", "--effort", "low" } },
                    })
                end,
                -- `claude-agent-acp`; Bedrock auth comes from ~/.claude/settings.json. The ENTRYPOINT
                -- override makes these sessions show up in the terminal `claude --resume` (as in agentic).
                claude_code = function()
                    return require("codecompanion.adapters").extend("claude_code", {
                        env = { CLAUDE_CODE_ENTRYPOINT = "codecompanion-nvim" },
                    })
                end,
            },
            http = { opts = { show_presets = false } }, -- no HTTP adapters (copilot, openai, ...)
        },
        interactions = {
            chat = {
                adapter = "kiro",
                keymaps = {
                    hide = {
                        modes = { n = "q" },
                        callback = function(chat)
                            chat.ui:hide()
                        end,
                        description = "Hide chat",
                    },
                    stop = { modes = { n = "<C-c>" } }, -- default: q
                    -- Default close is <C-c> in normal AND insert mode: leaving insert mode the
                    -- agentic way would destroy the chat.
                    close = false,
                    destroy = { modes = { n = "<localleader>D" }, callback = "keymaps.close", description = "Close chat" },
                },
            },
            inline = { adapter = "kiro" },
        },
        display = {
            chat = {
                window = { position = "right", width = 0.4 },
                input = { layout = "split", height = 10 }, -- separate prompt window, like agentic
            },
        },
    },
    init = function()
        -- @ in the prompt opens a snacks file picker; the picked path replaces the @ (cancel keeps
        -- it). Same snippet as in agentic.nvim.lua. (@ is codecompanion's tool trigger only for
        -- HTTP adapters, and none are configured.)
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "codecompanion_chat_input",
            callback = function(ev)
                vim.keymap.set("i", "@", function()
                    vim.api.nvim_put({ "@" }, "c", false, true)
                    local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- col: just after the @
                    Snacks.picker.files({
                        confirm = function(picker, item)
                            picker:close() -- refocuses the prompt window
                            if item then
                                local path = vim.fn.fnamemodify(item.file, ":.")
                                vim.api.nvim_buf_set_text(ev.buf, row - 1, col - 1, row - 1, col, { path })
                                -- Scheduled keys run after snacks has left insert mode (like snacks'
                                -- own paste action): cursor on the path's last char, then append.
                                local keys = ("<Cmd>call cursor(%d, %d)<CR>a"):format(row, col - 1 + #path)
                                vim.schedule(function()
                                    vim.api.nvim_feedkeys(vim.keycode(keys), "n", false)
                                end)
                            end
                        end,
                    })
                end, { buffer = ev.buf, desc = "@ file picker (snacks)" })
            end,
        })
    end,
}
