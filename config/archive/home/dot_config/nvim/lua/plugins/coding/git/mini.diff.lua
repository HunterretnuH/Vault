return {
    'nvim-mini/mini.diff',
    lazy = false,
    keys = function()
        local map = require('map')
        map.map('n', '<leader>do', function() require('mini.diff').toggle_overlay(0) end, { desc = "[o]verlay - mini.diff" })
        return map.exportKeys()
    end,
    config = function() require('mini.diff').setup() end,
    opts = {
        view = {
            -- Visualization style. Possible values are 'sign' and 'number'.
            -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
            style = vim.go.number and "number" or "sign",
        },
        -- Module mappings. Use `''` (empty string) to disable one.
        -- NOTE: Disabled, because gitsigns.nvim provides all such functionality and more
        mappings = {
            -- Apply hunks inside a visual/operator region
            apply = "",

            -- Reset hunks inside a visual/operator region
            reset = "",

            -- Hunk range textobject to be used inside operator
            -- Works also in Visual mode if mapping differs from apply and reset
            textobject = "",

            -- Go to hunk range in corresponding direction
            goto_first = "",
            goto_prev = "",
            goto_next = "",
            goto_last = "",
        },
    },
}

-- TODO: Consider mappings for mini.diff.operator, see: `MiniDiff.operator` in help.


-- From Help:
-- # Mappings ~
--
-- This module provides mappings for common actions with diffs, like:
-- - Apply and reset hunks.
-- - "Hunk range under cursor" textobject.
-- - Go to first/previous/next/last hunk range.
--
-- Examples:
-- - `vip` followed by `gh` / `gH` applies/resets hunks inside current paragraph.
--   Same can be achieved in operator form `ghip` / `gHip`, which has the
--   advantage of being dot-repeatable (see |single-repeat|).
-- - `gh_` / `gH_` applies/resets current line (even if it is not a full hunk).
-- - `ghgh` / `gHgh` applies/resets hunk range under cursor.
-- - `dgh` deletes hunk range under cursor.
-- - `[H` / `[h` / `]h` / `]H` navigate cursor to the first / previous / next / last
--   hunk range of the current buffer.
