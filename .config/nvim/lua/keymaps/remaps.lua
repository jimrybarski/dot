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
