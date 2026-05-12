
local map = require('map')

--{ Virtual text config
    -- Prepare and apply virtual text config
    local icons = require('universal-icons')
    local virtual_text_config = {
        virtual_text = { 
            prefix = icons.get.virtual_text.prefix, 
            spacing = 2 },
    }
    vim.diagnostic.config(virtual_text_config)
    local virtual_text_enabled = true


    -- Toggle virtual text
    local toggle_virtual_text = function()
        if virtual_text_enabled then
            vim.diagnostic.config({ virtual_text = false })
            virtual_text_enabled = false
        else
            vim.diagnostic.config(virtual_text_config)
            virtual_text_enabled = true
        end
    end
    map.map('n', '<leader>Tv', toggle_virtual_text, { desc = "[v]irtual text", buffer = bufnr })
--}

--{ Command for PCRE regexes
vim.api.nvim_create_user_command('Perldo', function(opts)
  vim.cmd('%!perl -pe ' .. vim.fn.shellescape(opts.args))
end, { nargs = 1 })
    map.map('n', '<leader>rs', 'q:iPerldo ', { desc = "[s]search/replace with perl", buffer = bufnr })

--}

-- vim: foldmethod=marker foldmarker=--{,--} textwidth=120 colorcolumn=121 nowrap
