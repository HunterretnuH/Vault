return {
    "aserowy/tmux.nvim",
    config = function()
        require("tmux").setup({
            copy_sync = {
                sync_clipboard = false,
                sync_unnamed = false,
            },
        })
    end,
}
