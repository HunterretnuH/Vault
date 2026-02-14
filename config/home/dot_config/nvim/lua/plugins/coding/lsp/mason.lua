
return {
    "mason-org/mason.nvim",
    cmd = { "Mason" },
    keys = function()
        local map = require("map")
        map.map({ 'n' }, '<leader>al', map.cmd('Mason'), { desc = "[l]sp manager" })
        return map.exportKeys()
    end,
    config = function()
        local icons = require('universal-icons')
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = icons.get.package.installed,
                    package_pending = icons.get.package.pending,
                    package_uninstalled = icons.get.package.uinstalled
                }
            }
        })
    end
}
