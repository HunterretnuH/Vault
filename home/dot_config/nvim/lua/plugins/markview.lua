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
                    marker_minus       = { add_padding = false },
                    marker_plus        = { add_padding = false },
                    marker_star        = { add_padding = false },
                    marker_dot         = { add_padding = false },
                    marker_parenthesis = { add_padding = false },
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
