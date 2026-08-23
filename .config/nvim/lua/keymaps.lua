-- HOP
-- Move the cursor to any character on the screen
vim.keymap.set("n", "\\", ":HopChar1<CR>", { desc = "Hop to character" })
-- This lets you use hop as a motion, so you can do things like `d\x` which would delete from the cursor to the selected occurence of the character `x` 
vim.keymap.set("o", "\\", ":HopChar1<CR>", { desc = "Hop to character (operator)" })

-- GIT
-- Highlight lines and words that have changed since the last commit
vim.keymap.set('n', '<leader>vh', function()
    local gitsigns = require('gitsigns')
    gitsigns.toggle_word_diff()
    gitsigns.toggle_linehl()
end, { desc = 'Toggle git word diff and line highlights' })

-- Show the blame message for the current line
vim.keymap.set('n', '<leader>vb', ':Gitsigns blame_line<CR>', { desc = "Git blame current line", silent = true })
-- Open the Git TUI
vim.keymap.set('n', '<leader>vv', ':Neogit<CR>', { desc = "Open Neogit", silent = true })

-- NOTIFICATIONS
vim.keymap.set('n', '<leader>k', function()
    local Snacks = require("snacks")
    Snacks.notifier.hide()
end, { desc = 'Dismiss all notifications' })

-- REMAPS
-- These just remap unergonomic actions to something more pleasant
vim.keymap.set("n", "H", "^", { desc = "Go to first non-blank character" })
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })
vim.keymap.set('v', '<leader>y', '"+y', { desc = "Yank to system clipboard", silent = true })
vim.keymap.set('i', '<C-p>', '<C-r>"', { desc = "Paste from default register in insert mode", silent = true })

-- Move lines up/down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = "Move line down", silent = true })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = "Move line up", silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- SAFE DELETE
-- Don't overwrite clipboard contents with empty lines
function _G.check_line()
    if vim.fn.getline(".") == "" then
        return '"_dd'
    else
        return 'dd'
    end
end

vim.keymap.set("n", "x", '"_x', { desc = "Delete character without yanking", silent = true })
vim.keymap.set("n", "c", '"_c', { desc = "Change without yanking", silent = true })
vim.keymap.set("n", "dd", "v:lua.check_line()", { desc = "Delete line (smart)", expr = true })


-- TELESCOPE
-- search for strings
vim.keymap.set('n', '<leader>g', ':Telescope live_grep<cr>', { desc = "Live grep search", silent = true })
-- search for files
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<cr>', { desc = "Find files", silent = true })
-- search through a list of all active keymaps
vim.keymap.set('n', '<leader>fk', ':Telescope keymaps<cr>', { desc = "Find keymaps", silent = true })


-- NOTES
-- Creating notes and moving along the timeline (lua/notes.lua)
vim.keymap.set('n', '<localleader>n', function() require('notes').new() end, { desc = "New note" })
vim.keymap.set('n', '<localleader>l', function() require('notes').latest() end, { desc = "Open latest note" })
vim.keymap.set('n', ']n', function() require('notes').newer() end, { desc = "Next (newer) note" })
vim.keymap.set('n', '[n', function() require('notes').older() end, { desc = "Previous (older) note" })

-- Browsing by frontmatter, since every note filename is just a timestamp
-- vim.keymap.set('n', '<localleader>nt', function() require('notes').titles() end, { desc = "Find note by title" })
-- vim.keymap.set('n', '<localleader>nb', function() require('notes').bookmarks() end, { desc = "Find bookmarked note" })
vim.keymap.set('n', '<localleader>i', function() require('notes').insert_link() end, { desc = "Insert link to note" })
-- Filenames are permanent timestamps, so "rename" means the frontmatter title
vim.keymap.set('n', '<localleader>r', function() require('notes').retitle() end, { desc = "Retitle note" })

vim.keymap.set('n', '<localleader>g', function() require('notes').grep() end, { desc = "Search note contents" })

