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
