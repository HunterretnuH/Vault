return {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 10005,
    config = function()

    require("onedarkpro").setup({
    colors = {
        onedark_vivid = {
                bg = "#202020",     -- active window background
            },
        },
        styles = {
            conditionals = "bold",
            repeats = "bold",
            functions = "bold",
        },
        options = {
            cursorline = true,
        }
        })
        vim.cmd('colorscheme onedark_vivid')
    end
}

-- TODO: Configure colorscheme via global which will be loaded here

