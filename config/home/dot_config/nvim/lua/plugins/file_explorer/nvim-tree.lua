-- Simple file manager with tree view.

 -- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Function used to print path of the directory/file
function Print_node_path()
    local api = require("nvim-tree.api")
    local node = api.tree.get_node_under_cursor()
    print(node.absolute_path)
end

-- Function which is run upon creating nvim-tree buffer
local function on_attach(bufnr)

    -- Functions used for shortening declarations of keymappings in on_attach method
    local function opts(desc)
        return { desc = desc, buffer = bufnr, silent = true, nowait = true }
    end

    local function opts_no_desc()
        return { buffer = bufnr, silent = true, nowait = true }
    end

    local api = require("nvim-tree.api")
    local map = require("map")

    -- Keymappings
  map.map('n', '?',     api.tree.toggle_help,               opts('Help'))
  map.map('n', 'q',     api.tree.close,                     opts('Close'))
  map.map('n', '<CR>',  api.node.open.edit,                 opts('Open [zo]'))
  map.map('n', 'zo',    api.node.open.edit,                 opts_no_desc()) -- ranger compatibility
  map.map('n', 'zc',    api.node.navigate.parent_close,     opts('Close Directory'))
  map.map('n', 'zm',    api.tree.collapse_all,              opts('Collapse'))
  map.map('n', 'zr',    api.tree.expand_all,                opts('Expand All'))
  map.map('n', '<C-h>', api.tree.toggle_hidden_filter,      opts_no_desc())
  map.map('n', 'rt',    api.node.open.tab,                  opts('Open: New Tab'))
  map.map('n', 'ry',    api.node.open.vertical,             opts('Open: Vertical Split'))
  map.map('n', 'rx',    api.node.open.horizontal,           opts('Open: Horizontal Split'))
  map.map('n', 'rp',    api.node.open.preview,              opts('Open Preview'))
  map.map('n', 'yy',    api.fs.copy.node,                   opts('Copy'))
  map.map('n', 'a',     api.fs.rename,                      opts('Rename Filename (Append)'))
  map.map('n', 'cn',    api.fs.rename_sub,                  opts('Rename Filename'))
  map.map('n', 'cb',    api.fs.rename_basename,             opts('Rename Basename'))
  map.map("n", "cp",    api.fs.rename_full,                 opts("Rename: Full Path"))
  map.map('n', 'p',     Print_node_path,                    opts('Print path'))
  map.map('n', 'yp',    api.fs.copy.absolute_path,          opts('Copy Absolute Path'))
  map.map('n', 'yP',    api.fs.copy.relative_path,          opts('Copy Relative Path'))
  map.map("n", "yb",    api.fs.copy.basename,               opts("Copy Basename"))
  map.map('n', 'yn',    api.fs.copy.filename,               opts('Copy Name'))
  map.map('n', 'pp',    api.fs.paste,                       opts('Paste'))
  map.map('n', 'dd',    api.fs.cut,                         opts('Cut'))
  map.map('n', 'dD',    api.fs.remove,                      opts('Delete'))
  map.map('n', 'DD',    api.fs.trash,                       opts('Trash'))
  map.map('n', 'cd',    api.tree.change_root_to_node,       opts('Change Directory'))
  map.map('n', 'cr',    api.tree.change_root_to_parent,     opts('Change Root to parent dir'))
  map.map('n', 'i',     api.node.show_info_popup,           opts('Info'))
  map.map('n', '<C-j>', api.node.navigate.sibling.next,     opts('Next Sibling'))
  map.map('n', '<C-k>', api.node.navigate.sibling.prev,     opts('Previous Sibling'))
  map.map('n', 'J',     api.node.navigate.sibling.last,     opts('Last Sibling'))
  map.map('n', 'K',     api.node.navigate.sibling.first,    opts('First Sibling'))
  map.map('n', ':',     api.node.run.cmd,                   opts('Run Command'))
  map.map('n', 'm',     api.marks.toggle,                   opts('Toggle Bookmark'))
  map.map('n', 'M',     api.marks.bulk.move,                opts('Move Bookmarked'))
  map.map('n', 'f',     api.live_filter.start,              opts('Filter'))
  map.map('n', 'F',     api.live_filter.clear,              opts('Clean Filter'))
  map.map('n', 'C',     api.fs.create,                      opts('Create file/directory'))
  map.map('n', 'R',     api.tree.reload,                    opts('Refresh'))
  map.map('n', 'S',     api.tree.search_node,               opts('Search')) -- ??
  map.map('n', 'B',     api.tree.toggle_no_buffer_filter,   opts('Toggle No Buffer'))
  map.map('n', 'H',     api.node.navigate.parent,           opts('Parent Directory'))
  map.map('n', 's',     api.node.run.system,                opts('Run System'))
  map.map('n', 'U',     api.tree.toggle_custom_filter,      opts('Toggle Hidden'))
  map.map('n', '[c',    api.node.navigate.git.prev,         opts('Prev Git'))
  map.map('n', ']c',    api.node.navigate.git.next,         opts('Next Git'))
  map.map('n', ']e',    api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
  map.map('n', '[e',    api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
  map.map('n', 'th',    api.tree.toggle_hidden_filter,      opts('Toggle Hidden [<C-h>]'))
  map.map('n', 'tgc',   api.tree.toggle_git_clean_filter,   opts('Toggle Git Clean'))
  map.map('n', 'tgi',   api.tree.toggle_gitignore_filter,   opts('Toggle Git Ignore'))
  --vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  --vim.keymap.set("n", "bd",    api.marks.bulk.delete,                 opts("Delete Bookmarked"))
  --vim.keymap.set("n", "bt",    api.marks.bulk.trash,                  opts("Trash Bookmarked"))
  --vim.keymap.set("n", "L",     api.node.open.toggle_group_empty,      opts("Toggle Group Empty"))
  --vim.keymap.set("n", "M",     api.tree.toggle_no_bookmark_filter,    opts("Toggle Filter: No Bookmark"))
  --vim.keymap.set("n", "O",     api.node.open.no_window_picker,        opts("Open: No Window Picker"))

  map.map('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  map.map('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
end

return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    cmd = { "NvimTreeToggle", "NvimTreeFindFileToggle" },
    keys = function()
        local map = require("map")

        map.map('n', '<leader>E', ":NvimTreeToggle<CR>",   { desc = "[E]xplore files tree - toggle tree view" })

        map.group(   '<leader>t',                                          { group = "[t]TREE" })
        map.map('n', '<leader>tt', map.cmd('NvimTreeToggle'),              { desc  = "[t]oggle" })
        map.map('n', '<leader>tr', map.cmd('NvimTreeRefresh'),             { desc  = "[r]efresh" })
        map.map('n', '<leader>tl', map.cmd('NvimTreeFindFile'),            { desc  = "[l]ocate current file" })
        map.map('n', '<leader>tf', map.cmd('NvimTreeFocus'),               { desc  = "[f]ocus" })
        map.map('n', '<leader>tc', map.cmd('NvimTreeCollapseKeepBuffers'), { desc  = "[C]ollapse all (keep buffers)" })
        map.map('n', '<leader>tC', map.cmd('NvimTreeCollapse'),            { desc  = "[c]ollapse all" })

        return map.exportKeys()
    end,
    config = function()
        require("nvim-tree").setup({
            on_attach = on_attach, -- required for custom keybindings
            sort_by = "case_sensitive",
            disable_netrw = false,
            hijack_netrw = false,
            sync_root_with_cwd = false,
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = false,
            },
        })
    end
}

-- TODO:
--   * add mappings for all internal commands
--   * add mappings for normal commands, see: h vim-tree-commands.
--     Probably only: NvimTreeCollapse, NvimTreeCollapseKeepBuffers
--   * fix zm, zr bindings using collapse_all - generally a lot of
--     these actions take parameters for additional configuration.
--   * which-key doesn't work correctly
