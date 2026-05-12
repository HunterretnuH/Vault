return {
    "lervag/wiki.vim",
    -- dependencies = { 'preservim/vim-markdown' }, -- my own custom dependency
    -- tag = "v0.10", -- uncomment to pin to a specific release
    keys = function()
        local env = require("env")
        require("lazy").load({ plugins = { "wiki.vim" } })
        return  {
            { "<leader>Ww", ":e " .. env.wiki.primary_wiki_path .. "index.md<CR>",
              desc = "Wiki<>", silent = true },
        }
    end,
    config = function()
        --#1 Set additional keymaps
        vim.keymap.set("n", "<leader>Wi", ":WikiIndex<CR>",         { desc = "Index<>", silent = true })
        vim.keymap.set("n", "<leader>Wp", ":WikiPages<CR>",         { desc = "Pages list<>", silent = true })
        vim.keymap.set("n", "<leader>Wt", ":WikiToc<CR>",           { desc = "Table of content<>", silent = true })
        vim.keymap.set("n", "<leader>WT", ":WikiTags<CR>",          { desc = "Tags list<>", silent = true })
        vim.keymap.set("n", "<leader>Wj", ":WikiJournal<CR>",       { desc = "Journal<>", silent = true })
        vim.keymap.set("n", "<leader>WJ", ":WikiJournalIndex<CR>",  { desc = "Journal index<>", silent = true })
        vim.keymap.set("n", "<leader>Wo", ":WikiOpen<CR>",  { desc = "Wiki open<>", silent = true })

        --#1 Autocommands executed for wiki buffers
        function wiki_buf_save_last_idx()
                Last_wiki_buf = Current_wiki_buf
                Current_wiki_buf = vim.api.nvim_get_current_buf()
        end
        function wiki_buf_delete_last()
                local current = vim.api.nvim_get_current_buf()
                if Last_wiki_buf and Last_wiki_buf ~= current then
                    local buf = Last_wiki_buf
                    vim.schedule(function()
                        if
                            vim.api.nvim_buf_is_valid(buf)
                            and vim.api.nvim_buf_is_loaded(buf)
                            and vim.fn.bufwinnr(buf) == -1
                        then
                            vim.cmd("bdelete " .. buf)
                        end
                    end)
                end -- update tracker to new buffer
                Last_wiki_buf = current
        end
        vim.api.nvim_create_augroup("MyWikiAutocmdsGroup", { clear = true })
        vim.api.nvim_create_autocmd("User", {
            pattern = "WikiBufferInitialized",
            group = "MyWikiAutocmdsGroup",
            callback = function()
                vim.keymap.set( { "n", "v", "o" }, "<localleaderj", "<plug>(wiki-link-next)",
                    { desc = "Next link<>", buffer = true }
                )
                vim.keymap.set( { "n", "v", "o" }, "<localleader>k", "<plug>(wiki-link-prev)",
                    { desc = "Previous link<>", buffer = true }
                )
                vim.keymap.set( { "n", "v", "o" }, "<BS>", "<plug>(wiki-link-return)<cmd>lua wiki_buf_delete_last()<cr>",
                    { desc = "Previous page<>", buffer = true }
                )
                wiki_buf_save_last_idx()
            end,
        })
        -- TODO: Try changing to checking if file currently loaded in buffer is in wiki directory and if it is then
        -- call wiki_buf_delete_last. I can make autocmd on bufEnter to store last wiki buffer, then in such case 
        -- trigger could be changed to BufferLeave.
        vim.api.nvim_create_autocmd("User", {
            pattern = "WikiLinkFollowed",
            group = "MyWikiAutocmdsGroup",
            callback = wiki_buf_delete_last,
        })



        --#1 Special handling for markdown files
        -- fold fix source: https://github.com/OXY2DEV/markview.nvim/issues/242
        --#2 Foldtext function
        _G.md_foldtext = function()
            --- Get the plugin config.
            local spec_available, spec = pcall(require, "markview.spec")

            if spec_available == false then
                --- No config :(
                return ""
            end

            local from, to = vim.v.foldstart, vim.v.foldend
            --- The line where the fold starts.
            ---@type string
            local line = vim.api.nvim_buf_get_lines(0, from - 1, from, false)[1]

            if line:match("^%s*#+") then
                --- Only do this on headings.

                --- Before: Text before #.
                --- Marker: #
                --- content: Everything after #
                local before, marker, content = line:match("^([%s%>]*)(%#+)(.*)$")
                ---@type integer Heading level
                local level = marker:len()

                --- Heading configuration.
                ---@type headings.atx
                local config = spec.get({ "markdown", "headings", "heading_" .. level }, { fallback = {} })

                -- Append spaces equal to heading level
                before = (before or "") .. string.rep(" ", level)

                return {
                    { before, config.hl },

                    --- Same format as the renderer for ATX headings.
                    { config.corner_left or "", config.corner_left_hl or config.hl },
                    { config.padding_left or "", config.padding_left_hl or config.hl },
                    { config.icon or "", config.icon_hl or config.hl },
                    --- Do not include the space after #.
                    { content:gsub("^%s*", ""), config.hl },
                    { config.padding_right or "", config.padding_right_hl or config.hl },
                    { config.corner_right or "", config.corner_right_hl or config.hl },

                    --- Extra stuffs
                    { " " },
                    { "󰁂 " .. (to - from), "MarkviewPalette5Fg" },
                }
            else
                return ""
            end
        end

        --#2 Foldexpr function
        local function inside_fenced_block(lnum)
            -- simple but reliable: count fences (```...) up to lnum
            -- odd => inside a fence
            local cnt = 0
            for i = 1, lnum do
                local l = vim.fn.getline(i)
                if l:match("^%s*```") then
                    cnt = cnt + 1
                end
            end
            return (cnt % 2 == 1)
        end

        _G.md_foldexpr = function()
            -- get the line for the current fold evaluation
            local line = vim.fn.getline(vim.v.lnum)

            if inside_fenced_block(vim.v.lnum) then
                return "="
            end

            -- If this is a blank line AND the next line is a heading → keep it visible
            if line:match("^%s*$") then
                local next_line = vim.fn.getline(vim.v.lnum + 1)
                local next_line_hashes = next_line:match("^%s*(#+)%s+")
                if next_line_hashes then
                    return #next_line_hashes
                else
                    return "="
                end
            end

            -- Headings: level = number of #
            local hashes = line:match("^%s*(#+)%s+")
            if hashes then
                return ">" .. tostring(#hashes)
            end

            return "="
        end

        --#2 Autocommands for markdown files
        -- TODO: Consider moving fodexpr etc. to markview.nvim config
        vim.api.nvim_create_autocmd(
            { "FileType" },
            {
                pattern = { "markdown" },
                callback = function()
                    --- Removes the •••••• part.
                    vim.opt_local.fillchars = "fold: "
                    vim.opt_local.textwidth = 120
                    vim.opt_local.colorcolumn = "121"
                    vim.opt_local.wrap = false
                    vim.opt_local.foldmethod = "expr"
                    --vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
                    vim.opt_local.foldexpr = "v:lua.md_foldexpr()"
                    vim.opt_local.foldtext = "v:lua.md_foldtext()"
                    vim.opt_local.foldlevel = 2
                    --vim.opt_local.foldcolumn = "auto:9"
                    vim.opt_local.conceallevel = 1
                    vim.opt_local.concealcursor = ""
                    vim.schedule(function()
                        vim.opt_local.spell = false
                        vim.opt_local.wrap = false
                    end)
                end,
            }
        )

        -- Skip Vim regex-based syntax for *.md files (fixes issue with markview)
        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
            pattern = "*.md",
            callback = function()
                -- Turn off Vim regex syntax to avoid E403
                vim.cmd("syntax off")
                vim.cmd("syntax clear")
            end,
        })
    end,
}

-- TODO: Replace with lua native plugin i.e. neowiki.nvim
-- vim: foldmethod=marker foldmarker=--#,--+ textwidth=120 colorcolumn=121 nowrap foldlevel=0
