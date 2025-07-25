vim.keymap.set("n", "\\", ":HopChar1<CR>", { desc = "Hop to character" })
vim.keymap.set("o", "\\", ":HopChar1<CR>", { desc = "Hop to character (operator)" })

vim.keymap.set('n', '<leader>k', function()
    local Snacks = require("snacks")
    Snacks.notifier.hide()
end, { desc = 'Dismiss all notifications' })

vim.keymap.set('n', '<leader>vh', function()
    local gitsigns = require('gitsigns')
    gitsigns.toggle_word_diff()
    gitsigns.toggle_linehl()
end, { desc = 'Toggle git word diff and line highlights' })

-- vim.keymap.set("n", "H", "^", { desc = "Go to first non-blank character" })
-- vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })
--
-- vim.keymap.set('v', '<leader>y', '"+y', { desc = "Yank to system clipboard", silent = true })
-- vim.keymap.set('n', '<leader>g', ':Telescope live_grep<cr>', { desc = "Live grep search", silent = true })
-- vim.keymap.set('n', '<leader>ff', ":Telescope find_files<cr>", { desc = "Find files", silent = true })
-- vim.keymap.set('n', '<leader>fk', ':Telescope keymaps<cr>', { desc = "Find keymaps", silent = true })
-- vim.keymap.set('n', '<leader>fe', ':Telescope emoji<cr>', { desc = "Find emoji", silent = true })
-- vim.keymap.set('n', '<leader>c', ':split $HOME/.config/nvim/init.lua<cr>', { desc = "Open nvim config", silent = true })
-- vim.keymap.set('n', '<C-S-j>', '1<C-w>+', { desc = "Increase window height", silent = true })
-- vim.keymap.set('n', '<C-S-k>', '1<C-w>-', { desc = "Decrease window height", silent = true })
-- vim.keymap.set('n', '<C-S-h>', '1<C-w><', { desc = "Decrease window width", silent = true })
-- vim.keymap.set('n', '<C-S-l>', '1<C-w>>', { desc = "Increase window width", silent = true })
--
-- vim.keymap.set('n', '<Esc>', ':nohl<cr>:echo<cr>', { desc = "Clear search highlight", silent = true })
--
-- vim.keymap.set("n", "x", '"_x', { desc = "Delete character without yanking", silent = true })
-- vim.keymap.set("n", "c", '"_c', { desc = "Change without yanking", silent = true })
-- vim.keymap.set("n", "dd", "v:lua.check_line()", { desc = "Delete line (smart)", expr = true })
--
-- vim.keymap.set('n', '<leader>z', '0:lua OpenWiktionary()<CR>',
--     { desc = "Open Wiktionary for current word", silent = true })
--
-- vim.keymap.set('n', '<leader>vb', ':Gitsigns blame_line<CR>', { desc = "Git blame current line", silent = true })
-- vim.keymap.set('n', '<leader>vh', ':Gitsigns toggle_linehl<CR>', { desc = "Toggle git line highlighting", silent = true })
-- vim.keymap.set('n', '<leader>vv', ':Neogit<CR>', { desc = "Open Neogit", silent = true })
-- vim.keymap.set('i', '<C-p>', '<C-r>"', { desc = "Paste from default register in insert mode", silent = true })
