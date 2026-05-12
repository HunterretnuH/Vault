return {
    { "MeanderingProgrammer/render-markdown.nvim", enabled = false },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,

        -- For `nvim-treesitter` users.
        priority = 49,

        -- For blink.cmp's completion source
        dependencies = {
            "saghen/blink.cmp",
            "nvim-mini/mini.icons",
        },
        keys = {
            { "<leader>um", function() vim.cmd("Markview toggle") end, desc = "Toggle Markdown Formating", },
        },
        opts = {

            provider = {
                icon_provider = "mini",
            },
            markdown = {
                list_items = {
                    -- Fix to remove first indent from lists
                    marker_minus = {
                        add_padding = function(_, item)
                            return item.indent > 1
                        end,
                    },
                    marker_plus = {
                        add_padding = function(_, item)
                            return item.indent > 1
                        end,
                    },
                    marker_star = {
                        add_padding = function(_, item)
                            return item.indent > 1
                        end,
                    },
                    -- Numbered lists
                    marker_dot = {
                        add_padding = function(_, item)
                            return item.indent > 1
                        end,
                    },
                },
                tables = {
                    parts = {
                        top = { "┌", "─", "┐", "┬" },
                        header = { "│", "│", "│" },
                        separator = { "├", "─", "┤", "┼" },
                        row = { "│", "│", "│" },
                        bottom = { "└", "─", "┙", "┴" },
                        overlap = { "┝", "━", "┥", "┿" },
                        align_left = "╼",
                        align_right = "╾",
                        align_center = { "╴", "╶" },
                    },
                },
            },
        },
    },
}
