return {
    "lervag/wiki.vim",
    -- dependencies = { 'preservim/vim-markdown' }, -- my own custom dependency
    -- tag = "v0.10", -- uncomment to pin to a specific release
    init = function()
        local options = require('env')
        local map = require('map')
        map.group('<leader>w', { group = "[W]IKI" });
        map.group('<leader>ws', { group = "[S]ELECT" });

        map.map('n', '<leader>ww', ':e ' .. options.wiki.default_wiki_path .. 'index.md<CR>',
            { desc = '[W]iki', silent = true })

        if options.wiki.dev_wiki_path then
            map.map('n', '<leader>wsd', ':e ' .. options.wiki.dev_wiki_path .. 'index.md<CR>',
                { desc = '[D]ev', silent = true })
        end
        if options.wiki.main_wiki_path then
            map.map('n', '<leader>wsm', ':e ' .. options.wiki.main_wiki_path .. 'index.md<CR>',
                { desc = '[m]ain', silent = true })
        end
        if options.wiki.rpg_wiki_path then
            map.map('n', '<leader>wsr', ':e ' .. options.wiki.rpg_wiki_path .. 'index.md<CR>',
                { desc = '[R]pg', silent = true })
        end
        if options.wiki.plotbuy_wiki_path then
            map.map('n', '<leader>wsP', ':e ' .. options.wiki.plotbuy_wiki_path .. 'index.md<CR>',
                { desc = '[P]lot buy', silent = true })
        end
        if options.wiki.private_wiki_path then
            map.map('n', '<leader>wsp', ':e ' .. options.wiki.private_wiki_path .. 'index.md<CR>',
                { desc = '[P]rivate', silent = true })
        end
        if options.wiki.work_wiki_path then
            map.map('n', '<leader>wsw', ':e ' .. options.wiki.work_wiki_path .. 'index.md<CR>',
                { desc = '[W]ork', silent = true })
        end
        if options.wiki.mman_wiki_path then
            map.map('n', '<leader>wsM', ':e ' .. options.wiki.mman_wiki_path .. 'index.md<CR>',
                { desc = '[M]man', silent = true })
        end
        if options.wiki.mssh_wiki_path then
            map.map('n', '<leader>wss', ':e ' .. options.wiki.mssh_wiki_path .. 'index.md<CR>',
                { desc = '[S]sh', silent = true })
        end

        map.map('n', '<leader>wi', ':WikiIndex<CR>',        { desc = '[i]ndex open',       silent = true })
        map.map('n', '<leader>wp', ':WikiPages<CR>',        { desc = '[p]ages list',       silent = true })
        map.map('n', '<leader>wt', ':WikiToc<CR>',          { desc = '[t]able of content', silent = true })
        map.map('n', '<leader>wT', ':WikiTags<CR>',         { desc = '[t]ags list',        silent = true })
        map.map('n', '<leader>wj', ':WikiJournal<CR>',      { desc = '[j]ournal',          silent = true })
        map.map('n', '<leader>wJ', ':WikiJournalIndex<CR>', { desc = '[J]ournal index',    silent = true })
        -- TODO: Add `ws` mapping

        vim.g.wiki_root = options.wiki.default_wiki_path
        vim.g.wiki_filetypes = { 'md' }
        vim.g.wiki_link_extension = '.md'
        vim.g.wiki_link_target_type = 'md'

        -- Markdown_fenced_languages aren't using treesitter TODO: Search for better solution.
        vim.g.markdown_fenced_languages = { 'python', 'c', 'cpp', 'bash', 'go', 'vim', 'lua', 'html', 'javascript',
            'js=javascript', 'json=javascript', 'markdown' }

        vim.g.wiki_export = {
            args = '',
            from_format = 'markdown',
            ext = 'html',
            link_ext_replace = true,
            view = false,
            output = vim.fn.fnamemodify(vim.fn.tempname(), ':h'),
        }

        vim.api.nvim_create_augroup('MyWikiAutocmdsGroup', { clear = true })
        vim.api.nvim_create_autocmd('User',
            {
                pattern = 'WikiBufferInitialized',
                group = 'MyWikiAutocmdsGroup',
                callback = function()
                    local map = require('map')
                    map.map({ 'n', 'v', 'o' }, '<localleaderj', '<plug>(wiki-link-next)', { desc = 'Next link', buffer = true })
                    map.map({ 'n', 'v', 'o' }, '<localleader>k', '<plug>(wiki-link-prev)',
                        { desc = 'Previous link', buffer = true })
                end
            })

        -- fold fix source: https://github.com/OXY2DEV/markview.nvim/issues/242
        _G.md_foldtext = function()
            --- Get the plugin config.
            local spec_available, spec = pcall(require, "markview.spec");

            if spec_available == false then
                --- No config :(
                return "";
            end

            local from, to = vim.v.foldstart, vim.v.foldend;
            --- The line where the fold starts.
            ---@type string
            local line = vim.api.nvim_buf_get_lines(0, from - 1, from, false)[1];

            if line:match("^%s*#+") then
                --- Only do this on headings.

                --- Before: Text before #.
                --- Marker: #
                --- content: Everything after #
                local before, marker, content = line:match("^([%s%>]*)(%#+)(.*)$");
                ---@type integer Heading level
                local level = marker:len();

                --- Heading configuration.
                ---@type headings.atx
                local config = spec.get({ "markdown", "headings", "heading_" .. level }, { fallback = {} })

                -- Append spaces equal to heading level
                before= (before or "") .. string.rep(" ", level)

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
                    { "󰁂 " .. (to - from), "MarkviewPalette5Fg" }
                }
            else
                return "";
            end
        end

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

        vim.api.nvim_create_autocmd( -- autocmd FileType markdown set textwidth=120 colorcolumn=121 nowrap
            { 'FileType' },
            {
                pattern = { 'markdown' },
                callback = function()
                    --- Removes the •••••• part.
                    vim.o.fillchars = "fold: ";
                    vim.o.textwidth = 120
                    vim.o.colorcolumn = "121"
                    vim.o.wrap = false
                    vim.o.foldmethod = "expr"
                    --vim.o.foldexpr = "nvim_treesitter#foldexpr()"
                    vim.o.foldexpr = "v:lua.md_foldexpr()"
                    vim.o.foldtext = "v:lua.md_foldtext()"
                    vim.o.foldlevel = 2
                    --vim.o.foldcolumn = "auto:9"
                    vim.o.conceallevel = 1
                    vim.o.concealcursor = ""
                    vim.o.fillchars = "fold: ";
                end
            })
            -- Skip Vim regex-based syntax for *.md files (fixes issue with markview)
            vim.api.nvim_create_autocmd({"BufRead","BufNewFile"}, {
                pattern = "*.md",
                callback = function()
                    -- Turn off Vim regex syntax to avoid E403
                    vim.cmd("syntax clear")
                    vim.cmd("syntax off")
                end
            })
    end
}
