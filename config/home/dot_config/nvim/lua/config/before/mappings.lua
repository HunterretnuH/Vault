
--{ Set leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.debugLeader = '\\'
vim.g.lspLeader = 'g'
vim.g.seekerLeader = ';'
--}

--{ Open command-line window instead of command-line mode
    vim.keymap.set({'n', 'v', 'o'}, ':',  'q:i', { }) -- noremap : q:i
    vim.keymap.set({'n', 'v', 'o'}, '/',  'q/i\\v', { }) -- noremap / q/i
    vim.keymap.set({'n', 'v', 'o'}, '?',  'q?i\\v', { }) -- noremap ? q?i
    vim.keymap.set({'n', 'v', 'o'}, 'q:', ':',   { }) -- noremap q: :
    vim.keymap.set({'n', 'v', 'o'}, 'q/', '/\\v',   { }) -- noremap q/ /
    vim.keymap.set({'n', 'v', 'o'}, 'q?', '?\\v',   { }) -- noremap q? ?

    local function restoreStandardMappings()
        vim.keymap.set({'n', 'v', 'o'}, ':', ':\\v',   { buffer = true }) -- noremap <silent> : :
        vim.keymap.set({'n', 'v', 'o'}, '/', '/\\v',   { buffer = true }) -- noremap <silent> / /
        vim.keymap.set({'n', 'v', 'o'}, '?', '?\\v',   { buffer = true }) -- noremap <silent> ? ?
        vim.keymap.set({'n', 'v', 'o'}, 'q:', 'q:\\v', { buffer = true }) -- noremap <silent> q: q:
        vim.keymap.set({'n', 'v', 'o'}, 'q/', 'q/\\v', { buffer = true }) -- noremap <silent> q/ q/
        vim.keymap.set({'n', 'v', 'o'}, 'q?', 'q?\\v', { buffer = true }) -- noremap <silent> q? q?
    end
    vim.api.nvim_create_autocmd( {"CmdwinEnter"}, { callback = restoreStandardMappings} )
--}

-- vim: foldmethod=marker foldmarker=--{,--} textwidth=120 colorcolumn=121 nowrap
