vim.api.nvim_set_keymap("n", "H", "^", { noremap = true })
vim.api.nvim_set_keymap("n", "U", "<C-r>", { noremap = true })

vim.api.nvim_set_keymap("n", "\\", ":HopChar1<CR>", { noremap = true })
vim.api.nvim_set_keymap("o", "\\", ":HopChar1<CR>", { noremap = true })

-- copy between any two points in the current window
vim.api.nvim_set_keymap('n', '<leader>y', ':HopYankChar1<cr>', { noremap = true, silent = true })
-- paste text anywhere in the current window
vim.api.nvim_set_keymap('n', '<leader>p', ':HopPasteChar1<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>g', ':Telescope live_grep<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', ":Telescope find_files<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fk', ':Telescope keymaps<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fm', ':Telescope man_pages<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fe', ':Telescope emoji<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>c', ':split $HOME/.config/nvim/init.lua<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-j>', '1<C-w>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-k>', '1<C-w>-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-h>', '1<C-w><', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-S-l>', '1<C-w>>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tt', ':lua RunUntilFirstFailingTest()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ta', ':lua RunAllTests()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tv', ':lua RunUntilFirstFailingVerboseTest<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>tm', ':lua RunMutationTests()<cr>', { noremap = true, silent = true })

-- remove search highlight with escape
vim.api.nvim_set_keymap('n', '<Esc>', ':nohl<cr>:echo<cr>', { noremap = true, silent = true })

-- prevent register from being filled with empty strings or other things we never want to paste later
vim.api.nvim_set_keymap("n", "x", '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "c", '"_c', { noremap = true, silent = true })
-- only puts the line into the clipboard if it's non-empty
vim.api.nvim_set_keymap("n", "dd", "v:lua.check_line()", { expr = true, noremap = true })

-- Chinese
vim.api.nvim_set_keymap('n', '<leader>z', '0:lua OpenWiktionary()<CR>', { noremap = true, silent = true })

-- Version control
-- Show who committed the current line
vim.api.nvim_set_keymap('n', '<leader>vb', ':Gitsigns blame_line<CR>',
    { noremap = true, silent = true })
-- Color the background green for lines that have changed
vim.api.nvim_set_keymap('n', '<leader>vh', ':Gitsigns toggle_linehl<CR>',
    { noremap = true, silent = true })
-- Start the main Git interface
vim.api.nvim_set_keymap('n', '<leader>vv', ':Neogit<CR>',
    { noremap = true, silent = true })


-- In insert mode, Ctrl+<letter> will insert the "closest" Greek letter
-- I'm leaving some Greek letters unassigned because I don't ever see them
-- in my work, and I'd like to leave open the possibility of other insert
-- mode commands bound to Ctrl+<something>
local greek_letters = {
    a = "α",
    b = "β",
    c = "δ", -- mnemonic: c is less than d, δ is less than Δ
    d = "Δ",
    e = "Σ", -- mnemonic: Σ looks like E
    f = "φ",
    g = "γ",
    h = "θ", -- mnemonic: tHeta
    l = "λ",
    m = "μ",
    o = "Ω",
    p = "π",
    r = "ρ",
    s = "σ",
    w = "ε", -- mnemonic: w turned sideways
    x = "χ",
    y = "ψ", -- mnemonic: y looks like ψ
}

-- Assign the Greek letter keymaps
for k, v in pairs(greek_letters) do
    vim.api.nvim_set_keymap('i', '<C-' .. k .. '>', v, { noremap = true, silent = true })
end

-- paste the default register's contents while in insert mode
-- Mnemonic: Ctrl+' is Ctrl+" without the shift
vim.api.nvim_set_keymap('i', '<C-\'>', '<C-r>"', { noremap = true, silent = true })

-- close all notifications
vim.keymap.set({ 'n', 'v' }, '<leader>k', function()
    local notify = require("notify")
    notify.dismiss()
end, { noremap = true, silent = true })

vim.keymap.set('n', '<leader>r', '<cmd>Lazy reload<CR>', { desc = 'Reload config' })

-- <leader> or, of and oi are taken by telescope-orgmode
vim.keymap.set('n', '<leader>ocw', '<cmd>Org capture w<CR>', { desc = 'Capture work note' })
vim.keymap.set('n', '<leader>ow', '<cmd>e ~/notes/work.org<CR>', { desc = 'Open work notes' })

vim.keymap.set('n', '<leader>ocl', '<cmd>Org capture l<CR>', { desc = 'Capture life note' })
vim.keymap.set('n', '<leader>ol', '<cmd>e ~/notes/life.org<CR>', { desc = 'Open life notes' })

vim.keymap.set('n', '<leader>ocp', '<cmd>Org capture p<CR>', { desc = 'Capture project note' })
vim.keymap.set('n', '<leader>op', '<cmd>e ~/notes/projects.org<CR>', { desc = 'Open project notes' })

vim.keymap.set('n', '<leader>ocj', '<cmd>Org capture j<CR>', { desc = 'Capture journal entry' })
vim.keymap.set('n', '<leader>oj', '<cmd>e ~/notes/journal.org<CR>', { desc = 'Open journal entries' })

vim.keymap.set('n', '<leader>oal', '<cmd>Org agenda l<CR>', { desc = 'Life agenda' })
vim.keymap.set('n', '<leader>oaw', '<cmd>Org agenda w<CR>', { desc = 'Work agenda' })
vim.keymap.set('n', '<leader>oap', '<cmd>Org agenda p<CR>', { desc = 'Project agenda' })

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'orgagenda',
    callback = function(args)
        local bufnr = args.buf

        vim.keymap.set('n', 'q', '<cmd>close<CR>', {
            buffer = bufnr,
            silent = true,
            desc = 'Close agenda split',
        })
    end,
})
