-- Show relative line numbers except on the current line, which shows the absolute line number
vim.opt.number = true
vim.opt.relativenumber = true

-- Don't make annoying backup files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Always show the sign column (the column on the left that shows lint warnings and git changes)
vim.opt.signcolumn = "yes"

-- Faintly highlight the line the cursor is on
vim.opt.cursorline = true

-- Use larger color palette
vim.opt.termguicolors = true

-- Milliseconds to wait to trigger CursorHold
vim.opt.updatetime = 500

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.completeopt = "menu,menuone,preview,noselect"

-- Keep the cursor near the center of the screen; also ensures signature help popup always fits below
vim.opt.scrolloff = 10

-- Highlight the 121st column; maximum line length is 120
vim.opt.colorcolumn = "121"

-- Leave autoindentation to treesitter
vim.opt.smartindent = false

-- Wrapped text starts at the same indentation level as the first line
vim.opt.breakindent = true

-- Open new splits down or to the right
vim.opt.splitright = true
vim.opt.splitbelow = true

-- pylsp is installed in this virtual environment
vim.g.python3_host_prog = vim.fn.expand("$HOME/.local/pylspenv/bin/python3")

-- Prevent warning with files containing the text "vim:"
vim.opt.modeline = false

vim.opt.clipboard = "unnamedplus"

-- Ensure :e opens files in current buffer, not new splits
vim.opt.switchbuf = "useopen"

-- Popups should have rounded borders by default
vim.opt.winborder = "rounded"

-- Persist a terminal buffer even after it's been hidden
vim.opt.hidden = true

-- Use POSIX sh for vim.fn.system/systemlist, not Fish
vim.opt.shell = "/usr/bin/env sh"
