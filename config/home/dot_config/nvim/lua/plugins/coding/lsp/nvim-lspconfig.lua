return {
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },
    config = function()
        vim.lsp.config("basedpyright", {
            settings = {
                python = {
                    pythonPath = "/usr/bin/python",
                },
                basedpyright = {
                    analysis = {
                        typeCheckingMode = "basic",  -- or "off"
                        reportMissingTypeStubs = false,
                        reportUnknownMemberType = false,
                        reportUnknownVariableType = false,
                    },
                },
            },
        })
    end
}
