return {
    "mfussenegger/nvim-dap",
    keys = function()
        local map = require('map')
        local dap = require('dap')
        local dl = vim.g.debugLeader

        local dap_set_breakpoint_cond = function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end
        local dap_set_breakpoint_log  = function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end

        map.map({ 'n' }, dl .. 'c',  dap.continue,            { desc = "[c]ontinue",                  silent = true })
        map.map({ 'n' }, dl .. 'C',  dap.reverse_continue,    { desc = "[C]ontinue reverse",          silent = true })
        map.map({ 'n' }, dl .. 'r',  dap.repl.toggle,         { desc = "[r]epl toggle",               silent = true })
        map.map({ 'n' }, dl .. 'bb', dap.toggle_breakpoint,   { desc = "[b]reakpoint toggle",         silent = true })
        map.map({ 'n' }, dl .. 'bL', dap.list_breakpoints,    { desc = "[L]ist breakpoints",          silent = true })
        map.map({ 'n' }, dl .. 'bC', dap.clear_breakpoints,   { desc = "[C]lear breakpoints",         silent = true })
        map.map({ 'n' }, dl .. 'bc', dap_set_breakpoint_cond, { desc = "[c]onditional breakpoint ",   silent = true })
        map.map({ 'n' }, dl .. 'bl', dap_set_breakpoint_log,  { desc = "[l]ogging breakpoint",        silent = true })
        map.map({ 'n' }, dl .. 'pr', dap.run_last,            { desc = "[r]un last program",          silent = true })
        map.map({ 'n' }, dl .. 'pR', dap.restart,             { desc = "[R]estart program",           silent = true })
        map.map({ 'n' }, dl .. 'pt', dap.terminate,           { desc = "[t]erminate program",         silent = true })
        map.map({ 'n' }, dl .. 'pd', dap.disconnect,          { desc = "[d]isconnect from debugger",  silent = true })
        map.map({ 'n' }, dl .. 'su', dap.up,                  { desc = "[u]p stack frame",            silent = true })
        map.map({ 'n' }, dl .. 'sd', dap.down,                { desc = "[d]own stack frame",          silent = true })
        map.map({ 'n' }, dl .. 'so', dap.step_over,           { desc = "[o]ver",                      silent = true })
        map.map({ 'n' }, dl .. 'sb', dap.step_back,           { desc = "[b]ack",                      silent = true })
        map.map({ 'n' }, dl .. 'si', dap.step_into,           { desc = "[i]to",                       silent = true })
        map.map({ 'n' }, dl .. 'sO', dap.step_out,            { desc = "[O]ut",                       silent = true })
        map.map({ 'n' }, dl .. 'sr', dap.restart_frame,       { desc = "[r]estart frame",             silent = true })
        map.map({ 'n' }, dl .. '<Up>',    dap.step_out,       { desc = "Step out",                    silent = true })
        map.map({ 'n' }, dl .. '<Down>',  dap.step_into,      { desc = "Setp into",                   silent = true })
        map.map({ 'n' }, dl .. '<Left>',  dap.step_back,      { desc = "Step back",                   silent = true })
        map.map({ 'n' }, dl .. '<Right>', dap.step_over,      { desc = "Step over",                   silent = true })

        local widgets = require('dap.ui.widgets')

        map.map({'n', 'v'}, dl .. 'h', widgets.hover,         { desc = "[h]over", silent = true })
        map.map({'n', 'v'}, dl .. 'P', widgets.preview,       { desc = "[P]review", silent = true })
        --TODO: fix stupid quit with ZZ for both widgets below
        map.map({'n'},      dl .. 'f', function() widgets.centered_float(widgets.frames) end, { desc = "[f]rames", silent = true })
        map.map({'n'},      dl .. 'S', function() widgets.centered_float(widgets.scopes) end, { desc = "[S]copes", silent = true })
        return map.exportKeys()
    end,
    init = function()
        local icons = require('universal-icons')
        vim.api.nvim_set_hl(0, 'DapBreakpoint',          { ctermbg = 0, fg = '#993333' })
        vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { ctermbg = 0, fg = '#993333' })
        vim.api.nvim_set_hl(0, 'DapBreakpointRejected',  { ctermbg = 0, fg = '#993333' })
        vim.api.nvim_set_hl(0, 'DapLogPoint',            { ctermbg = 0, fg = '#61afef' })
        vim.api.nvim_set_hl(0, 'DapStopped',             { ctermbg = 0, fg = '#339933' })

        vim.fn.sign_define('DapBreakpoint',          { text=icons.get.debug.breakpoint,           texthl='DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointCondition', { text=icons.get.debug.breakpoint_condition, texthl='DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointRejected',  { text=icons.get.debug.breakpoint_rejected,  texthl='DapBreakpoint' })
        vim.fn.sign_define('DapLogPoint',            { text=icons.get.debug.log_point,            texthl='DapLogPoint'   })
        vim.fn.sign_define('DapStopped',             { text=icons.get.debug.stopped,              texthl='DapStopped'    })
    end,
    config = function()
        require('config.dap.dap')
    end
}
-- TODO:
-- * Use theme highlight groups instead of custom ones or fully confiugre current ones
