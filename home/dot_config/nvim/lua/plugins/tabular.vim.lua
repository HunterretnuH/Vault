return {
    'godlygeek/tabular',
    keys = {
        { 'gA', ':Tabularize /', desc = "Align (tabularize)", mode = {'n', 'v'} }
    },
    config = function()
        vim.cmd('AddTabularPattern comma1 /^[^,]*\zs,/l1c1l1')
        vim.cmd('AddTabularPattern curlyBracket1 /^[^,]*\zs{/l1c1l1')
    end

}
-- TODO: Find better replacement plugin
