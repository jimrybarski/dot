-- Install the "Lazy" plugin manager if it's not already installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Recursively load configuration files
local function load_lua_files(directory)
    -- Load .lua files in current directory
    local files = vim.fn.glob(vim.fn.stdpath('config') .. '/lua/' .. directory .. '/*.lua', false, true)
    for _, file in ipairs(files) do
        local module = file:match('.*/lua/(.*)%.lua$'):gsub('/', '.')
        require(module)
    end
    
    -- Load subdirectories
    local dirs = vim.fn.glob(vim.fn.stdpath('config') .. '/lua/' .. directory .. '/*/', false, true)
    for _, dir in ipairs(dirs) do
        local subdir = dir:match('.*/(.*)/'):gsub('/$', '')
        local full_subdir = directory == '' and subdir or directory .. '/' .. subdir
        load_lua_files(full_subdir)
    end
end

-- The order of these imports is not arbitrary as there are dependencies between certain files. Change with caution.
-- Sets universal neovim options.
require('options')
require('plugins')
require('config')
-- require('snippets')
-- require('completion')
-- require('functions')
load_lua_files('keymaps')
-- require('lsp')
-- require('autocommands')
-- require('pinyin')
-- require('science')
