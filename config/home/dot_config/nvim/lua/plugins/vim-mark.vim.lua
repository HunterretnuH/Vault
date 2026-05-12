return {
    'inkarkat/vim-mark',
    dependencies = { 'inkarkat/vim-ingo-library' },
    lazy = false,
    keys = {
        -- No default mapping for Mark
        { '<Leader>mM', ':Mark<space>',                desc = "?" },
        -- No default mapping for Marks
        { '<Leader>mp', '<cmd>Marks<cr>',              desc = "[p]review marks" },
        { '<Leader>mn', ':MarkName<space>',            desc = "[n]ame mark" },
        { '<Leader>ms', ':MarkSave<space>',            desc  = "[s]ave marks" },
        { '<Leader>ml', ':MarkLoad<space>',            desc  = "[l]oad marks" },
        -- No default mapping for MarkPalette
        -- No default mapping for MarkYankDefinitions
        -- No default mapping for MarkYankDefinitionsOneLiner
        { '<Leader>mm', '<plug>MarkSet',               desc  = "[m]ark set/remove", mode = {'n', 'x'}   },
        -- No defult mapping for <Plug>MarkIWhiteSet.
        { '<Leader>mr', '<plug>MarkRegex',             desc  = "[r]egex mark", mode = {'n', 'x'} },
        { '<Leader>mc', '<plug>MarkConfirmAllClear',   desc  = "[c]lear all marks (requires confirmation)" },
        -- No default mapping for '<Plug>MarkAllClear / MarkClear.
        { '<Leader>mC', '<cmd>MarkClear<cr>',          desc  = "[C]lear all marks" },
        -- No default mapping for <Plug>MarkConfirmAllClear.
        { '<Leader>mt', '<Plug>MarkToggle',            desc  = "[t]oggle mark display" },
        -- { '<Leader>*',  '<plug>MarkSearchCurrentNext', desc  = "[*] next mark" },
        -- { '<Leader>#',  '<plug>MarkSearchCurrentPrev', desc  = "[#] prev mark" },
        -- { '<Leader>/',  '<plug>MarkSearchAnyNext',     desc  = "[/] next mark" },
        -- { '<Leader>?',  '<plug>MarkSearchAnyPrev',     desc  = "[?] prev mark", unique = true },
        -- { '*',          '<plug>MarkSearchNext',        desc  = "[*] next mark (on mark)" },
        -- { '#',          '<plug>MarkSearchPrev',        desc  = "[#] prev mark (on mark)" },
        -- No default mapping for <Plug>MarkSearchOrCurNext
        -- No default mapping for <Plug>MarkSearchOrCurPrev
        -- No default mapping for <Plug>MarkSearchOrAnyNext
        -- No default mapping for <Plug>MarkSearchOrAnyPrev
        -- No default mapping for <Plug>MarkSearchAnyOrDefaultNext
        -- No default mapping for <Plug>MarkSearchAnyOrDefaultPrev
        -- No default mapping for <Plug>MarkSearchGroupNext
        -- No default mapping for <Plug>MarkSearchGroupPrev
        -- No default mapping for <Plug>MarkSearchUsedGroupNext
        -- No default mapping for <Plug>MarkSearchUsedGroupPrev
    },
    init = function()

        -- Part of nvim config loaded before plugins are loaded
        --
        -- --} VIM-MARK
        -- Extended palette
        vim.g.mwDefaultHighlightingPalette = 'extended'
        -- To enable(1) or disable(0) the automatic restore of marks from a previous Vim session:
        vim.g.mwAutoLoadMarks = 1
        -- If you want no or only a few of the available mappings, you can completely turn off the creation of the default mappings by defining:
        vim.g.mw_no_mappings = 1
        -- By default, any marked words are also added to the search (/) and input (@) history; if you don't want that, remove the corresponding symbols from:
        vim.g.mwHistAdd = '/@'
        -- By default, tab pages / windows / buffers that have t:nomarks / w:nomarks / b:nomarks with a true value are excluded. Therefore, to suppress mark highlighting in a buffer, you can simply
        --vim.g.nomarks = 1
    end,
}

-- DEFAULT MAPPINGS (from plugin script):
   -- No default mapping for Mark
   -- No default mapping for Marks
   -- No default mapping for MarkName
   -- No default mapping for MarkSave
   -- No default mapping for MarkLoad
   -- No default mapping for MarkClear
   -- No default mapping for MarkPalette
   -- No default mapping for MarkYankDefinitions
   -- No default mapping for MarkYankDefinitionsOneLiner
   -- nmap <unique> <Leader>m <Plug>MarkSet
   -- xmap <unique> <Leader>m <Plug>MarkSet
   -- No default mapping for <Plug>MarkIWhiteSet.
   -- nmap <unique> <Leader>r <Plug>MarkRegex
   -- xmap <unique> <Leader>r <Plug>MarkRegex
   -- nmap <unique> <Leader>n <Plug>MarkClear
   -- No default mapping for <Plug>MarkAllClear.
   -- No default mapping for <Plug>MarkConfirmAllClear.
   -- No default mapping for <Plug>MarkToggle.
   -- nmap <unique> <Leader>* <Plug>MarkSearchCurrentNext
   -- nmap <unique> <Leader># <Plug>MarkSearchCurrentPrev
   -- nmap <unique> <Leader>/ <Plug>MarkSearchAnyNext
   -- nmap <unique> <Leader>? <Plug>MarkSearchAnyPrev
   -- nmap <unique> * <Plug>MarkSearchNext
   -- nmap <unique> # <Plug>MarkSearchPrev
   -- No default mapping for <Plug>MarkSearchOrCurNext
   -- No default mapping for <Plug>MarkSearchOrCurPrev
   -- No default mapping for <Plug>MarkSearchOrAnyNext
   -- No default mapping for <Plug>MarkSearchOrAnyPrev
   -- No default mapping for <Plug>MarkSearchAnyOrDefaultNext
   -- No default mapping for <Plug>MarkSearchAnyOrDefaultPrev
   -- No default mapping for <Plug>MarkSearchGroupNext
   -- No default mapping for <Plug>MarkSearchGroupPrev
   -- No default mapping for <Plug>MarkSearchUsedGroupNext
   -- No default mapping for <Plug>MarkSearchUsedGroupPrev

-- TODO: This plugin has problems with the way noice.nvim displayes messages.
--       It's probably better to rewrite it to neovim.
