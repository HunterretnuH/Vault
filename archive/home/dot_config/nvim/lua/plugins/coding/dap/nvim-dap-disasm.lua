return {
    'Jorenar/nvim-dap-disasm',
    dependencies = { 'mfussenegger/nvim-dap', 'rcarriga/nvim-dap-ui' }, --nvim-dap-ui is optional, but required for my config
    lazy = true,
    keys = function()
        local dap = require('dap')
        local dapui = require('dapui')
        local disasm = require('dap-disasm')
        local map = require('map')

        local dl = vim.g.debugLeader

        map.map('n', dl .. 'd', map.cmd('DapDisasm'),  { desc = "[d]isassmebly view" })
        map.group(   dl .. 'i',                    { group = "[i]NSTRUCTION" })
        map.map('n', dl .. 'io', disasm.step_over, { desc = "[o]ver" })
        map.map('n', dl .. 'ii', disasm.step_into, { desc = "[i]nto" })
        map.map('n', dl .. 'ib', disasm.step_back, { desc = "[b]ack" })

        map.map('n', '<C-Down>', disasm.step_into,   { desc = "[i]nto" })
        map.map('n', '<C-Left>', disasm.step_back,   { desc = "[b]ack" })
        map.map('n', '<C-Right>', disasm.step_over,  { desc = "[o]ver" })
        return map.exportKeys()
    end,
    config = function()
        require('dap-disasm').setup({})
    end
}
