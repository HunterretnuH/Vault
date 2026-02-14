
vim.o.tabstop = 4                               -- set ts=4
vim.o.softtabstop = 4                           -- set sts=4
vim.o.shiftwidth = 4                            -- set sw=4
vim.o.expandtab = true                          -- set ts=4
vim.o.autoindent = true                         -- set ai
vim.o.smartindent = true                        -- set smartindent
vim.o.breakindent = true                        -- set breakindent
vim.o.breakindentopt = 'min:20,shift:1,sbr'     -- set breakindentopt=min:20,shift:1,sbr
vim.o.showbreak = [[|-> ]]                      -- set showbreak=\|->\
vim.o.wrap = false                              -- set nowrap
vim.o.ignorecase = true                         -- set ignorecase
vim.o.smartcase = true                          -- set smartcase
vim.o.number = true                             -- set number
vim.o.relativenumber = false                    -- set relativenumber
vim.o.cursorline = true                         -- set cursorline
vim.o.clipboard = 'unnamedplus'                 -- set clipboard=unnamedplus
vim.o.hidden = true                             -- set hidden
vim.o.termguicolors = true                      -- set termguicolors
vim.o.hlsearch = true                           -- set hlsearch
vim.o.signcolumn = 'auto:2'                     -- set signcolumn width
vim.o.spelllang = 'en_us,pl_pl'                 -- set spelllang=en_us,pl_pl
vim.o.cedit = '<C-e>'                           -- set cedit=<C-e>
vim.o.virtualedit = 'all'                       -- set virtualedit=all
vim.o.winborder = 'rounded'                     -- set virtualedit=all
vim.o.mousemoveevent = true

vim.g.python3_host_prog = "/usr/bin/python3"

-- vim: foldmethod=marker foldmarker=--{,--} textwidth=120 colorcolumn=121 nowrap
