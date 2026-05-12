-- ################################# OPTIONS ##################################
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

--#1 Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.g.debugLeader = "\\"
vim.g.lspLeader = "g"
vim.g.seekerLeader = ";"
--- Dedicated buffer/tab prefix key.
-- <Tab> is remapped to <C-S-1> because:
--   - <Tab> is universally reliable in terminals
--   - <C-S-1> is internally distinct from <Tab>/<C-i>
--   - which-key and recursive mappings work correctly with it
-- This effectively creates an additional pseudo-leader namespace.
vim.g.tabLeader = "<C-S-1>"
vim.keymap.set("n", "<tab>", "<C-S-1>", { remap = true })
-- Preserve native jumplist behavior because terminals often encode
-- <Tab> and <C-i> identically.
vim.keymap.set("n", "<C-i>", "<C-i>", {})

--#1 Disable auto formatting on file save
vim.g.autoformat = false

--#1 Options different from LazyVim defaults
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.breakindent = true
vim.o.breakindentopt = "min:20,shift:1,sbr"
vim.o.showbreak = [[|-> ]]
vim.o.signcolumn = 'auto:2'
vim.o.spelllang = "en_us,pl_pl"
vim.o.cedit = "<C-e>"
vim.o.virtualedit = "all"
--vim.o.winborder = 'rounded'
--vim.o.mousemoveevent = true
--vim.g.python3_host_prog = "/usr/bin/python3"

--#1 Same as LazyVim defaults
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.number = true
vim.o.relativenumber = false
vim.o.cursorline = true
vim.o.clipboard = "unnamedplus"
vim.o.hidden = true
vim.o.termguicolors = true
vim.o.hlsearch = true

--#1 Globals for vimscript plugins HACK:
require('config.vimplugins_globals')

-- vim: foldmethod=marker foldmarker=--#,--+ textwidth=120 colorcolumn=121 nowrap foldlevel=0
