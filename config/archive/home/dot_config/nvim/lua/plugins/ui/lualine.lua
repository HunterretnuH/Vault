return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 
        'nvim-tree/mini.icons',
        'lewis6991/gitsigns.nvim'       -- custom dep for lazy load order
    },
    config = function()
        local icons = require('universal-icons')

        local diagnostics_component = {
            'diagnostics',
            --sources = {} TODO: Add after setting up blink.cmp
            symbols = {
                error = icons.get.diagnostics.error,
                warn = icons.get.diagnostics.warn,
                info = icons.get.diagnostics.info,
                hint = icons.get.diagnostics.hint
            }
        }
        local diff_component = {
            'diff',
            symbols = {
                added = icons.get.git.added,
                modified = icons.get.git.modified,
                removed = icons.get.git.removed,
            }
        }

        local fileformat_component = {
            'fileformat',
            symbols = {
                unix = icons.get.file_format.unix,
                dos = icons.get.file_format.dos,
                mac = icons.get.file_format.mac,
            }
        }

        local filename_component = {
            'filename',
            symbols = {
                modified = icons.get.file_status.modified,
                readonly = icons.get.file_status.readonly,
                unnamed  = icons.get.file_status.unnamed,
                newfile  = icons.get.file_status.newfile,
            }
        }

        local lsp_status_component = {
            'lsp_status',
            symbols = {
                spinner   = icons.get.state.loading.dot_spinner,
                done      = icons.get.state.done,
                separator = icons.get.separators.simple.default,
            }
        }

        -- Using gitsigns as external source of git information instead of using git directly by lualine
        local function diff_source()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed
            }
          end
        end
        diff_component.source = diff_source

        local branch_component = { 'b:gitsigns_head', icon = '' }


        require('lualine').setup {
            options = {
                component_separators = {
                    left = icons.get.separators.advanced.slant.outline.left,
                    right = icons.get.separators.advanced.slant.outline.right
                },
                section_separators = {
                    left = icons.get.separators.advanced.slant.filled.left,
                    right = icons.get.separators.advanced.slant.filled.right
                },
            },
            sections = {
                lualine_a = { 'mode'},
                lualine_b = { branch_component, diff_component, diagnostics_component },
                lualine_c = { filename_component },
                lualine_x = { lsp_status_component, 'encoding', fileformat_component, 'filetype' }, --TODO: Check lsp_status
                lualine_y = { 'progress'},
                lualine_z = { 'location'}
            },
            inactive_sections = {
                lualine_a = { },
                lualine_b = { },
                lualine_c = { 'filename'},
                lualine_x = { 'location'},
                lualine_y = { },
                lualine_z = { }
            },
        }
    end
}

