-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │ agentic.nvim  (TEMPORARY test config — prefix <leader>i)                   │
-- │ https://github.com/carlos-algms/agentic.nvim                               │
-- ╞══════════════════════════════════════════════════════════════════════════╡
-- │ ACP chat interface. Default provider = "kiro-acp" -> `kiro-cli acp`.       │
-- │ kiro-cli must be on PATH and logged in. Requires Neovim >= 0.11.           │
-- ╞══════════════════════════════════════════════════════════════════════════╡
-- │ QUICK-ASK "CHAT" (<leader>ic)                                              │
-- │   A dedicated lightweight session using the "kiro-lite" provider:          │
-- │   kiro-cli acp pinned to qwen3-coder-next (0.05x credits) + low effort.    │
-- │   ~20x cheaper than Auto — for throwaway questions ("bash flag for X?").   │
-- │   <leader>ic toggles it; it reuses one session instead of spawning many.   │
-- ╞══════════════════════════════════════════════════════════════════════════╡
-- │ MULTIPLE SESSIONS / MULTIPLE AGENTS                                        │
-- │   Sessions are NOT tied to tabs; each gets a stable integer "session key". │
-- │   At most ONE session is visible per tab — a hidden session keeps running. │
-- │   To run 2 agents at once: start each with <leader>iN (pick provider),     │
-- │   then either cycle them in place (<leader>is / <localleader>[ ]) or put   │
-- │   each in its own tab to see both side-by-side.                            │
-- ╞══════════════════════════════════════════════════════════════════════════╡
-- │ SESSION PERSISTENCE (survives closing Neovim)                              │
-- │   kiro-cli saves every conversation on disk per-cwd automatically — you    │
-- │   don't save manually. Reopen Neovim and use <leader>irk to pick a saved   │
-- │   session and reload it (it also resumes terminal `kiro-cli chat` ones,    │
-- │   and vice-versa). <leader>irr (native picker) does NOT work with kiro:    │
-- │   the ACP agent can't list sessions, so it errors — that's why <leader>irk │
-- │   lists via `kiro-cli chat --list-sessions` then restore_session_by_id().  │
-- ╞══════════════════════════════════════════════════════════════════════════╡
-- │ GLOBAL KEYMAPS (defined here, all under <leader>i = "AI (agentic)")        │
-- │   <leader>ii  Toggle chat sidebar (current session)  (n + v)               │
-- │   <leader>ic  Toggle lightweight quick-ask chat      (n)  <- kiro-lite     │
-- │   <leader>in  New session (same provider)            (n + v)               │
-- │   <leader>iN  New session, PICK provider             (n)  <- 2nd agent     │
-- │   <leader>ia  Add file/selection to context          (n + v)               │
-- │   <leader>ir  Restore session GROUP:                 (n)                    │
-- │     <leader>ira  Restore Kiro session, all dirs      (n)  <- --all-cwds     │
-- │     <leader>irk  Restore Kiro session, cwd           (n)  <- kiro-cli list  │
-- │     <leader>irr  Restore session (native picker)     (n)  <- needs listing  │
-- │   <leader>is  Select/switch live session             (n)                   │
-- │   <leader>ip  Switch provider (this session)         (n)                   │
-- │   <leader>iL  Rotate layout (right→bottom→left)       (n)                   │
-- │   <leader>id  Add current-line diagnostic            (n)                   │
-- │   <leader>iD  Add all buffer diagnostics             (n)                   │
-- │                                                                            │
-- │ CHAT-WIDGET KEYMAPS (built-in defaults, buffer-local — not prefixed):      │
-- │   <CR> / <C-s>  Submit prompt        q                Hide widget          │
-- │   <C-c>         Stop generation (n)  <- added below via FileType autocmd    │
-- │   <S-Tab>       Switch agent mode    <localleader>s   Switch provider      │
-- │   <localleader>m  Switch model       <localleader>t   Thought level        │
-- │   <localleader>o  Options modal       <localleader>l   List sessions       │
-- │   <localleader>[ / ]  Prev/next session   <localleader>D  Destroy session  │
-- │   @file  File picker (snacks, see init)   /cmd  Slash commands             │
-- │   <localleader>p  Paste image   ]] / [[  Next/prev heading                 │
-- │   ]t / [t  Next/prev tool call    ]c / [c  Next/prev diff hunk             │
-- ╰──────────────────────────────────────────────────────────────────────────╯

-- Toggle a single dedicated lightweight "quick-ask" session.
--
-- agentic has no built-in "toggle a specific named session", so we track the
-- lite session's key ourselves. Verified against the agentic API:
--   * Agentic.new_session({ provider = "kiro-lite" })  -> starts a session on a
--     named provider WITHOUT a picker (new_session reads opts.provider).
--   * SessionRegistry.show_session(key)                -> shows a session by key
--     in the current tab (internal, but stable).
--   * SessionRegistry.get(key) / .visible_here()       -> existence / visibility.
--   * new_session_with_provider() and select_session() ALWAYS show a picker and
--     take no usable target arg, so they are NOT used here.
local lite_session_key = nil
-- True only while WE are creating the lite session, so the
-- on_create_session_response hook records the right key (not sessions the user
-- created by other means).
local creating_lite = false

local function toggle_lite_chat()
    local agentic = require("agentic")
    local Registry = require("agentic.session_registry")
    local cur_tab = vim.api.nvim_get_current_tabpage()

    -- Do we still have a live lite session?
    local session = lite_session_key and Registry.get(lite_session_key) or nil
    if not session then
        lite_session_key = nil
    end

    if session then
        -- Visible in THIS tab -> toggle it off.
        local visible_here = session.widget
            and session.widget:get_visible_tab_id() == cur_tab
        if visible_here then
            session.widget:hide()
        else
            -- Live but hidden (or in another tab) -> bring it here.
            Registry.show_session(lite_session_key)
        end
        return
    end

    -- No lite session yet -> create one on the kiro-lite provider (no picker),
    -- without auto-adding the current file/selection (quick-ask = clean prompt).
    creating_lite = true
    local ok = pcall(agentic.new_session, {
        provider = "kiro-lite",
        auto_add_to_context = false,
    })
    if not ok then
        creating_lite = false
        vim.notify(
            "[agentic] Could not start Kiro Lite session",
            vim.log.levels.ERROR
        )
    end
end

-- Restore a saved Kiro conversation by ID.
--
-- WHY THIS EXISTS: agentic's built-in restore_session() (<leader>ir) asks the
-- ACP agent to LIST its sessions. kiro-cli's ACP agent does not implement that
-- method, so <leader>ir errors with "Agent does not support listing sessions".
-- But kiro persists every conversation on disk per-cwd anyway, and
-- `kiro-cli chat --list-sessions` can read them. So we list via the CLI here,
-- then hand the chosen sessionId to restore_session_by_id(), which loads a
-- session directly and does NOT require the agent to support listing.
--
-- `kiro-cli chat --list-sessions --format json` returns an array of
--   { cwd = ..., sessions = { { sessionId, title, updatedAt, messageCount,
--   status }, ... }, complete = ... }
-- envelopes (one per cwd; a single entry for the current cwd unless --all-cwds).
--
-- @param all_cwds boolean|nil When true, pass --all-cwds to span every
--   workspace (local stores only) instead of just the current directory.
local function restore_kiro_session(all_cwds)
    local cmd = { "kiro-cli", "chat", "--list-sessions", "--format", "json" }
    if all_cwds then
        cmd[#cmd + 1] = "--all-cwds"
    end

    vim.system(
        cmd,
        { text = true },
        vim.schedule_wrap(function(out)
            if out.code ~= 0 then
                vim.notify(
                    "[agentic] kiro-cli --list-sessions failed: "
                        .. (out.stderr or ""),
                    vim.log.levels.ERROR
                )
                return
            end

            local ok, envelopes = pcall(vim.json.decode, out.stdout)
            if not ok or type(envelopes) ~= "table" then
                vim.notify(
                    "[agentic] Could not parse session list",
                    vim.log.levels.ERROR
                )
                return
            end

            -- Flatten every cwd envelope's sessions into one list.
            local sessions = {}
            for _, env in ipairs(envelopes) do
                for _, s in ipairs(env.sessions or {}) do
                    if s.sessionId then
                        sessions[#sessions + 1] = s
                    end
                end
            end

            if #sessions == 0 then
                vim.notify(
                    all_cwds
                            and "[agentic] No saved Kiro sessions found"
                        or "[agentic] No saved Kiro sessions for this directory",
                    vim.log.levels.INFO
                )
                return
            end

            -- Most-recently-updated first.
            table.sort(sessions, function(a, b)
                return (a.updatedAt or "") > (b.updatedAt or "")
            end)

            vim.ui.select(sessions, {
                prompt = all_cwds and "Restore Kiro session (all dirs):"
                    or "Restore Kiro session:",
                format_item = function(s)
                    local title = s.title
                    if not title or title == "" or title == "(no title)" then
                        title = "(no title)"
                    end
                    -- YY-MM-DD from the ISO updatedAt (drop the "20" century),
                    -- if present.
                    local date = (s.updatedAt or ""):sub(3, 10)
                    local count = s.messageCount or 0
                    return string.format(
                        "[%s, %d msgs]  %s",
                        date ~= "" and date or "?",
                        count,
                        title
                    )
                end,
            }, function(choice)
                if choice then
                    require("agentic").restore_session_by_id(choice.sessionId)
                end
            end)
        end)
    )
end

return {
    "carlos-algms/agentic.nvim",
    ---@type agentic.PartialUserConfig
    opts = {
        -- Default provider that launches `kiro-cli acp`.
        provider = "kiro-acp",

        -- Custom lightweight provider for the quick-ask chat: same kiro-cli acp,
        -- but pinned to the cheapest customer-safe model (qwen3-coder-next,
        -- 0.05x credits) and low effort. ~20x cheaper than the default "auto".
        acp_providers = {
            -- Default provider pinned to Claude Sonnet 5.5 (was plain
            -- `kiro-cli acp` = Auto). Overrides the built-in kiro-acp so new
            -- default sessions use a known model instead of server-selected.
            ["kiro-acp"] = {
                name = "Kiro (Claude Sonnet 5.5)",
                command = "kiro-cli",
                args = { "acp", "--model", "claude-sonnet-5.5" },
                env = {},
                initial_model = "claude-sonnet-5.5",
            },
            ["kiro-lite"] = {
                name = "Kiro Lite (quick-ask)",
                command = "kiro-cli",
                args = { "acp", "--model", "qwen3-coder-next", "--effort", "low" },
                env = {},
                initial_model = "qwen3-coder-next",
                default_thought_level = "low",
            },
        },

        -- Only list agents whose CLI is actually installed in the provider
        -- picker (<leader>iN) and switcher (<leader>ip).
        provider_switcher = {
            hide_unhealthy_providers = true,
        },

        -- DISABLED: agentic's built-in @ picker scans the workspace with a
        -- SYNCHRONOUS `vim.fn.system` on the main loop (see scan_files() in
        -- lua/agentic/ui/file_picker.lua: rg/fd/git ls-files, glob fallback).
        -- On a large tree (e.g. a Yocto/repo workspace) that scan blocks all of
        -- Neovim until it finishes. Setting `enabled = false` skips FilePicker
        -- entirely (no omnifunc, no TextChangedI autocmd). We replace it with an
        -- async snacks-based @ trigger, wired up in the AgenticInput FileType
        -- autocmd below.
        -- (Alternative if you want the native completion menu back:
        --  `auto_trigger = false` keeps <Tab> completion but drops the
        --  scan-on-@; it still scans synchronously on the first <Tab>.)
        file_picker = {
            enabled = false,
        },

        -- Track the lightweight session's key so <leader>ic reuses it.
        hooks = {
            on_create_session_response = function(data)
                if data.err then
                    creating_lite = false
                    return
                end
                -- Only claim this session as "lite" if WE just launched it via
                -- toggle_lite_chat (creating_lite flag). Sessions the user
                -- starts by other means must not be captured here.
                if creating_lite then
                    lite_session_key = data.session_key
                    creating_lite = false
                end
            end,
        },
    },
    -- stylua: ignore
    keys = {
        { "<leader>ii", function() require("agentic").toggle() end,                           desc = "Toggle chat",             mode = { "n", "v" } },
        { "<leader>ic", toggle_lite_chat,                                                     desc = "Quick-ask chat (lite)",   mode = { "n" } },
        { "<leader>in", function() require("agentic").new_session() end,                      desc = "New session",             mode = { "n", "v" } },
        { "<leader>iN", function() require("agentic").new_session_with_provider() end,        desc = "New session (pick agent)", mode = { "n" } },
        { "<leader>ia", function() require("agentic").add_selection_or_file_to_context() end, desc = "Add file/selection",      mode = { "n", "v" } },
        { "<leader>irK", function() restore_kiro_session(true) end,                          desc = "Restore Kiro session (all dirs)", mode = { "n" } },
        { "<leader>irk", function() restore_kiro_session() end,                               desc = "Restore Kiro session (cwd)", mode = { "n" } },
        { "<leader>irr", function() require("agentic").restore_session() end,                 desc = "Restore session (native)", mode = { "n" } },
        { "<leader>is", function() require("agentic").select_session() end,                   desc = "Select session",          mode = { "n" } },
        { "<leader>ip", function() require("agentic").switch_provider() end,                  desc = "Switch provider",         mode = { "n" } },
        { "<leader>iL", function() require("agentic").rotate_layout() end,                     desc = "Rotate layout",           mode = { "n" } },
        { "<leader>id", function() require("agentic").add_current_line_diagnostics() end,     desc = "Add line diagnostic",     mode = { "n" } },
        { "<leader>iD", function() require("agentic").add_buffer_diagnostics() end,           desc = "Add all diagnostics",     mode = { "n" } },
    },
    init = function()
        -- Register the <leader>ir "Restore session" group label. This can't go
        -- in the `keys` field (LazyVim keymap specs have no `group` concept —
        -- groups are which-key-only), so we use which-key's CURRENT API,
        -- wk.add() (wk.register() is deprecated). Kept here so the plugin stays
        -- self-contained; pcall makes it a no-op if which-key isn't installed.
        local ok_wk, wk = pcall(require, "which-key")
        if ok_wk then
            wk.add({ { "<leader>ir", group = "Restore session", mode = "n" } })
        end

        -- Buffer-local <C-c> to stop generation, scoped to agentic widget buffers.
        -- Normal mode only, so it doesn't clash with insert-mode <C-c> (leave insert).
        -- agentic has no default binding for stop_generation(), so we add one here.
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "AgenticChat",
                "AgenticInput",
                "AgenticCode",
                "AgenticFiles",
                "AgenticDiagnostics",
            },
            callback = function(ev)
                vim.keymap.set("n", "<C-c>", function()
                    require("agentic").stop_generation()
                end, { buffer = ev.buf, desc = "Agentic: stop generation" })
            end,
            desc = "Agentic: bind <C-c> to stop_generation in widget buffers",
        })

        -- Replace agentic's disabled built-in @ picker with an ASYNC snacks
        -- files picker, scoped to the prompt buffer (AgenticInput). Typing @ in
        -- insert mode inserts the literal @ (kept, for consistency with agentic's
        -- convention in case they add @-handling later) and opens Snacks.picker.
        -- On confirm, the chosen file's cwd-relative path is inserted right after
        -- the @, yielding "@relative/path". No main-loop blocking, no freeze.
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "AgenticInput",
            callback = function(ev)
                vim.keymap.set("i", "@", function()
                    -- Insert the literal "@" first (kept as the trigger char).
                    vim.api.nvim_put({ "@" }, "c", false, true)

                    local ok, Snacks = pcall(require, "snacks")
                    if not ok or not Snacks.picker then
                        -- snacks unavailable: leave the bare "@" (no picker).
                        return
                    end

                    local target_buf = ev.buf
                    Snacks.picker.files({
                        confirm = function(picker, item)
                            picker:close()
                            if not item then
                                return
                            end
                            -- item.file is the picked path; make it cwd-relative.
                            local path = item.file or item.text
                            if not path then
                                return
                            end
                            local rel = vim.fn.fnamemodify(path, ":.")
                            -- Insert the path after the "@" at the cursor, in the
                            -- prompt buffer, and return to insert mode there.
                            if vim.api.nvim_buf_is_valid(target_buf) then
                                local win = vim.fn.bufwinid(target_buf)
                                if win ~= -1 then
                                    vim.api.nvim_set_current_win(win)
                                end
                                vim.api.nvim_put({ rel }, "c", false, true)
                                vim.cmd("startinsert!")
                            end
                        end,
                    })
                end, { buffer = ev.buf, desc = "Agentic: @ file picker (snacks)" })
            end,
            desc = "Agentic: snacks-backed @ file picker in the prompt buffer",
        })
    end,
}
