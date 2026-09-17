return {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
        require('kitty-scrollback').setup({
            -- global configuration (first entry with no key = applies to all configs)
            {
                paste_window = {
                    -- Don't open the paste window on yank. By default the plugin's
                    -- TextYankPost autocmd opens the paste window and dumps the yanked
                    -- text into it whenever you yank into `yank_register` (default: the
                    -- unnamed register, i.e. any plain y/yy). Disabling this keeps yanks
                    -- as plain yanks. The paste window can still be opened on demand by
                    -- entering insert mode (i/a), which is a separate TermEnter trigger.
                    yank_register_enabled = false,
                },
            },
        })
    end,
}
