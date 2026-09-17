-- ╭──────────────────────────────────────────────────────────────────────────╮
-- │ codecompanion.nvim  (TEMPORARY test config — prefix <leader>n)             │
-- │ https://github.com/olimorris/codecompanion.nvim                            │
-- ╞══════════════════════════════════════════════════════════════════════════╡
-- │ Two adapters configured:                                                   │
-- │   • ollama (HTTP chat) -> local LLM at 192.168.0.3:11434 (from parrot.nvim)│
-- │       NOTE: only reachable on the LAN/VLAN where that host lives.          │
-- │   • kiro   (ACP agent) -> runs `kiro-cli acp` (this assistant).            │
-- │ Default chat adapter = ollama (plain chat, as requested for testing).      │
-- │ Switch adapter inside a chat buffer with `ga`.                             │
-- ╞══════════════════════════════════════════════════════════════════════════╡
-- │ GLOBAL KEYMAPS (defined here, all under <leader>n = "AI (codecompanion)")  │
-- │   <leader>nn  Toggle chat window                                           │
-- │   <leader>na  Action palette                                               │
-- │   <leader>ni  Inline prompt (n + v)                                        │
-- │   <leader>nc  Add code/selection to chat (v)                               │
-- │   <leader>nk  New chat with Kiro (ACP) adapter                             │
-- │   <leader>no  New chat with Ollama adapter                                 │
-- │                                                                            │
-- │ CHAT-BUFFER KEYMAPS (built-in defaults, buffer-local — not prefixed):      │
-- │   <CR> / <C-s>  Send message          q         Close chat                 │
-- │   ga            Change adapter        gm        Change model               │
-- │   gr            Regenerate response   gc        Insert codeblock           │
-- │   gs            Toggle system prompt  gx        Clear chat                  │
-- │   gd            Debug window          gta       Toggle auto-tool mode      │
-- │   #{var}        Variables   /cmd  Slash commands   @tool  Tools            │
-- ╰──────────────────────────────────────────────────────────────────────────╯

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    -- stylua: ignore
    keys = {
        { "<leader>nn", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle chat",             mode = { "n", "v" } },
        { "<leader>na", "<cmd>CodeCompanionActions<cr>",     desc = "Action palette",          mode = { "n", "v" } },
        { "<leader>ni", "<cmd>CodeCompanion<cr>",            desc = "Inline prompt",           mode = { "n", "v" } },
        { "<leader>nc", "<cmd>CodeCompanionChat Add<cr>",    desc = "Add selection to chat",   mode = { "v" } },
        { "<leader>nk", "<cmd>CodeCompanionChat kiro<cr>",   desc = "New chat (Kiro ACP)",     mode = { "n" } },
        { "<leader>no", "<cmd>CodeCompanionChat ollama<cr>", desc = "New chat (Ollama)",       mode = { "n" } },
    },
    opts = {
        adapters = {
            http = {
                -- Local Ollama, mirroring the parrot.nvim setup.
                -- The built-in ollama adapter appends `/api/chat` to `env.url`.
                ollama = function()
                    return require("codecompanion.adapters").extend("ollama", {
                        env = {
                            url = "http://192.168.0.3:11434",
                        },
                        headers = {
                            ["Content-Type"] = "application/json",
                        },
                        parameters = {
                            sync = true,
                        },
                        schema = {
                            model = {
                                default = "qwen2.5-coder:14b",
                            },
                            num_ctx = {
                                default = 8192,
                            },
                        },
                    })
                end,
            },
            -- ACP: `kiro` is a built-in adapter that runs `kiro-cli acp`.
            -- kiro-cli must be on PATH and logged in.
            acp = {
                kiro = function()
                    return require("codecompanion.adapters").extend("kiro", {})
                end,
            },
        },
        interactions = {
            -- Plain chat defaults to the local Ollama model for testing.
            chat = {
                adapter = "ollama",
            },
            inline = {
                adapter = "ollama",
            },
        },
        opts = {
            log_level = "ERROR", -- set "DEBUG"/"TRACE" to troubleshoot (see :checkhealth codecompanion)
        },
    },
}
