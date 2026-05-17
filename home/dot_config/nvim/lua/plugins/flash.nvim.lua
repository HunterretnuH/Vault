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
    keys = {
        { "s",      function() require("flash").jump() end,              desc = "Flash",               mode = { "n", "x", "o" } },
        { "S",      function() require("flash").treesitter() end,        desc = "Flash Treesitter",    mode = { "n", "x", "o" } },
        { "<tab>r", function() require("flash").remote() end,            desc = "Remote Flash",        mode = { "o" } },
        { "<tab>R", function() require("flash").treesitter_search() end, desc = "Treesitter Search",   mode = { "o", "x" } },
        { "<c-s>",  function() require("flash").toggle() end,            desc = "Toggle Flash Search", mode = { "c" } },
    },
    config = function()
        -- Simple single-character search wrapper
        local function search_char(forward)
          local ok, key = pcall(vim.fn.getchar)
          if not ok then return end
          if key == 27 then return end -- <Esc>
          local char = vim.fn.nr2char(key)
          local cmd = (forward and '/' or '?') .. vim.fn.escape(char, '\\/.*$^~[]') .. '\n'
          vim.api.nvim_feedkeys(cmd, 'ni', false)
        end

        -- Map forward search to <leader>s
        vim.keymap.set('n', 'f', function() search_char(true) end, { noremap = false, silent = true })
        -- Map backward search to <leader>S
        vim.keymap.set('n', 'F', function() search_char(false) end, { noremap = false, silent = true })
    end
}
