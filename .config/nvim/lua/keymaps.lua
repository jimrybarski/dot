vim.keymap.set("n", "H", "^", { desc = "Go to first non-blank character" })
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

vim.keymap.set("n", "\\", ":HopChar1<CR>", { desc = "Hop to character" })
vim.keymap.set("o", "\\", ":HopChar1<CR>", { desc = "Hop to character (operator)" })

vim.keymap.set('n', '<leader>y', ':HopYankChar1<cr>', { desc = "Hop yank to character", silent = true })
vim.keymap.set('n', '<leader>p', ':HopPasteChar1<cr>', { desc = "Hop paste to character", silent = true })
vim.keymap.set('v', '<leader>y', '"+y', { desc = "Yank to system clipboard", silent = true })
vim.keymap.set('n', '<leader>g', ':Telescope live_grep<cr>', { desc = "Live grep search", silent = true })
vim.keymap.set('n', '<leader>ff', ":Telescope find_files<cr>", { desc = "Find files", silent = true })
vim.keymap.set('n', '<leader>fk', ':Telescope keymaps<cr>', { desc = "Find keymaps", silent = true })
vim.keymap.set('n', '<leader>fm', ':Telescope man_pages<cr>', { desc = "Find man pages", silent = true })
vim.keymap.set('n', '<leader>fe', ':Telescope emoji<cr>', { desc = "Find emoji", silent = true })
vim.keymap.set('n', '<leader>c', ':split $HOME/.config/nvim/init.lua<cr>', { desc = "Open nvim config", silent = true })
vim.keymap.set('n', '<C-S-j>', '1<C-w>+', { desc = "Increase window height", silent = true })
vim.keymap.set('n', '<C-S-k>', '1<C-w>-', { desc = "Decrease window height", silent = true })
vim.keymap.set('n', '<C-S-h>', '1<C-w><', { desc = "Decrease window width", silent = true })
vim.keymap.set('n', '<C-S-l>', '1<C-w>>', { desc = "Increase window width", silent = true })
vim.keymap.set('n', '<leader>tt', ':lua RunUntilFirstFailingTest()<cr>', { desc = "Run tests until first failure", silent = true })
vim.keymap.set('n', '<leader>ta', ':lua RunAllTests()<cr>', { desc = "Run all tests", silent = true })
vim.keymap.set('n', '<leader>tv', ':lua RunUntilFirstFailingVerboseTest<cr>', { desc = "Run tests verbose until failure", silent = true })
vim.keymap.set('n', '<leader>tm', ':lua RunMutationTests()<cr>', { desc = "Run mutation tests", silent = true })

vim.keymap.set('n', '<Esc>', ':nohl<cr>:echo<cr>', { desc = "Clear search highlight", silent = true })

vim.keymap.set("n", "x", '"_x', { desc = "Delete character without yanking", silent = true })
vim.keymap.set("n", "c", '"_c', { desc = "Change without yanking", silent = true })
vim.keymap.set("n", "dd", "v:lua.check_line()", { desc = "Delete line (smart)", expr = true })

vim.keymap.set('n', '<leader>z', '0:lua OpenWiktionary()<CR>', { desc = "Open Wiktionary for current word", silent = true })

vim.keymap.set('n', '<leader>vb', ':Gitsigns blame_line<CR>', { desc = "Git blame current line", silent = true })
vim.keymap.set('n', '<leader>vh', ':Gitsigns toggle_linehl<CR>', { desc = "Toggle git line highlighting", silent = true })
vim.keymap.set('n', '<leader>vv', ':Neogit<CR>', { desc = "Open Neogit", silent = true })


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
    vim.keymap.set('i', '<C-' .. k .. '>', v, { desc = "Insert Greek letter " .. v, silent = true })
end

vim.keymap.set('i', '<C-\'>', '<C-r>"', { desc = "Paste from default register in insert mode", silent = true })

vim.keymap.set({ 'n', 'v' }, '<leader>k', function()
    local notify = require("notify")
    notify.dismiss()
end, { desc = "Dismiss all notifications", silent = true })

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
