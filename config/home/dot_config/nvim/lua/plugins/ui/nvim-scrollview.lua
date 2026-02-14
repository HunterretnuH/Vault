return {
    'dstein64/nvim-scrollview',
    lazy = false,
    config = function()
        local function setup_scrollview()
            local hlFoldColumn = vim.api.nvim_get_hl(0, { name = "FoldColumn" })
            local hl_cursearch = vim.api.nvim_get_hl(0, { name = "CurSearch" })

            vim.api.nvim_set_hl(0, "ScrollView",       { bg = hlFoldColumn.fg }) -- scroll bar
            vim.api.nvim_set_hl(0, "ScrollViewCursor", { fg = hlFoldColumn.fg }) -- cursor position
            vim.api.nvim_set_hl(0, "ScrollViewSearch", { fg = hl_cursearch.bg }) -- search occurances
            vim.api.nvim_set_hl(0, "ScrollViewMarks",  { bg = "Blue", fg = "Red" })

            vim.api.nvim_set_hl(0, "ScrollViewDiagnosticsError", { link = "DiagnosticError" })
            vim.api.nvim_set_hl(0, "ScrollViewDiagnosticsHint",  { link = "DiagnosticHint" })
            vim.api.nvim_set_hl(0, "ScrollViewDiagnosticsInfo",  { link = "DiagnosticInfo" })
            vim.api.nvim_set_hl(0, "ScrollViewDiagnosticsWarn",  { link = "DiagnosticWarn" })

            require('scrollview').setup({
                excluded_filetypes = {'NvimTree'},
                always_show = true,
                cursor_symbol = '▪',
                search_symbol = '🭹',
                diagnostics_error_symbol = '🭹',
                diagnostics_hint_symbol  = '🭹',
                diagnostics_info_symbol  = '🭹',
                diagnostics_warn_symbol  = '🭹',
                column = 1,
                signs_on_startup = {
                    'cursor',
                    'search',
                    'marks',
                    'diagnostics',
                    'conflicts',
                },
            })
        end
        vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_scrollview })
    end
}
-- TODO:
-- * check what other signs it may be worth to set
