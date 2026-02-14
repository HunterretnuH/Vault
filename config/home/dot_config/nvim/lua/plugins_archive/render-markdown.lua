return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    config = function()
        require("render-markdown").setup({
            completions = {
                lsp = {
                    enabled = true
                }
            },
            code = {
                position = 'right', -- it's not right corner, but at the end of first line of cede :/
            }
        })
    end
}