-- Search and navigation provided by telekasten
vim.keymap.set('n', '<localleader>t', ':Telekasten show_tags<CR>', { desc = "Find notes by tag", silent = true })
-- Jumps straight to [[<stamp>]] links; anything else falls through to telekasten
-- vim.keymap.set('n', '<localleader>nf', function() require('notes').follow() end, { desc = "Follow link under cursor" })
vim.keymap.set('n', '<localleader>b', ':Telekasten show_backlinks<CR>', { desc = "Show backlinks to this note", silent = true })

-- AGENDA
-- markdown-agenda only reads: <CR> jumps to the task, <Tab> folds a section,
-- q or <Esc> closes it. Everything that writes is lua/agenda.lua, and the same
-- four actions are mapped inside the agenda window (autocommands.lua).
vim.keymap.set('n', '<localleader>a', ':MarkdownAgenda<CR>', { desc = "Open agenda", silent = true })

-- On a line that isn't a task yet, any of these makes it one first
vim.keymap.set('n', '<localleader>x', function() require('agenda').here('done') end, { desc = "Toggle task done" })
vim.keymap.set('n', '<localleader>p', function() require('agenda').here('progress') end, { desc = "Toggle task in progress" })
-- Prompts take 2026-08-05, today, tomorrow, +3d, 2w, +1m or a weekday name;
-- submitting it empty clears the date
vim.keymap.set('n', '<localleader>s', function() require('agenda').here('scheduled') end, { desc = "Schedule task" })
vim.keymap.set('n', '<localleader>d', function() require('agenda').here('deadline') end, { desc = "Set task deadline" })


-- CALCULATOR
-- A floating scratch pad where every line is a qalc expression, evaluated live
-- into virtual text (lua/calculator.lua). q or <Esc> inside it close the float.
-- :QalcAttach turns any existing buffer into one, and :QalcYank copies the
-- result on the current line to a register.
vim.keymap.set('n', '<leader>c', function() require('calculator').open() end,
    { desc = "Open calculator" })


-- RESIZE WINDOWS
vim.keymap.set('n', '<C-S-j>', '1<C-w>+', { desc = "Increase window height", silent = true })
vim.keymap.set('n', '<C-S-k>', '1<C-w>-', { desc = "Decrease window height", silent = true })
vim.keymap.set('n', '<C-S-h>', '1<C-w><', { desc = "Decrease window width", silent = true })
vim.keymap.set('n', '<C-S-l>', '1<C-w>>', { desc = "Increase window width", silent = true })
vim.keymap.set('n', '<C-q>', ':qa!<cr>', { desc = "Force quit Neovim", silent = true })


local dap = require('dap')
-- Mark lines to pause at during debugging
vim.keymap.set('n', 'gb', dap.toggle_breakpoint, { desc = 'Toggle breakpoint'} )
vim.keymap.set('n', 'gB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = 'Set conditional breakpoint' })

-- Advance the program state
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Start/continue debugger'})
vim.keymap.set('n', '<F6>', dap.step_over, { desc = 'Step over'})
vim.keymap.set('n', '<F7>', dap.step_into, { desc = 'Step into'})
vim.keymap.set('n', '<F8>', dap.step_out, { desc = 'Step out'})
vim.keymap.set('n', '<F9>', function() require('dap-view').toggle(true) end, { desc = 'Toggle DAP view' })

-- SNIPPETS
-- Select mode mappings so Tab/S-Tab jump tabstops when a placeholder is highlighted
vim.keymap.set("s", "<Tab>", function()
    local ls = require("luasnip")
    if ls.jumpable(1) then ls.jump(1) end
end, { silent = true, desc = "Jump to next snippet tabstop" })
vim.keymap.set("s", "<S-Tab>", function()
    local ls = require("luasnip")
    if ls.jumpable(-1) then ls.jump(-1) end
end, { silent = true, desc = "Jump to previous snippet tabstop" })
