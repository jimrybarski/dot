-- Detect work environment and set appropriate paths
local function is_work_environment()
    local stat = vim.uv.fs_stat("/opt/local")
    return stat and stat.type == "directory"
end

-- Install the "Lazy" plugin manager if it's not already installed.
local is_work = is_work_environment()
local data_dir = is_work and "/opt/local/share/nvim" or vim.fn.stdpath("data")
local lazypath = data_dir .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Recursively load configuration files
local function load_lua_files(directory)
    -- Load .lua files in current directory
    local glob_pattern = vim.fn.stdpath('config') .. '/lua/' .. directory .. '/*.lua'
    local files = vim.fn.glob(glob_pattern, false, true)
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
load_lua_files('configs')
require('config')
-- require('snippets')
-- require('completion')
-- require('functions')
load_lua_files('keymaps')
require('lsp')
-- require('autocommands')
-- require('pinyin')
-- require('science')
