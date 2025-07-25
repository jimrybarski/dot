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
require('plugins')
require('config')
-- require('snippets')
-- require('completion')
-- require('functions')
require('keymaps')
-- require('lsp')
-- require('autocommands')
-- require('pinyin')
-- require('science')
