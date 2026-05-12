-- Manual link: https://cmp.saghen.dev/installation
return {
    "saghen/blink.cmp",
    opts = {
        signature = { enabled = true },
        keymap = {
            preset = "super-tab",
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" },
            -- Fix for Tab completion in CMD Window opening built-in completion
            ["<Tab>"] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.accept()
                    else
                        return cmp.select_and_accept()
                    end
                end,
                "snippet_forward",
                function(cmp)
                    if vim.fn.getcmdwintype() ~= "" then
                        return cmp.show()
                    end
                end,
                function(cmp)
                    if vim.fn.getcmdwintype() ~= "" then
                        return cmp.show_documentation()
                    end
                end,
                function(cmp)
                    if vim.fn.getcmdwintype() ~= "" then
                        return cmp.hide_documentation()
                    else
                        return
                    end
                end,
                "fallback",
            },
        },
        cmdline = {
            completion = {
                menu = {
                    auto_show = function(ctx)
                        return vim.fn.getcmdtype() == ":" or vim.fn.getcmdwintype() == ":"
                    end,
                },
            },
        },
    },
}
