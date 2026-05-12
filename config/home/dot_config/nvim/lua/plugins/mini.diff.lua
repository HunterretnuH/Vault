return {
    {
        "nvim-mini/mini.diff",
        lazy = true,
        keys = function()
            local function toggle_minidiff()
                vim.g.minidiff_disable = not vim.g.minidiff_disable

                if vim.g.minidiff_disable then
                    vim.notify("`mini.diff` disabled", vim.log.levels.INFO)
                else
                    vim.notify("`mini.diff` enabled", vim.log.levels.INFO)
                end
            end

            local function open_minidiff_overlay()
                if vim.g.minidiff_disable then
                    toggle_minidiff()
                end

                require("mini.diff").toggle_overlay(0)
            end

            return {
                { "<leader>do", open_minidiff_overlay, desc = "Overlay toggle (mini.diff)<>" },
                { "<leader>dO", toggle_minidiff, desc = "Overlay toggle - enable/disable mini.diff<>" },
            }
        end,
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
    },
    -- lualine integration
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            local x = opts.sections.lualine_x
            for _, comp in ipairs(x) do
                if comp[1] == "diff" then
                    comp.source = function()
                        local summary = vim.b.minidiff_summary
                        return summary
                            and {
                                added = summary.add,
                                modified = summary.change,
                                removed = summary.delete,
                            }
                    end
                    break
                end
            end
        end,
    },
}
