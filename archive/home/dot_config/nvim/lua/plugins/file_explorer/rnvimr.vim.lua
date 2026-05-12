
local function check_dependency(name)
    local executable_found = vim.fn.executable(name) == 1
    -- Check if Python module is installed
    vim.fn.system("python3 -m pip show " .. name .. " 2>/dev/null")
    local python_module_found = vim.v.shell_error == 0
    return executable_found or python_module_found
end

local localleader = vim.g.maplocalleader or "\\"

return {
    "kevinhwang91/rnvimr",
    lazy = true,
    cmd = { "RnvimrToggle" },
    keys = function()
        local map = require("map")
        map.map({ 'n' }, '<leader>e',      ':RnvimrToggle<CR>',            { desc = "explore files - toggle file explorer", silent = true })
        map.map({ 't' }, '<C-q>',          '<C-\\><C-n>:RnvimrToggle<CR>', { desc = "explore files - toggle file explorer", silent = true })
        map.map({ 't' }, '<localleader>r', '<C-\\><C-n>:RnvimrResize<CR>', { desc = "resize file explorer window by changing preset layouts", silent = true })
        return map.exportKeys()
    end,
    config = function()
        vim.g.rnvimr_draw_border = 0
        local has_ranger   = check_dependency("ranger")
        local has_pynvim   = check_dependency("pynvim")
        local has_ueberzug = check_dependency("ueberzug")

        if not (has_ranger and has_pynvim) then
            vim.notify(
                string.format(
                    "rnvimr not loaded: missing dependencies!\nranger: %s\npython-pynvim: %s\nueberzug: %s",
                    has_ranger and "✓" or "✗",
                    has_pynvim and "✓" or "✗",
                    has_ueberzug and "✓" or "✗"
                ),
                vim.log.levels.WARN
            )
            return
        end

    vim.g.rnvimr_action = {
        [localleader .. 'ot'] = 'NvimEdit tabedit',
        [localleader .. 'os'] = 'NvimEdit split',
        [localleader .. 'ov'] = 'NvimEdit vsplit',
        [localleader .. 'od'] = 'NvimEdit drop',
        [localleader .. 'cd'] = 'EmitRangerCwd',
        [localleader .. 'cg'] = 'JumpNvimCwd'
    }
end
}

-- TODO: Add automatic installation or message for requirements: ranger python-pynvim ueberzug
-- TODO: Check if terminal mappings cna be ranger buffer exclusive

