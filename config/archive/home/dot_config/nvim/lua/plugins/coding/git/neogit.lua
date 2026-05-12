return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "sindrets/diffview.nvim", -- optional - Diff integration

        -- Only one of these is needed.
        "nvim-telescope/telescope.nvim", -- optional
    },
    cmds = { 'Neogit' },
    keys = function ()
        local neogit = require('neogit')
        local map = require('map')
        map.map('n', '<leader>gg',  function() neogit.open() end,                { desc  = "[g]it open - open neogit in new tab" })
        map.group(   '<leader>gG',                                               { group = "[G]IT (neogit)" })
        map.map('n', '<leader>gGc', function() neogit.open( { "commit" } ) end,  { desc  = "[c]ommit open" })
        map.map('n', '<leader>gGp', function() neogit.open( { kind = "vsplit_left" } ) end, { desc = "[s]plit - open in vsplit" })
        map.map('n', '<leader>gGr', function() neogit.open( { cmd = "~" } ) end, { desc  = "[r]epository -  current file based" }) -- does it differ from open()?
        map.map('n', '<leader>gGR', function()
            neogit.open({ cmd = vim.fn.input("Path to repository: ", vim.fn.getcwd() .. "/", "file") })
        end,                                                                     { desc  = "[R]epository - custom" })

        return map.exportKeys()
    end,
    config = function()
        require('neogit').setup({
            graph_style = "kitty",
            integrations = {
                telescope = true
            }
        })
    end
}

-- TODO: Setup internal keybindings to match my gX alias setup for git
--       Popular keybindings according to chatgpt:
--       * <C-s> – Stage everything in Neogit status buffer. 
--       * p – Pull popup. 
--       * P – Push popup. 
--       * c – Commit popup. 
--       * Tab – Toggle diff view inside Neogit status. 
