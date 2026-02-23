return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = { },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        require("noice").setup({
            lsp = {
                -- disabling hover and signature. blink.cmp ones seem to be better.
                hover = { enabled = false },
                signature = { enabled = false },
            },
            routes = {
                {
                    filter = { event = 'msg_show', kind = { 'shell_out', 'shell_err' } },
                    view = 'split',
                    opts = {
                        level = 'info',
                        skip = false,
                        replace = false,
                    },
                }
              --{
              --    view = "cmdline",  -- show it at the bottom like normal
              --    filter = { event = "msg_show", find = "group" },
              --    opts = {
              --        skip = false
              --    },
              --},
              --{
              --    view = "cmdline",  -- show it at the bottom like normal
              --    filter = { event = "msg_show", find = "E45" },
              --    opts = {
              --        min_height = 1,    -- force single-line
              --        skip = false
              --    },
              --},
            },
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
            }
        })
    end
}
