return {
    {
        "mfussenegger/nvim-dap",
        opts = function()
            local dap = require("dap")
            local config = require("config.dap.dap")()

            -- Merge Adapters
            dap.adapters = vim.tbl_deep_extend("force", dap.adapters or {}, config.adapters or {})

            -- Merge Configurations
            for lang, configs in pairs(config.configurations or {}) do
                -- Initialize the lang table if it doesn't exist
                dap.configurations[lang] = dap.configurations[lang] or {}
                -- Use list_extend to append your custom configs to the existing ones
                vim.list_extend(dap.configurations[lang], configs)
            end
        end,
        keys = function()
            local dl = vim.g.debugLeader

            local dap_set_breakpoint_cond = function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end
            local dap_set_breakpoint_log = function()
                require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end

            local wk_ok, wk = pcall(require, "which-key")
            if wk_ok then
                wk.add({ dl .. "p", group = "PROGRAM" })
                wk.add({ dl .. "b", group = "BREAKPOINT" })
                wk.add({ dl .. "s", group = "STEP/STACK" })
            end

            return {
                { dl .. "c",  function() require("dap").continue() end,              desc = "Continue",                 silent = true }, -- c
                { dl .. "C",  function() require("dap").reverse_continue() end,      desc = "Continue reverse",         silent = true }, -- -
                { dl .. "r",  function() require("dap").repl.toggle() end,           desc = "Repl toggle",              silent = true }, -- r
                -- BREAKPOINTS
                { dl .. "b",  function() require("dap").toggle_breakpoint() end,     desc = "Breakpoint toggle",        silent = true }, -- b
                { dl .. "bb", function() require("dap").toggle_breakpoint() end,    desc = "Breakpoint toggle",        silent = true }, -- b
                { dl .. "bL", function() require("dap").list_breakpoints() end,     desc = "List breakpoints",         silent = true }, -- -
                { dl .. "bC", function() require("dap").clear_breakpoints() end,    desc = "Clear breakpoints",        silent = true }, -- -
                { dl .. "bc", dap_set_breakpoint_cond,  desc = "Conditional breakpoint",   silent = true }, -- B
                { dl .. "bl", dap_set_breakpoint_log,   desc = "Logging breakpoint",       silent = true }, -- -
                -- PROGRAM
                -- TODO: Some program mappings are probably not necessary, because they show in interface i.e. when program finishes execution
                { dl .. "pd", function() require("dap").disconnect() end,           desc = "Disconnect from debugger", silent = true }, -- -
                { dl .. "pR", function() require("dap").restart() end,              desc = "Restart program",          silent = true }, -- -
                { dl .. "pt", function() require("dap").terminate() end,            desc = "Terminate program",        silent = true }, -- t
                { dl .. "pg", function() require("dap").goto_() end,                desc = "Go to Line (No Execute)",  silent = true }, -- g
                { dl .. "pp", function() require("dap").pause() end,                desc = "Pause",                    silent = true }, -- P
                { dl .. "pc", function() require("dap").run_to_cursor() end,        desc = "Run to Cursor",            silent = true }, -- C
                { dl .. "pr", function() require("dap").run_last() end,             desc = "Run last program",         silent = true }, -- l
                { dl .. "ps", function() require("dap").session() end,              desc = "Session",                  silent = true }, -- s
                -- STEP/STACK
                { dl .. "su", function() require("dap").up() end,                   desc = "Up stack frame",           silent = true }, -- k
                { dl .. "sd", function() require("dap").down() end,                 desc = "Down stack frame",         silent = true }, -- j
                { dl .. "so", function() require("dap").step_over() end,            desc = "Over",                     silent = true }, -- O
                { dl .. "sb", function() require("dap").step_back() end,            desc = "Back",                     silent = true }, -- -
                { dl .. "si", function() require("dap").step_into() end,            desc = "Into",                     silent = true }, -- i
                { dl .. "sO", function() require("dap").step_out() end,             desc = "Out",                      silent = true }, -- o
                { dl .. "sr", function() require("dap").restart_frame() end,        desc = "Restart frame",            silent = true }, -- -
                { dl .. "<Up>", function() require("dap").step_out() end,           desc = "Step out",                 silent = true }, -- -
                { dl .. "<Down>", function() require("dap").step_into() end,        desc = "Setp into",                silent = true }, -- -
                { dl .. "<Left>", function() require("dap").step_back() end,        desc = "Step back",                silent = true }, -- -
                { dl .. "<Right>", function() require("dap").step_over() end,       desc = "Step over",                silent = true }, -- -
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        keys = function()
            local dl = vim.g.debugLeader

            return {
                { dl .. "\\", function() require("dapui").toggle() end, desc = "Toggle Dap UI", silent = true, }, -- u
                { dl .. "e", function() require("dapui").eval() end, desc = "Evaluate symbol under cursor", mode = { "n", "v" }, silent = true, }, -- e
                { dl .. "P", function() require("dap.ui.widgets").preview() end, desc = "Preview", mode = { "n", "v" }, silent = true, }, -- -
            }
        end,
    },
    {
        "Jorenar/nvim-dap-disasm",
        dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" }, --nvim-dap-ui is optional, but required for my config
        lazy = true,
        keys = function()
            local dl = vim.g.debugLeader

            local wk_ok, wk = pcall(require, "which-key")
            if wk_ok then
                wk.add({ dl .. "i", group = "INSTRUCTION" })
            end

            return {
                { dl .. "d", "<cmd>DapDisasm<cr>", desc = "Disassmebly view" },
                { dl .. "io", function() require("dap-disasm").step_over() end, desc = "Over" },
                { dl .. "ii", function() require("dap-disasm").step_into() end, desc = "Into" },
                { dl .. "ib", function() require("dap-disasm").step_back() end, desc = "Back" },
            }
        end,
        config = function()
            require("dap-disasm").setup({})
        end,
    },
}

-- TODO: Some other mappings to condsider and add or remove note
-- TO CONSIDER ADDING OR CHANGING LATER:
-- dl .. 'bt' -> dap.set_breakpoint(nil, nil, nil, true) - temporary breakpoints
-- dl .. 'be' -> toggle exception breakpoints (dap.set_exception_breakpoints({ "all" }))
-- dl .. 'uw' -> dapui.open({reset = true}) -- "[w]indows"
-- dl .. 'uc' -> dapui.close()              -- "[c]lose"
--     GROUPING WIDGETS
--     dl .. 'wh' -> hover
--     dl .. 'wp' -> preview
--     dl .. 'wf' -> frames
--     dl .. 'ws' -> scopes
