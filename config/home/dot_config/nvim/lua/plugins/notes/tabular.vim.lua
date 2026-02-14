return {
    'godlygeek/tabular',
    keys = function()
        local map = require('map')
        map.map({'n', 'v'}, 'ga', ':Tabularize /', { desc = "[a]lign" })
        return map.exportKeys()
    end,
    config = function()
        vim.cmd('AddTabularPattern comma1 /^[^,]*\zs,/l1c1l1')
        vim.cmd('AddTabularPattern curlyBracket1 /^[^,]*\zs{/l1c1l1')
    end

}
-- TODO: Find better replacement plugin
