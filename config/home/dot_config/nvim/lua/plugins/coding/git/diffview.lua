 return {
     'sindrets/diffview.nvim',
    cmds = { 'DiffviewOpen', 'DiffviewToggleFiles' },
    keys = function ()
        local neogit = require('neogit')
        local map = require('map')
        local diffviewOpenCustom = function()
            local revision = vim.fn.input("Revision: ")
            local paths = vim.fn.input("Paths to check: ", vim.fn.getcwd() .. "/", "file")
            vim.cmd('DiffviewOpen ' .. revision .. " -- ", paths)
        end

        local diffviewFileHistoryCustom = function()
            local command = vim.fn.input("[paths] [options]: ")
            vim.cmd('DiffviewOpen ' .. command)
        end

        map.map({'n'}, '<leader>dd', map.cmd('DiffviewOpen'),        { desc = '[d]iff view open' })
        map.map({'n'}, '<leader>dD', diffviewOpenCustom,             { desc = '[D]iff view open - custom rev/filter' })
        map.map({'n'}, '<leader>dh', map.cmd('DiffviewFileHistory'), { desc = '[h]istory show - file history' })
        map.map({'n'}, '<leader>dH', diffviewFileHistoryCustom,      { desc = '[H]istory show - custom path' })
        map.map({'n'}, '<leader>dq', map.cmd('DiffviewClose'),       { desc = '[q]uit diff view' })
        map.map({'n'}, '<leader>df', map.cmd('DiffviewToggleFiles'),{ desc = '[f]iles panel toggle' })
        map.map({'n'}, '<leader>dF', map.cmd('DiffviewFocusFiles'), { desc = '[F]iles panel focus' })
        map.map({'n'}, '<leader>dr', map.cmd('DiffviewRefresh'),    { desc = '[r]efresh current diffview' })

        return map.exportKeys()
    end
 }


