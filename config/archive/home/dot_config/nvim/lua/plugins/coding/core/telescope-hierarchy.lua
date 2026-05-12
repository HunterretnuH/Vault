
local definition_goto            = function() require("telescope-hierarchy.actions").goto_definition() end
local toggle_node                = function() require("telescope-hierarchy.actions").toggle()          end
local reverse_direction__inc_out = function() require("telescope-hierarchy.actions").switch()          end
local collapse_node              = function() require("telescope-hierarchy.actions").collapse()        end
local expand_node                = function() require("telescope-hierarchy.actions").expand_node()     end
local expand_multiple_levels     = function() require("telescope-hierarchy.actions").multi_expand()    end

return {
    "jmacadie/telescope-hierarchy.nvim",
    dependencies = {
        {
            "nvim-telescope/telescope.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
    },
    keys = function ()
        local map = require('map')
        local ll = vim.g.lspLeader or 'g'
        map.map('n', ll .. "h", map.cmd('Telescope hierarchy incoming_calls'), { desc = "[h]ierarchy - incoming calls" })
        map.map('n', ll .. "H", map.cmd('Telescope hierarchy outgoing_calls'), { desc = "[H]ierarchy - outgoing calls" })
        return map.exportKeys()
    end,
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
}
