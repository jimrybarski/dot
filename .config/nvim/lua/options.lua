-- Set leader keys to spacebar
vim.g.mapleader = " "
vim.g.maplocalleader = ","
-- Show relative line numbers except on the current line, which shows the absolute line number
vim.opt.number = true
vim.opt.relativenumber = true
-- Don't make annoying backup files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
-- Always show the sign column (the column on the left that shows lint warnings and git changes)
-- Otherwise it will appear/disappear frequently, which is annoying
vim.opt.signcolumn = "yes"
-- Faintly highlight the line the cursor is on
vim.opt.cursorline = true
-- Use larger color palette
vim.opt.termguicolors = true
-- Milliseconds to wait to trigger CursorHold
vim.opt.updatetime = 500
-- Set the number of spaces that a tab character represents. 
-- When you press the tab key, it will insert spaces equal to this number.
vim.opt.tabstop = 4

-- Set the number of spaces to use for each step of (auto)indent. 
-- This affects commands like >>, <<, ==, etc.
vim.opt.shiftwidth = 4

-- When inserting a tab, it will act as if it's made up of spaces equal to this number.
-- This helps in aligning with the tabstop when using spaces in place of tabs.
vim.opt.softtabstop = 4

-- Make the tab key insert spaces instead of a tab
vim.opt.expandtab = true

-- menu, menuone: show the completion menu if there are one or more matches
-- preview: show extra information about a selection
-- noinsert: don't insert text until a selection is made
-- noselect: don't select a match automatically
vim.opt.completeopt = "menu,menuone,preview,noselect"

-- keep the cursor in the center of the screen (if there is space)
vim.opt.scrolloff = 6

-- highlight the 120th column
vim.opt.colorcolumn = "120"

-- autoindent in codebases
vim.opt.smartindent = false  -- leave autoindentation up to treesitter

-- wrapped text starts at the same level of indentation as the first line
vim.opt.breakindent = true

-- open new splits down or to the right
vim.opt.splitright = true
vim.opt.splitbelow = true

local utils = require('utils')
local local_dir = utils.get_local_dir()
vim.g.python3_host_prog = local_dir .. "/pylspenv/bin/python3"

vim.opt.modeline = false -- prevent warning with files containing the text "vim:"

vim.opt.clipboard = "unnamedplus"

-- Ensure :e opens files in current buffer, not new splits
vim.opt.switchbuf = "useopen"

-- Popups should have rounded borders by default
vim.opt.winborder = 'rounded'

-- Persists a terminal even after its been hidden
vim.opt.hidden = true

-- Ensure we don't use Fish for vim.fn.system/systemlist
vim.opt.shell = "/bin/sh"
