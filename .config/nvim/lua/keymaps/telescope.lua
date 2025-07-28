-- search for strings
vim.keymap.set('n', '<leader>g', ':Telescope live_grep<cr>', { desc = "Live grep search", silent = true })
-- search for files
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<cr>', { desc = "Find files", silent = true })
-- search through a list of all active keymaps
vim.keymap.set('n', '<leader>fk', ':Telescope keymaps<cr>', { desc = "Find keymaps", silent = true })
