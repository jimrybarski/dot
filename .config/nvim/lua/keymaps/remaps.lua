-- These just remap unergonomic actions to something more pleasant
vim.keymap.set("n", "H", "^", { desc = "Go to first non-blank character" })
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })
vim.keymap.set('v', '<leader>y', '"+y', { desc = "Yank to system clipboard", silent = true })
vim.keymap.set('i', '<C-p>', '<C-r>"', { desc = "Paste from default register in insert mode", silent = true })
