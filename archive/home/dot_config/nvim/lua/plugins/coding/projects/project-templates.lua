return {
    "pianocomposer321/project-templates.nvim",
    build = ':UpdateRemotePlugins',
    lazy = false, -- temporary, generally this plugin doesn't work now
    keys = function()
        local map = require('map')
        map.group(   '<leader>pt',                         { group = "[t]EMPLATES" } )  
        map.map('n', '<leader>ptl', ':LoadTemplate<CR>',   { desc  = "[l]oad", remap = false }) -- Load a template into a new project.
        map.map('n', '<leader>ptd', ':DeleteTemplate<CR>', { desc  = "[d]elete", remap = false }) -- Delete a template
        map.map('n', '<leader>ptc', ':SaveAsTemplate<CR>', { desc  = "[s]ave", remap = false }) -- Save the current folder and all files and subfolders as a new template
        return map.exportKeys()
    end
}

-- TODO: Add tempates.nvim and integrate in reasonable way so that I could do i.e.
--           * load project template BASH;
--           * go to main.sh, rename it if necessary;
--           * Template bash_arg_program
