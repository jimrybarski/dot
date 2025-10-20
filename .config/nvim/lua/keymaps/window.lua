-- Resize windows
vim.keymap.set('n', '<C-S-j>', '1<C-w>+', { desc = "Increase window height", silent = true })
vim.keymap.set('n', '<C-S-k>', '1<C-w>-', { desc = "Decrease window height", silent = true })
vim.keymap.set('n', '<C-S-h>', '1<C-w><', { desc = "Decrease window width", silent = true })
vim.keymap.set('n', '<C-S-l>', '1<C-w>>', { desc = "Increase window width", silent = true })
vim.keymap.set('n', '<C-q>', ':qa!<cr>', { desc = "Force quit Neovim", silent = true })
