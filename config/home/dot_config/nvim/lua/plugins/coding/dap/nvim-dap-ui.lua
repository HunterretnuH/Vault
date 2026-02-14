return {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    keys = function()
        local map = require('map')
        local dapui = require('dapui')
        local dl = vim.g.debugLeader

        map.map({ 'n' },      dl .. '\\', dapui.toggle, { desc = "[\\] Dap UI toggle",                silent = true })
        map.map({ 'n', 'v' }, dl .. 'e', dapui.eval,   { desc = "[e]valuate symbol under cursor", silent = true })

        return map.exportKeys()
    end,
    config = function()
        local icons = require('universal-icons')
        require('dapui').setup( {
            controls = {
                icons = {
                    disconnect = icons.get.debug.disconnect,
                    pause      = icons.get.debug.pause,
                    play       = icons.get.debug.play,
                    run_last   = icons.get.debug.run_last,
                    step_back  = icons.get.debug.step_back,
                    step_into  = icons.get.debug.step_into,
                    step_out   = icons.get.debug.step_out,
                    step_over  = icons.get.debug.step_over,
                    terminate  = icons.get.debug.terminate,
                }
            },
            icons = {
                collapsed      = icons.get.menu.collapsed,
                current_frame  = icons.get.menu.current_frame,
                expanded       = icons.get.menu.expanded,
            }
        })
    end
}

-- TODO:
-- * add lazydev.nvim and set library filed for nvim-dap-ui
