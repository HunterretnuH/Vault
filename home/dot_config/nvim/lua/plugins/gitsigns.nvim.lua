return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup {

            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')

                -- Navigation
                vim.keymap.set('n', ']h', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        gitsigns.nav_hunk('next')
                    end
                end, { desc = "Next hunkg", buffer = bufnr })

                vim.keymap.set('n', '[h', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end, { desc = "Prev hunkg", buffer = bufnr })

                -- Actions
                vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk,          { desc = "Stage hunkg", buffer = bufnr })
                vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk,          { desc = "Reset hunkg", buffer = bufnr })

                vim.keymap.set('v', '<leader>hs', function()
                    gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end,                                                            { desc = "Stage hunkg", buffer = bufnr })

                vim.keymap.set('v', '<leader>hr', function()
                    gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end,                                                            { desc = "Reset hunkg", buffer = bufnr }
                )

                vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer,        { desc = "Stage bufferg",        buffer = bufnr })
                vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer,        { desc = "Reset bufferg",        buffer = bufnr })
                vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk,        { desc = "Preview hunkg",        buffer = bufnr })
                vim.keymap.set('n', '<leader>hP', gitsigns.preview_hunk_inline, { desc = "Preview hunk inlineg", buffer = bufnr })
                vim.keymap.set('n', '<leader>hB', gitsigns.blame,               { desc = "Blame - current fileg", buffer = bufnr })

                vim.keymap.set('n', '<leader>hb', function()
                    gitsigns.blame_line({ full = true })
                end,                                                            { desc = "Blame - current lineg", buffer = bufnr })

                vim.keymap.set('n', '<leader>hd', gitsigns.diffthis,            { desc = "Diff fileg",            buffer = bufnr })

                vim.keymap.set('n', '<leader>hD', function()
                    gitsigns.diffthis('~')
                end,                                                            { desc = "Ddiff ??g",             buffer = bufnr })

                vim.keymap.set('n', '<leader>hQ', function()
                    gitsigns.setqflist('all')
                end,                                                            { desc = "Qflist send allg",      buffer = bufnr })

                vim.keymap.set('n', '<leader>hq', gitsigns.setqflist,           { desc = "Qflist send hunkg",     buffer = bufnr })
                vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk,     { desc = "Undo stage hunkg",      buffer = bufnr })
                vim.keymap.set('n', '<leader>hc', ':Gitsigns change_base',      { desc = "Change baseg",          buffer = bufnr })

                -- Toggles
                vim.keymap.set('n', '<leader>htb',
                        gitsigns.toggle_current_line_blame,                     { desc = "Blame - current lineg", buffer = bufnr })

                vim.keymap.set('n', '<leader>htw', gitsigns.toggle_word_diff,   { desc = "Word diffg",           buffer = bufnr })

                -- Text object
                vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk,        { desc = "In chunk - selectg",    buffer = bufnr })

            end
        }
    end
}
