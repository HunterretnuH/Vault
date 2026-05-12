
local dap = require('dap')

local c = {
  {
    name        = "Launch file (CODELLDB)",
    type        = "codelldb",
    request     = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd         = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.configurations.c = dap.configurations.c or {}
vim.list_extend(dap.configurations.c, c)

return c
