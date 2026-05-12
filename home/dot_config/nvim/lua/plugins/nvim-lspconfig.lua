return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            -- TODO: Need to check how original mappings look like, becuase these ones cause problems
            ["*"] = {
                keys = {
                    {
                        vim.g.lspLeader .. "ai",
                        "<cmd>Telescope hierarchy incoming_calls<cr>",
                        desc = "[h]ierarchy - incoming calls",
                    },
                    {
                        vim.g.lspLeader .. "ao",
                        "<cmd>Telescope hierarchy outgoing_calls<cr>",
                        desc = "[H]ierarchy - outgoing calls",
                    },
                    -- { "<leader>ca",   vim.lsp.buf.code_action,        desc = "Code Action", mode = {'n', 'x'}, has = "codeAction" },              -- #lazy_default
                    -- { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },                                                           -- #lazy_default
                    -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", has = "definition" },                       -- #lazy_default
                    -- { 'gD',           vim.lsp.buf.declaration,        desc  = "Goto declaration" },                                               -- #lazy_default
                    -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },                               -- #lazy_default
                    -- { "gK", function()                                                                                                            -- #lazy_default
                    --             return vim.lsp.buf.signature_help()
                    --         end,                                      desc = "Signature Help<>", has = "signatureHelp" },
                    -- { "<c-k>", function()                                                                                                         -- #lazy_default
                    --                return vim.lsp.buf.signature_help()
                    --            end, mode = "i",                       desc = "Signature Help", has = "signatureHelp" },
                    -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },                                   -- #lazy_default
                    -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },                                  -- #lazy_default
                    -- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming", has = "callHierarchy/incomingCalls" }, -- #lazy_default
                    -- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing", has = "callHierarchy/outgoingCalls" }, -- #lazy_default

                    -- { 'gss',          vim.lsp.buf.document_symbol,    desc  = "Symbols (document)<>", has = "documentSymbol" },            -- previous: 'gs'
                    -- { 'gsS',          vim.lsp.buf.workspace_symbol,   desc  = "Symbols (workspace)<>", has = "workspace/symbols" },        -- previous: 'gs'
                    -- map.map('n', ll .. 'wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = "[l]ist", buffer = buffer })
                    -- map.map('n', ll .. 'F',  function() vim.lsp.buf.format { async = true } end, { desc = "[F]ormat", buffer = buffer })
                    -- map.map('n', ll .. 'wa',    vim.lsp.buf.add_workspace_folder,    { desc  = "[a]dd", buffer = buffer })
                    -- map.map('n', ll .. 'wr',    vim.lsp.buf.remove_workspace_folder, { desc  = "[r]emove", buffer = buffer })

                    -- Copied from lazyvim config files (defaults)
                    -- { "<leader>ca",  vim.lsp.buf.code_action,                    desc = "Code Action",                mode = { "n", "x" }, has = "codeAction" },
                    -- { "<leader>cc",  vim.lsp.codelens.run,                       desc = "Run Codelens",               mode = { "n", "x" }, has = "codeLens" },
                    -- { "<leader>cC",  vim.lsp.codelens.refresh,                   desc = "Refresh & Display Codelens", mode = { "n" },      has = "codeLens" },
                    -- { "<leader>cR",  function() Snacks.rename.rename_file() end, desc = "Rename File",                mode = { "n" },      has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
                    -- { "<leader>cr",  vim.lsp.buf.rename,                         desc = "Rename",                                          has = "rename" },
                    -- { "<leader>cA",  LazyVim.lsp.action.source,                  desc = "Source Action",                                   has = "codeAction" },
                },
            },
            -- TODO: Create template server config file
            -- basedpyright = {
            --     settings = {
            --         basedpyright = {
            --             python = {
            --                 pythonPath = "/usr/bin/python",
            --             },
            --             analysis = {
            --                 typeCheckingMode = "off",  -- or "off"
            --                 reportMissingTypeStubs = false,
            --                 reportUnknownMemberType = false,
            --                 reportUnknownVariableType = false,
            --             },
            --         }
            --     },
            -- }
            clangd = {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=LLVM",
                    "--query-driver=/usr/bin/gcc,/usr/bin/g++",
                },
            },
        },
    },
}
