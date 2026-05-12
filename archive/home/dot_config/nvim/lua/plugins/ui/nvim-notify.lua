return {
    'rcarriga/nvim-notify',
    lazy = false,
    priority = 10003,
    keys = function()
        local map = require('map')
        local telescopeNotify = function(opts)
            local ok, telescope = pcall(require, "telescope")
            if not ok then error("Telescope is required for notify extension") end
            telescope.load_extension("notify")
            telescope.extensions.notify.notify(opts)
        end
        map.map('n', vim.g.seekerLeader .. 'n', telescopeNotify, { desc = "[n]otifications" })
        return map.exportKeys()
    end,
    config = function()
        local icons = require('universal-icons')
        require('notify').setup({
            icons = {
                    DEBUG = icons.get.notifications.debug,
                    ERROR = icons.get.notifications.error,
                    INFO  = icons.get.notifications.info,
                    TRACE = icons.get.notifications.trace,
                    WARN  = icons.get.notifications.warn
                },
            timeout = 500 -- in miliseconds, but doesn't include in/out animation time so setting small value
        })

        require("telescope").load_extension("notify")
        vim.notify = require('notify')
    end
}
