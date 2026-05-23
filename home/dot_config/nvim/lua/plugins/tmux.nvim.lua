return {
    "aserowy/tmux.nvim",
    config = function()
        require("tmux").setup({
            copy_sync = {
                sync_clipboard = false,
                sync_unnamed = false,
            },
            resize = {
                enable_default_keybindings = false,
            },
            -- TODO: Check swap keybindings and add alternative resize ones
        })
    end,
}
