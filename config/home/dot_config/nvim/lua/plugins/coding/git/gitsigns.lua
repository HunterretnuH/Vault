return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup {

            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')
                local map = require('map')

                -- Navigation
                map.map('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        gitsigns.nav_hunk('next')
                    end
                end, { desc = "[c]onflict next - hunk", buffer = bufnr })

                map.map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end, { desc = "[c]onflict prev - hunk", buffer = bufnr })

                -- Actions
                map.map('n', '<leader>hs', gitsigns.stage_hunk, { desc = "[s]tage hunk", buffer = bufnr })
                map.map('n', '<leader>hr', gitsigns.reset_hunk, { desc = "[r]eset hunk", buffer = bufnr })

                map.map('v', '<leader>hs', function()
                    gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end, { desc = "[s]tage hunk", buffer = bufnr })

                map.map('v', '<leader>hr', function()
                    gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                end, { desc = "[r]eset hunk", buffer = bufnr })

                map.map('n', '<leader>hS', gitsigns.stage_buffer,        { desc = "[S]tage buffer",        buffer = bufnr })
                map.map('n', '<leader>hR', gitsigns.reset_buffer,        { desc = "[R]eset buffer",        buffer = bufnr })
                map.map('n', '<leader>hp', gitsigns.preview_hunk,        { desc = "[p]review hunk",        buffer = bufnr })
                map.map('n', '<leader>hP', gitsigns.preview_hunk_inline, { desc = "[P]review hunk inline", buffer = bufnr })
                map.map('n', '<leader>hB', gitsigns.blame,               { desc = "[B]lame - current file", buffer = bufnr })

                map.map('n', '<leader>hb', function()
                    gitsigns.blame_line({ full = true })
                end,                                                     { desc = "[b]lame - current line", buffer = bufnr })

                map.map('n', '<leader>hd', gitsigns.diffthis,            { desc = "[d]iff file",            buffer = bufnr })

                map.map('n', '<leader>hD', function()
                    gitsigns.diffthis('~')
                end,                                                     { desc = "[D]diff ??",             buffer = bufnr })

                map.map('n', '<leader>hQ', function()
                    gitsigns.setqflist('all')
                end,                                                     { desc = "[Q]flist send all",      buffer = bufnr })

                map.map('n', '<leader>hq', gitsigns.setqflist,           { desc = "[q]flist send hunk",     buffer = bufnr })
                map.map('n', '<leader>hu', gitsigns.undo_stage_hunk,     { desc = "[u]ndo stage hunk",      buffer = bufnr })
                map.map('n', '<leader>hc', ':Gitsigns change_base',      { desc = "[c]hange base",          buffer = bufnr })

                -- Toggles
                require('map').group('<leader>ht',                       { group = "[t]oggle" })
                map.map('n', '<leader>htb',
                        gitsigns.toggle_current_line_blame,              { desc = "[b]lame - current line", buffer = bufnr })

                map.map('n', '<leader>htw', gitsigns.toggle_word_diff,   { desc = "[w]word diff",           buffer = bufnr })

                -- Text object
                map.map({ 'o', 'x' }, 'ih', gitsigns.select_hunk,        { desc = "[i]n chunk - select",    buffer = bufnr })

            end
        }
    end
}

-- TODO: Add keybindings and integrate with mini.diff
