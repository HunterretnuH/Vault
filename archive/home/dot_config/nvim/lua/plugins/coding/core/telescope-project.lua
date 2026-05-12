
return {
    'nvim-telescope/telescope-project.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },

    keys = function()
        local map = require("map")
        local sl = vim.g.seekerLeader
        map.map('n', sl .. 'p',  function() require('telescope').extensions.project.project() end , { desc = "[p]rojects", silent = true })
        map.exportKeys()
    end
}
