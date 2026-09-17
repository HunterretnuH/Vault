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

            -- A mini.diff source that diffs the buffer against a fixed git
            -- revision (e.g. "HEAD", "HEAD^", a SHA/tag/branch) instead of the
            -- Git index (the default source's behaviour).
            --
            -- Structured like the built-in `MiniDiff.gen_source.git()`: it
            -- returns a source table whose `attach` sets reference text via
            -- `MiniDiff.set_ref_text()` and signals failure via
            -- `MiniDiff.fail_attach()`.
            local function git_rev_source(rev)
                local attach = function(buf_id)
                    local md = require("mini.diff")
                    local file = vim.api.nvim_buf_get_name(buf_id)
                    if file == "" then
                        return md.fail_attach(buf_id)
                    end

                    -- Operate inside the repo that actually contains the file
                    -- (handles nested repos/submodules correctly).
                    local dir = vim.fs.dirname(file)

                    -- Path relative to that repo's root, as `git show` expects.
                    local rel = vim.fn.systemlist({
                        "git", "-C", dir, "ls-files", "--full-name", "--", file,
                    })[1]
                    if vim.v.shell_error ~= 0 or not rel or rel == "" then
                        vim.notify(
                            ("mini.diff: `%s` is not tracked in its git repo"):format(vim.fs.basename(file)),
                            vim.log.levels.WARN
                        )
                        return md.fail_attach(buf_id)
                    end

                    local ref = vim.fn.systemlist({
                        "git", "-C", dir, "show", rev .. ":" .. rel,
                    })
                    if vim.v.shell_error ~= 0 then
                        vim.notify(
                            ("mini.diff: `git show %s:%s` failed"):format(rev, rel),
                            vim.log.levels.ERROR
                        )
                        return md.fail_attach(buf_id)
                    end

                    md.set_ref_text(buf_id, ref)
                end

                return { name = "git-" .. rev, attach = attach }
            end

            -- Switch the current buffer's mini.diff source to `git_rev_source(rev)`
            -- (or back to the default index source when `rev` is nil), then make
            -- sure the overlay is visible.
            local function diff_to_rev(rev)
                local md = require("mini.diff")

                if vim.g.minidiff_disable then
                    toggle_minidiff()
                end

                local buf = vim.api.nvim_get_current_buf()

                -- Override the buffer-local source (merged over global config by
                -- mini.diff), then disable+enable to re-attach with it.
                local buf_config = vim.b[buf].minidiff_config or {}
                if rev and rev ~= "" then
                    buf_config.source = git_rev_source(rev)
                else
                    buf_config.source = nil -- fall back to default (git index)
                end
                vim.b[buf].minidiff_config = buf_config

                if md.get_buf_data(buf) then
                    md.disable(buf)
                end
                md.enable(buf)

                -- Show overlay (enable() attached the source synchronously, but
                -- ref text may arrive on a schedule; toggling overlay state is
                -- safe here because the buffer is now enabled).
                local data = md.get_buf_data(buf)
                if data and not data.overlay then
                    md.toggle_overlay(buf)
                end
            end

            return {
                { "<leader>doo", function() require("mini.diff").toggle_overlay(0) end, desc = "Toggle overlay" },
                { "<leader>doO", toggle_minidiff, desc = "Toggle overlay (enable/disable mini.diff)" },
                { "<leader>do^", function() diff_to_rev("HEAD^") end, desc = "Diff vs HEAD^" },
                {
                    "<leader>dor",
                    function()
                        vim.ui.input({ prompt = "mini.diff — diff against git rev: " }, function(rev)
                            if rev and rev ~= "" then
                                diff_to_rev(rev)
                            end
                        end)
                    end,
                    desc = "Diff vs custom revision",
                },

                -- Hunk navigation for mini.diff's own diff (e.g. the vs-revision
                -- overlay). gitsigns owns `]h`/`[h`, but those navigate the
                -- index diff and can't move through mini.diff's rev-based hunks,
                -- so use `]H`/`[H` for mini.diff hunks.
                { "]H", function() require("mini.diff").goto_hunk("next") end, desc = "Next hunk (mini.diff)" },
                { "[H", function() require("mini.diff").goto_hunk("prev") end, desc = "Prev hunk (mini.diff)" },
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
