return {
    "Makaze/AnsiEsc",
    cmd = { 'AnsiEsc' },
    keys = function()
        local map = require('map')
        map.map('n', '<leader>ta', map.cmd('AnsiEsc'), { desc = "[a]nsi escape sequences highlight" })
        return map.exportKeys()
    end
}
