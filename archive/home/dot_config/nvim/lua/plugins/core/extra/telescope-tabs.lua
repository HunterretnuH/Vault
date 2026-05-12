
return {
    'LukasPietzschmann/telescope-tabs',
    keys = function()
        local map = require("map")
        local sl = vim.g.seekerLeader
        map.map('n', sl .. 't', map.func('telescope-tabs', 'list_tabs'),       {})
        return map.exportKeys()
    end,
    config = function()
        require('telescope').load_extension 'telescope-tabs'
        require('telescope-tabs').setup {
            -- Your custom config :^)
        }
    end,
    dependencies = { 'nvim-telescope/telescope.nvim' },
}
