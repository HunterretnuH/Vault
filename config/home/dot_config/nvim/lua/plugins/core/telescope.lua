
-- Move current search results to location list
local function searchToLocList()
    vim.cmd("vimgrep // %")
    require('telescope.builtin').quickfix({
      sorting_strategy='ascending',
      initial_mode='normal'})
end


local qf_list__add_selected = function(prompt_bufnr)
    require('telescope.actions').add_selected_to_qflist(prompt_bufnr)
    require('telescope.actions').open_qflist(prompt_bufnr)
end

local Qf_list__send_all_and_open = function(prompt_bufnr)
    require('telescope.actions').smart_send_to_qflist(prompt_bufnr)
    require('telescope.actions').open_qflist(prompt_bufnr)
end

return {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = function()
        local map = require("map")
        local sl = vim.g.seekerLeader
        map.group("'", { group = "TELESCOPE" })

        map.map('n', sl .. 'Q', function() searchToLocList() end, { desc = "[Q]ickfix list - pass current telescope window content" })

        map.map('n', sl ..  sl, function() require('telescope.builtin').resume() end,                    { desc = "[r]esume last window" })
        map.map('n', sl .. 'f', function() require('telescope.builtin').live_grep() end,                 { desc = "[f]ind inside files in cwd" })
        map.map('n', sl .. 'F', function() require('telescope.builtin').find_files() end,                { desc = "[F]ind files in cwd" })
        map.map('n', sl .. 'g', function() require('telescope.builtin').git_files() end,                 { desc = "[g]it find - search git tracked files in cwd" })
        map.map('n', sl .. '*', function() require('telescope.builtin').grep_string() end,               { desc = "[*] Find word under cursor inside files in cwd" })
        map.map('n', sl .. 'b', function() require('telescope.builtin').buffers() end,                   { desc = "[b]uffers" })
        map.map('n', sl .. 'h', function() require('telescope.builtin').help_tags() end,                 { desc = "[h]elp tags " })
        map.map('n', sl .. 'm', function() require('telescope.builtin').marks()                     end,                     { desc = "[m]arks" })
        map.map('n', sl .. 'o', function() require('telescope.builtin').vim_options()               end,               { desc = "[o]ptions" })
        map.map('n', sl .. '/', function() require('telescope.builtin').current_buffer_fuzzy_find() end, { desc = "[/]Find inside buffer" })
        map.map('n', sl .. 'q', function() require('telescope.builtin').quickfix()                  end,                  { desc = "[q]uickfix list" })
        map.map('n', sl .. 'Q', function() require('telescope.builtin').quickfixhistory()         end, { desc = "[Q]uickfix history list" })
        map.map('n', sl .. 'j', function() require('telescope.builtin').jumplist()                end, { desc = "[j]umplist list" })
        map.map('n', sl .. 'r', function() require('telescope.builtin').oldfiles()                end, { desc = "[r]eopen last files" })
        map.map('n', sl .. 'c', function() require('telescope.builtin').commands()                end, { desc = "[c]ommands list" })

        -- LSP related
        map.map('n', sl .. 'd',  function() require('telescope.builtin').diagnostics()            end, { desc = "[d]iagnostics" })
        map.map('n', sl .. 's',  function() require('telescope.builtin').lsp_document_symbols()   end, { desc = "[s]ymbols" })
        -- TODO: Must adhere to gX from LSP. But first make sure that they don't open already in telescope (I think they do).
        map.map('n', sl .. 'tw',  function() require('telescope.builtin').lsp_workspace_symbols() end, { desc = "[w]orkspace symbols" })
        map.map('n', sl .. 'tr',  function() require('telescope.builtin').lsp_references()        end, { desc = "[r]eferences" })
        map.map('n', sl .. 'th',  function() require('telescope.builtin').lsp_incoming_calls()    end, { desc = "[i]ncoming calls" })
        map.map('n', sl .. 'tH',  function() require('telescope.builtin').lsp_outgoing_calls()    end, { desc = "[o]utgoing calls" })
        map.map('n', sl .. 'ts',  function() require('telescope.builtin').lsp_document_symbols()  end, { desc = "[s]ymbols in document" })
        map.map('n', sl .. 'tW',  function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, { desc = "[S]ymbols in workspace" })
        map.map('n', sl .. 'tD',  function() require('telescope.builtin').diagnostics()           end, { desc = "[D]iagnostics" })
        map.map('n', sl .. 'ti',  function() require('telescope.builtin').lsp_implementations()   end, { desc = "[i]mplementations" })
        map.map('n', sl .. 'td',  function() require('telescope.builtin').lsp_definitions()       end, { desc = "[d]definitions" })
        map.map('n', sl .. 'tt',  function() require('telescope.builtin').lsp_type_definitions()  end, { desc = "[t]ype definitions" })
        return map.exportKeys()
    end,
    config = function()
        local actions = require("telescope.actions")
        local trouble = require("trouble.sources.telescope")
        require('telescope').setup {
            defaults = {
                path_display = { "smart" },
                mappings = {
                    n = {
                        ["q"] = qf_list__add_selected,
                        ["Q"] = Qf_list__send_all_and_open,
                        ["<C-q>"] = actions.close,
                        ["<esc>"] = false,
                        ["<c-o>"] = trouble.open
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
}
