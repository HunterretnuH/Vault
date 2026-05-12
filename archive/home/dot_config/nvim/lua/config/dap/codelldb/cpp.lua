
local dap = require('dap')

local c = require('config.dap.codelldb.c')
dap.configurations.cpp = dap.configurations.cpp or {}
vim.list_extend(dap.configurations.cpp, c)
