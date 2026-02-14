local map = require("map")

--{ Create group for leader key
    map.group('<leader>', { group = 'LEADER'})
    map.group(vim.g.debugLeader, { group = 'DEBUG'})

--}

--{ Create additional groups (includes plugin gorups)
    map.group('<leader>a',              { group = '[a]DMINISTRATION'})
    map.group('<leader>T',              { group = '[T]OGGLE'})
    map.group('<leader>g',              { group = '[g]IT'})
    map.group('<leader>d',              { group = '[d]IFF'})
    map.group('<leader>h',              { group = '[h]UNK'})
    map.group('<leader>p',              { group = "[p]rojects" } )
    map.group(vim.g.debugLeader .. 's', { group = '[s]TEP/[s]TACK'})
    map.group(vim.g.debugLeader .. 'b', { group = '[b]REAKPOINT'})
    map.group(vim.g.debugLeader .. 'p', { group = '[p]ROGRAM'})
--}

--{ Move between windows
    map.map({'n', 'v', 'o'}, '<C-k>',  '<C-w>k', { desc = 'Move up window' })
    map.map({'n', 'v', 'o'}, '<C-j>',  '<C-w>j', { desc = 'Move down window' })
    map.map({'n', 'v', 'o'}, '<C-h>',  '<C-w>h', { desc = 'Move left window' })
    map.map({'n', 'v', 'o'}, '<C-l>',  '<C-w>l', { desc = 'Move right window' })

--}

--{ Administration: config edit
    map.map({'n'}, '<leader>ac', ':edit $MYVIMRC<CR>',   { desc = '[e]dit vimrc - init.lua',   silent = true })
    map.map({'n'}, '<leader>as', ':source $MYVIMRC<CR>', { desc = '[s]ource vimrc - init.lua', silent = true })
--}

--{ Change: edit, load
    map.group(     '<leader>c',  { group = '[c]HANGE'})

    local function _cd()
        vim.cmd('cd%:p:h')
        local dir = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
        vim.notify("Changed CWD to: " .. dir)
    end
    map.map({'n'}, '<leader>cd', _cd,                 { desc = '[d]ir - change cwd current file location'})
--}

--{ Replace/Reload: modeline
    map.group(     '<leader>r',  { group = '[r]EPLACE/[r]ELOAD'})
    map.map({'n'}, '<leader>rm', ':doautocmd BufRead<CR>',    { desc = '[m]odeline', silent = true })
    map.map({'n'}, '<leader>rw', ':%s/\\s\\+$//<CR>:noh<CR>', { desc = '[w]hitespacedat the EOL in buffer'})
    map.map({'n'}, '<leader>rc', ':%s/\\r//g<CR>:noh<CR>',    { desc = '[c]arriage returns in the buffer' })
--}

--{ Save: buffer, all buffers
    local save_file_and_notify = function()
        vim.cmd('w')
        vim.notify("Saved buffer", vim.log.levels.INFO)
    end

    local save_all_files_and_notify = function()
        vim.cmd('wa')
        vim.notify("Saved all buffers", vim.log.levels.INFO)
    end

    map.map({'n', 'i'}, '<C-s>',   save_file_and_notify,      { desc = 'Save buffer',      silent = true })
    map.map({'n', 'i'}, '<C-S-s>', save_all_files_and_notify, { desc = 'Save all buffers', silent = true })
--}

--{ General keybindings without group
    map.map({'n'}, '<leader>q',  ':copen<CR>',        { desc = '[q]f list - open', silent = true })
    map.map({'i'}, '<C-BS>',     '<C-w>',             { desc = 'Delete words with Ctrl + Backspace', silent = true })
    map.map({'n'}, '<C-n>',      ':noh<CR>',          { desc = 'Disable search highlight', silent = true })
    map.map({'v'}, '<leader>p',  '"_dP',              { desc = '[p]aste into selection', silent = true })
    map.map({'t'}, '<ESC><ESC>', '<C-\\><C-n>',       { desc = 'Exit terminal', })
    map.map({'n', 'i'}, '<C-q>', '<ESC>:q<CR>',       { desc = 'Quit',       silent = true })
    map.map({'n'}, '<C-S-q>',    '<ESC>:q!<CR>',      { desc = 'Force Quit', silent = true })
--}

-- vim: foldmethod=marker foldmarker=--{,--} textwidth=120 colorcolumn=121 nowrap
