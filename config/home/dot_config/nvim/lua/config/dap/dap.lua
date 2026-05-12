return function()
    local function merge(...)
        local result = {}
        for _, tbl in ipairs({ ... }) do
            if tbl then
                vim.list_extend(result, tbl)
            end
        end
        return result
    end

    return {
        adapters = {
            codelldb = require("config.dap.codelldb.adapter"),
            cpptools = require("config.dap.cpptools.adapter"),

        },
        configurations = {
            c =   merge(require("config.dap.codelldb.c"),
                        require("config.dap.cpptools.c")),
            cpp = merge(require("config.dap.codelldb.cpp"),
                        require("config.dap.cpptools.cpp")),
        },
    }
end
