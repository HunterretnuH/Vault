-- Telescope
local qf_list__add_selected = function(prompt_bufnr)
    require('telescope.actions').add_selected_to_qflist(prompt_bufnr)
    require('telescope.actions').open_qflist(prompt_bufnr)
end

local Qf_list__send_all_and_open = function(prompt_bufnr)
    require('telescope.actions').smart_send_to_qflist(prompt_bufnr)
    require('telescope.actions').open_qflist(prompt_bufnr)
end

-- Telescope hierarchy
local definition_goto            = function() require("telescope-hierarchy.actions").goto_definition() end
local toggle_node                = function() require("telescope-hierarchy.actions").toggle()          end
local reverse_direction__inc_out = function() require("telescope-hierarchy.actions").switch()          end
local collapse_node              = function() require("telescope-hierarchy.actions").collapse()        end
local expand_node                = function() require("telescope-hierarchy.actions").expand_node()     end
local expand_multiple_levels     = function() require("telescope-hierarchy.actions").multi_expand()    end

return {
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        -- tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = { "Telescope" },
        config = function()
            local actions = require("telescope.actions")
            local trouble = require("trouble.sources.telescope")
            require('telescope').setup {
                defaults = {
                    path_display = { "smart" },
                    mappings = {
                        n = {
                            ["q"] = actions.close,
                            ["x"] = qf_list__add_selected,
                            ["Q"] = Qf_list__send_all_and_open,
                            ["<C-q>"] = actions.close,
                            ["<esc>"] = false,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<c-o>"] = trouble.open,
                        },
                        i = {
                            ["<C-q>"] = actions.close,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<c-o>"] = trouble.open
                        },
                    },
                }
            }
        end
    },
    {
        "jmacadie/telescope-hierarchy.nvim",
        lazy = true,
        dependencies = {
            {
                "nvim-telescope/telescope.nvim",
                dependencies = { "nvim-lua/plenary.nvim" },
            },
        },
        keys = {
            { vim.g.lspLeader .. "ai", '<cmd>Telescope hierarchy incoming_calls<cr>', desc = "[h]ierarchy - incoming calls" },
            { vim.g.lspLeader .. "ao", '<cmd>Telescope hierarchy outgoing_calls<cr>', desc = "[H]ierarchy - outgoing calls" },
        },
        opts = {
            -- don't use `defaults = { }` here, do this in the main telescope spec
            extensions = {
                hierarchy = {
                    -- telescope-hierarchy.nvim config
                    initial_multi_expand = true, -- Run a multi-expand on open? If false, will only expand one layer deep by default
                    multi_depth = 5, -- How many layers deep should a multi-expand go?
                    layout_strategy = "horizontal",
                },
                -- TODO: Fix - local function names are not displayed by telescope-hierarchy like telescope does.
                mappings = {
                    n = {
                        ["e"]       = expand_multiple_levels,
                        ["l"]       = expand_node,
                        ["c"]       = collapse_node,
                        ["t"]       = toggle_node,
                        ["r"]       = reverse_direction__inc_out,
                        ["d"]       = definition_goto,
                        ["s"]       = false,
                        ["h"]       = false,
                        ["<RIGHT>"] = false,
                        ["<LEFT>"]  = false,
                    }
                }
                -- no other extensions here, they can have their own spec too
            },
        },
        config = function(_, opts)
            -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
            -- configs for us. We won't use data, as everything is in it's own namespace (telescope
            -- defaults, as well as each extension).
            require("telescope").setup(opts)
            require("telescope").load_extension("hierarchy")
        end,
    },
    {
        'nvim-telescope/telescope-project.nvim',
        lazy = true,
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        -- keys = {
        --     { "<leader>fp", function() require('telescope').extensions.project.project() end, desc = "Projects (custom)" },
        -- },
    },
    -- Flash Telescope config
    {
        "nvim-telescope/telescope.nvim",
        optional = true,
        opts = function(_, opts)
        if not LazyVim.has("flash.nvim") then
            return
        end
        local function flash(prompt_bufnr)
            require("flash").jump({
            pattern = "^",
            label = { after = { 0, 0 } },
            search = {
                mode = "search",
                exclude = {
                function(win)
                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                end,
                },
            },
            action = function(match)
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                picker:set_selection(match.pos[1] - 1)
            end,
            })
        end
        opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
            mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
        })
        end,
    },
}
