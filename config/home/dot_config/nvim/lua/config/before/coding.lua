
--{ LSP config
    local capabilities = function(capabilities)
        return require('blink.cmp').get_lsp_capabilities(capabilities)
    end

    vim.lsp.config("*", {
        capabilities = capabilities,
        --on_attach = on_attach,
        --handlers = handlers,
    })
--}

--{ LSP keybindings (LspAttach event)
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if not client then return end
            local server_name = client.name

            local buffer = ev.buf -- Buffer local mappings.
            local ll = vim.g.lspLeader
            local map = require('map')
            if server_name == "" then
                vim.notify("Empty server name.", vim.log.levels.WARN)
            else
                map.map('n',       'K',     vim.lsp.buf.hover,                   { desc  = "[K] info", buffer = buffer })
                map.map('n',       '<C-d>', vim.lsp.buf.definition,              { desc  = "definition - go to definition", buffer = buffer })
                map.map('n', ll .. 'd',     vim.lsp.buf.declaration,             { desc  = "[d]eclaration", buffer = buffer })
                map.map('n', ll .. 'D',     vim.lsp.buf.type_definition,         { desc  = "[d]efinition - type definition", buffer = buffer })
                map.map('n', ll .. 'k',     vim.lsp.buf.signature_help,          { desc  = "[k] signature help", buffer = buffer })
                map.map('n', ll .. 'i',     vim.lsp.buf.implementation,          { desc  = "[i]mplementation", buffer = buffer })
                map.map('n', ll .. 'r',     vim.lsp.buf.references,              { desc  = "[r]eferences", buffer = buffer })
                --map.map('n', ll .. 'h',     vim.lsp.buf.incoming_calls,          { desc  = "[h] incoming calls", buffer = buffer })
                --map.map('n', ll .. 'H',     vim.lsp.buf.outgoing_calls,          { desc  = "[H] outgoing calls", buffer = buffer })
                map.map('n', ll .. 's',     vim.lsp.buf.document_symbol,         { desc  = "[s]ymbols", buffer = buffer })
                map.map('n', ll .. 'n',     vim.lsp.buf.rename,                  { desc  = "[n]ame change - rename", buffer = buffer })
                map.group(   ll .. 'w',                                          { group = "[w]ORKSPACES" })
                map.map('n', ll .. 'wa',    vim.lsp.buf.add_workspace_folder,    { desc  = "[a]dd", buffer = buffer })
                map.map('n', ll .. 'wr',    vim.lsp.buf.remove_workspace_folder, { desc  = "[r]emove", buffer = buffer })
                map.map('n', ll .. 'ws',    vim.lsp.buf.workspace_symbol,        { desc  = "[s]ymbol", buffer = buffer })
                map.map('n', ll .. 'wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = "[l]ist", buffer = buffer })
                map.map('n', ll .. 'F',  function() vim.lsp.buf.format { async = true } end, { desc = "[F]ormat", buffer = buffer })
                map.map({ 'n', 'v' }, ll .. 'l',vim.lsp.buf.code_action,         { desc  = "[l]ist code actions", buffer = buffer })
            end
        end
    })
--}

-- vim: foldmethod=marker foldmarker=--{,--} textwidth=120 colorcolumn=121 nowrap
