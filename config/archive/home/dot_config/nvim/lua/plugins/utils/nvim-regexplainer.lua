return {
    'bennypowers/nvim-regexplainer',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'MunifTanjim/nui.nvim',
    },
    lazy = false,
    config = function()
        require('regexplainer').setup()
    end
}
