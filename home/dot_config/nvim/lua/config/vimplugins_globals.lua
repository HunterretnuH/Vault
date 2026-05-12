
--#1 Wiki related variables
local env = require("env")
vim.g.wiki_root = env.wiki.primary_wiki_path
vim.g.wiki_filetypes = { "md" }
vim.g.wiki_link_extension = ".md"
vim.g.wiki_link_target_type = "md"
vim.g.wiki_mappings_use_defaults = 'local'
vim.g.wiki_mappings_prefix = '<leader>W'
vim.g.wiki_export = {
    args = "",
    from_format = "markdown",
    ext = "html",
    link_ext_replace = true,
    view = false,
    output = vim.fn.fnamemodify(vim.fn.tempname(), ":h"),
}
