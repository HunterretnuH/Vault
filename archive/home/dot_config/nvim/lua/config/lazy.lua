-- From: https://lazy.folke.io/installation

-- Scans provided root_dir recursively for *.lua files and returns list of directories containing them.
local function get_lua_dirs(root_dir, prefix)
    local luv = vim.loop
    local dirs = {}

    local function scan(path, mod_prefix)
        local fd = luv.fs_scandir(path)
        if not fd then return end

        local has_lua_file = false

        for name, t in function() return luv.fs_scandir_next(fd) end do
            local full = path .. "/" .. name
            if (t == "file" or t =="link") and name:match("%.lua$") then
                has_lua_file = true
            elseif t == "directory" then
                scan(full, mod_prefix .. "." .. name)
            end
        end

        if has_lua_file then
            table.insert(dirs, mod_prefix)
        end
    end

    scan(root_dir, prefix)
    return dirs
end

-- Scans <config_dir>/lua/plugins recursively for *.lua files and returns specs for lazy.nvim with imports
local function get_plugins(plugins_dir) 
    local root = vim.fn.stdpath("config") .. "/lua/" .. plugins_dir
    local plugin_dirs = get_lua_dirs(root, plugins_dir)

    -- Convert to lazy.nvim specs
    local specs = {}
    for _, mod in ipairs(plugin_dirs) do
        table.insert(specs, { import = mod })
    end
    return specs
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- im.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = get_plugins(vim.g.vscode and "plugins_vscode" or "plugins"),
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})

local ok, map = pcall(require, "map")
if ok then
    map.map('n', '<leader>ap', map.cmd('Lazy'), { desc = '[p]lugin manager'} )
end
