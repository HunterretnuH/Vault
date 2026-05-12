
return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/mini.icons',
    keys = function()
        local map = require('map')

        local tabLeader = '<C-S-1>'
        map.map('n', '<tab>', '<C-S-1>', { remap=true })
        map.map('n', '<C-i>', '<C-i>'  , { })
        map.group(   '<tab>',            { group = "TABS/BUFFERS" } )

        map.map('n', tabLeader  ..  '<tab>', map.cmd('BufferLinePick') , { desc = "[<tab>] switch to buffer by tag" })
        map.map('n', tabLeader  ..  'Q'    , ':BufferLinePickClose<CR>', { desc = "[Q]uit buffer by tag" })
        map.map('n', tabLeader  ..  'q'    , ':tabclose<CR>'           , { desc = "[q]uit current tab" })
        map.map('n', tabLeader  ..  'd'    , ':bdelete!<CR>'           , { desc = "[d]elete current buffer" })
        map.map('n', tabLeader  ..  'n'    , ':tabnew<CR> '            , { desc = "[n]ew tab" })
        map.map('n', tabLeader  ..  'l'    , ':tabmove +1<CR>'         , { desc = "[l] move tab right" })
        map.map('n', tabLeader  ..  'h'    , ':tabmove -1<CR>'         , { desc = "[h] move tab left" })
        map.map('n', tabLeader  ..  'L'    , ':tabmove   <CR>'         , { desc = "[L] move tab to last position" })
        map.map('n', tabLeader  ..  'H'    , ':tabmove  0<CR>'         , { desc = "[H] move tab to first position" })
        map.map('n', tabLeader  ..  'K'    , ':tablast<CR>'            , { desc = "[K] switch to last tab" })
        map.map('n', tabLeader  ..  'J'    , ':tabfirst<CR>'           , { desc = "[J] switch to first tab" })
        map.map('n', tabLeader  ..  'k'    , ':BufferLineCycleNext<CR>', { desc = "[k] switch to left tab" })
        map.map('n', tabLeader  ..  'j'    , ':BufferLineCyclePrev<CR>', { desc = "[j] switch to right tab" })
        return map.exportKeys()
    end,
    config = function()
        local bufferline = require('bufferline')
        local icons = require('universal-icons')

        local function to_hex(color)
            return string.format("#%06x", color)
        end

        local hlFoldColumn = vim.api.nvim_get_hl(0, { name = "FoldColumn" })
        local hlFolded = vim.api.nvim_get_hl(0, { name = "Folded" })
        local bg           = to_hex(hlFoldColumn.bg)
        local active_tab   = to_hex(hlFoldColumn.fg)
        local inactive_tab = to_hex(hlFolded.bg)

        -- Match NvimTree title background to inactive tab color
        vim.cmd('highlight NvimTreeTitle guibg=' .. inactive_tab)

        bufferline.setup({
            options = {
                mode = "tabs", -- set to "tabs" to only show tabpages instead
                buffer_close_icon = icons.get.tabs.close,
                modified_icon = icons.get.file_status.modified,
                close_icon = icons.get.tabs.close,
                left_trunc_marker =  icons.get.tabs.trunc.left,
                right_trunc_marker = icons.get.tabs.trunc.left,
                max_name_length = 50,
                tab_size = 5,
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local diag_suffix   = " "
                    local error_count   = diagnostics_dict["error"]
                    local warning_count = diagnostics_dict["warning"]
                  --local hint_count    = diagnostics_dict["hint"]
                  --local info_count    = diagnostics_dict["info"]

                    if error_count ~= nil and error_count > 0 then
                        diag_suffix = " " .. error_count   .. "🛇 "
                    elseif warning_count ~= nil and warning_count > 0 then
                        diag_suffix = " " .. warning_count .. "w"
                  --elseif hint_count ~= nil and hint_count > 0 then
                  --    diag_suffix = " " .. hint_count .. "h"
                  --elseif info_count ~= nil and info_count > 0 then
                  --    diag_suffix = " " .. info_count .. "i"
                    end
                    return diag_suffix
                end,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "center",
                        highlight = "NvimTreeTitle",
                        separator = true
                    }
                },
                show_close_icon = false,
                show_buffer_close_icons = false,
                always_show_bufferline = false,
                auto_toggle_bufferline = false,
                separator_style = "slope",
            },
            highlights = {
                fill = {               -- part of bar after tabs
                    bg = bg,
                },
                background = {         -- inactive tab
                    --fg = '',         -- name
                    bg = inactive_tab, -- icon and name
                },
                buffer_selected = {    -- active tab
                    --fg = '',         -- name
                    bg = active_tab,   -- icon and name
                },
                separator = {          -- inactive tab
                    fg = bg,           -- separator between inactive tabs
                    bg = inactive_tab, -- border part of active tab
                },
                separator_selected = { -- active tab
                    fg = bg,           -- separator between active and inactive tab
                    bg = active_tab,   -- border part of active tab
                },
                modified = {           -- inactive tab modified file symbol
                    bg = inactive_tab,
                },
                modified_selected = {  -- active tab modified file symbol
                    bg = active_tab,
                },
                duplicate = {          -- inactive duplicated tab - "(duplicated)" string
                    bg = inactive_tab,
                },
                duplicate_selected = { -- active duplicated tab - "(duplicated)" string
                    bg = active_tab,
                },
                error = {                       -- inactive tab name if error in buffer (same for hint, info, warn)
                    bg = inactive_tab,
                },
                error_selected = {              -- active tab name if error in buffer
                    bg = active_tab,
                },
                error_diagnostic = {            -- inactive tab diagnostic icon if error in buffer
                    bg = inactive_tab,
                },
                error_diagnostic_selected = {   -- active tab diagnostic icon if error in buffer
                    bg = active_tab,
                },
                hint = {
                    bg = inactive_tab,
                },
                hint_selected = {
                    bg = active_tab,
                },
                hint_diagnostic = {
                    bg = inactive_tab,
                },
                hint_diagnostic_selected = {
                    bg = active_tab,
                },
                info = {
                    bg = inactive_tab,
                },
                info_selected = {
                    bg = active_tab,
                },
                info_diagnostic = {
                    bg = inactive_tab,
                },
                info_diagnostic_selected = {
                    bg = active_tab,
                },
                warning = {
                    bg = inactive_tab,
                },
                warning_selected = {
                    bg = active_tab,
                },
                warning_diagnostic = {
                    bg = inactive_tab,
                },
                warning_diagnostic_selected = {
                    bg = active_tab,
                },
            }
        })
    end
}
