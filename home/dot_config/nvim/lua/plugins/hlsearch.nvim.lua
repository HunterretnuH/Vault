-- Automaticaly removes search highlight
return {
    'nvimdev/hlsearch.nvim',
    lazy = false,
    config = function()
        require('hlsearch').setup()
    end
}

