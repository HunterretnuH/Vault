-- Options different from LazyVim defaults
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.breakindent = true
vim.o.breakindentopt = 'min:20,shift:1,sbr'
vim.o.showbreak = [[|-> ]]
--vim.o.signcolumn = 'auto:2'
vim.o.spelllang = 'en_us,pl_pl'
vim.o.cedit = '<C-e>'
vim.o.virtualedit = 'all'
vim.o.winborder = 'rounded'
--vim.o.mousemoveevent = true
vim.g.python3_host_prog = "/usr/bin/python3" -- fix for ranger localleader not working

-- Same as LazyVim defaults
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.number = true
vim.o.relativenumber = false
vim.o.cursorline = true
vim.o.clipboard = 'unnamedplus'
vim.o.hidden = true
vim.o.termguicolors = true
vim.o.hlsearch = true

-- vim: foldmethod=marker foldmarker=--{,--} textwidth=120 colorcolumn=121 nowrap
