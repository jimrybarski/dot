vim.api.nvim_set_keymap("n", "\\", ":HopChar1<CR>", {noremap = true})
vim.api.nvim_set_keymap("o", "\\", ":HopChar1<CR>", {noremap = true})

-- copy selection to system clipboard
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>g', ':Telescope live_grep<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ff', ":Telescope find_files<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fk', ':Telescope keymaps<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fm', ':Telescope man_pages<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fe', ':Telescope emoji<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>c', ':split $HOME/.config/nvim/init.lua<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ns', ':split /tmp/scratch-notes.txt<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-S-j>', '1<C-w>-', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-S-k>', '1<C-w>+', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-S-h>', '1<C-w><', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-S-l>', '1<C-w>>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>tt', ':lua RunUntilFirstFailingTest()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ta', ':lua RunAllTests()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>tv', ':lua RunUntilFirstFailingVerboseTest<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>tm', ':lua RunMutationTests()<cr>', {noremap = true, silent = true})
-- remove search highlight with escape
vim.api.nvim_set_keymap('n', '<Esc>', ':nohl<cr>:echo<cr>', { noremap = true, silent = true })
-- prevent register from being filled with empty strings or other things we never want to paste later
vim.api.nvim_set_keymap("n", "x", '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "c", '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "dd", "v:lua.check_line()", {expr = true, noremap = true})
-- Chinese
vim.api.nvim_set_keymap('n', '<leader>z', '0:lua OpenWiktionary()<CR>', { noremap = true, silent = true })

-- Show the last commit (author, timestamp and commit message) that changed the current line
vim.api.nvim_set_keymap('n', '<leader>vb', ':Gitsigns blame_line<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>vh', ':Gitsigns toggle_linehl<CR>',
                        {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>vv', ':Neogit<CR>',
                        {noremap = true, silent = true})

