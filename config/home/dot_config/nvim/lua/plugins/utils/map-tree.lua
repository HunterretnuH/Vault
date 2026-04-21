return {
    "HunterretnuH/map-tree.nvim",
    lazy = true,
    cmd = { "MapTreeOpen" },
    keys = function()
        local map = require("map")
        map.map({'n', 'v', 'o' }, '<C-/>', ":MapTreeOpen<CR>", { desc = 'Help - map of all keybindings' })
        return map.exportKeys()
    end,
    config = function()
        require("map-tree").setup()
    end
}
