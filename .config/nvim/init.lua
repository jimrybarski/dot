-- Install the "Lazy" plugin manager if it's not already installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- The order of these imports is not arbitrary as there are dependencies between certain files. Change with caution.
-- Sets universal neovim options.
require('options')
-- Installs plugins.
require('plugins')
-- Configures autocomplete.
require('snippets')
-- Configures plugins.
require('completion')
-- Defines snippets.
require('config')
-- Defines functions.
require('functions')
-- Defines keymaps.
-- Note that some keymaps must be defined when the plugin is configured, see config.lua if you can't find one.
-- Also check lsp.lua for LSP-specific keymaps.
require('keymaps')
-- Configures LSPs and static analysis tools.
require('lsp')
-- Sets options based on the current buffer's filetype.
require('autocommands')
-- Functions to manipulate tone marks
require('pinyin')
-- Bioinformatics-related functionality
require('science')
