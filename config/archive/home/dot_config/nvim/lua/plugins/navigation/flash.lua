return {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
        modes = {
            char = {
                keys = { }, -- "f", "F", "t", "T"
            }
        }
    },
    -- stylua: ignore
    keys = function ()
        local map = require('map')
        map.map({ "n", "x", "o" }, "s",      function() require("flash").jump() end,              { desc = "Flash" })
        map.map({ "n", "x", "o" }, "S",      function() require("flash").treesitter() end,        { desc = "Flash Treesitter" })
        map.map({ "o" },           "<tab>r", function() require("flash").remote() end,            { desc = "Remote Flash" })
        map.map({ "o", "x" },      "<tab>R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
        return map.exportKeys()
    end,
    config = function()
        -- Simple single-character search wrapper
        local function search_char(forward)
          local ok, key = pcall(vim.fn.getchar)
          if not ok then return end
          if key == 27 then return end -- <Esc>
          local char = vim.fn.nr2char(key)
          local cmd = (forward and '/' or '?') .. vim.fn.escape(char, '\\/.*$^~[]') .. '\n'
          vim.api.nvim_feedkeys(cmd, 'n', false)
        end

        -- Map forward search to <leader>s
        vim.keymap.set('n', 'f', function() search_char(true) end, { noremap = false, silent = true })
        -- Map backward search to <leader>S
        vim.keymap.set('n', 'F', function() search_char(false) end, { noremap = false, silent = true })
    end
}
-- TODO: map <C-f> to consecutive ;, to just enter last search mode and use then f/F for going back or forward
