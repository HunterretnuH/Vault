return {
    "akinsho/bufferline.nvim",
    opts = {
        options = {
            --always_show_bufferline = true,
        },
    },
    keys = function()
        local bufLeader = vim.g.tabLeader
        local tabLeader = bufLeader .. "<tab>"

        return {
            ----------------------------------------------------------------
            -- NAVIGATION: prev / next
            ----------------------------------------------------------------
            { tabLeader .. "j", "<cmd>tabprev<CR>",                 desc = "Prev tab" },
            { tabLeader .. "k", "<cmd>tabnext<CR>",                 desc = "Next tab" },
            { bufLeader .. "j", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
            { bufLeader .. "k", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
            { "H",              "<cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
            { "L",              "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },

            ----------------------------------------------------------------
            -- NAVIGATION: first / last
            ----------------------------------------------------------------
            { tabLeader .. "J", "<cmd>tabfirst<CR>",                    desc = "First tab" },
            { tabLeader .. "K", "<cmd>tablast<CR>",                     desc = "Last tab" },
            { bufLeader .. "J", "<cmd>BufferLineGoToBuffer 1<CR>",  desc = "First buffer" },
            { bufLeader .. "K", "<cmd>BufferLineGoToBuffer -1<CR>", desc = "Last buffer" },

            ----------------------------------------------------------------
            -- MOVE: step
            ----------------------------------------------------------------
            { tabLeader .. "h", "<cmd>tabmove -1<CR>",             desc = "Move tab backward" },
            { tabLeader .. "l", "<cmd>tabmove +1<CR>",             desc = "Move tab forward" },
            { bufLeader .. "h", "<cmd>BufferLineMovePrev<CR>", desc = "Move buffer backward" },
            { bufLeader .. "l", "<cmd>BufferLineMoveNext<CR>", desc = "Move buffer forward" },

            ----------------------------------------------------------------
            -- MOVE: to edges
            ----------------------------------------------------------------
            { tabLeader .. "H", "<cmd>tabmove 0<CR>", desc = "Move tab to beginning" },
            { tabLeader .. "L", "<cmd>tabmove<CR>",   desc = "Move tab to end" },
            { bufLeader .. "H",
                function()
                    require("bufferline").move_to(1)
                end,
                desc = "Move buffer to beginning",
            },
            { bufLeader .. "L",
                function()
                    require("bufferline").move_to(-1)
                end,
                desc = "Move buffer to end",
            },

            ----------------------------------------------------------------
            -- CREATE
            ----------------------------------------------------------------
            { tabLeader .. "n", "<cmd>tabnew<CR>",  desc = "New tab" },
            { bufLeader .. "n", "<cmd>enew<CR>",    desc = "New buffer" },

            ----------------------------------------------------------------
            -- CLOSE
            ----------------------------------------------------------------
            { tabLeader .. "q", "<cmd>tabclose<CR>", desc = "Close tab" },
            { bufLeader .. "q", function() Snacks.bufdelete() end,  desc = "Close buffer" },

            ----------------------------------------------------------------
            -- TAB: rename
            ----------------------------------------------------------------
            { tabLeader .. "r", ":BufferLineTabRename ", desc = "Rename tab" },

            ----------------------------------------------------------------
            -- BUFFER: pin / pick / switch
            ----------------------------------------------------------------
            { bufLeader .. "p", "<cmd>BufferLineTogglePin<CR>", desc = "Pin buffer" },
            { bufLeader .. "s", "<cmd>BufferLinePick<CR>",      desc = "Pick buffer" },
            { bufLeader .. "w", "<cmd>e #<CR>",                 desc = "Switch to last buffer" },

            ----------------------------------------------------------------
            -- BUFFER: sorting
            ----------------------------------------------------------------
            { bufLeader .. "Sd", "<cmd>BufferLineSortByDirectory<CR>",         desc = "Sort by directory" },
            { bufLeader .. "Sr", "<cmd>BufferLineSortByRelativeDirectory<CR>", desc = "Sort by relative directory" },
            { bufLeader .. "Se", "<cmd>BufferLineSortByExtension<CR>",         desc = "Sort by extension" },
            { bufLeader .. "St", "<cmd>BufferLineSortByTabs<CR>",              desc = "Sort by tabs" },

            ----------------------------------------------------------------
            -- BUFFER: pick close
            ----------------------------------------------------------------
            { bufLeader .. "d", "<cmd>BufferLinePickClose<CR>", desc = "Delete choosen buffer" },

            ----------------------------------------------------------------
            -- BUFFER: bulk close
            ----------------------------------------------------------------
            { bufLeader .. "Qh", "<cmd>BufferLineCloseLeft<CR>",            desc = "Close buffers to the left" },
            { bufLeader .. "Ql", "<cmd>BufferLineCloseRight<CR>",           desc = "Close buffers to the right" },
            { bufLeader .. "Qo", function() Snacks.bufdelete.other() end,   desc = "Close other buffers" },
            { bufLeader .. "Qp", "<cmd>BufferLineGroupClose ungrouped<CR>", desc = "Close non-pinned buffers" },

            ----------------------------------------------------------------
            -- BUFFER: groups
            ----------------------------------------------------------------
            { bufLeader .. "Qg", "<cmd>BufferLineGroupClose<CR>", desc = "Close buffer group" },
            { bufLeader .. "g", "<cmd>BufferLineGroupToggle<CR>",     desc = "Toggle buffer group" },
            ----------------------------------------------------------------
            -- BUFFER: PICKER
            ----------------------------------------------------------------
            { bufLeader .. ";", function() Snacks.picker.buffers() end, desc = "Find buffer" },
        }
    end,
}
