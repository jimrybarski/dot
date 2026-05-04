local neotest = require('neotest')

neotest.setup({
    adapters = {
        require('neotest-python')({
            runner = 'pytest',
        }),
        require('neotest-rust'),
    },
    diagnostic = { enabled = true },
    status = { enabled = true, signs = true },
    output = { open_on_run = false },
})

-- Run the test nearest to the cursor
vim.keymap.set('n', '<leader>tr', function()
    neotest.run.run()
end, { desc = 'Test: run nearest' })

-- Run all tests in the current file
vim.keymap.set('n', '<leader>ts', function()
    neotest.run.run(vim.fn.expand('%'))
end, { desc = 'Test: run all in file' })

-- Run all tests in the current file, skipping those marked slow (Python only)
vim.keymap.set('n', '<leader>tt', function()
    if vim.bo.filetype == 'python' then
        neotest.run.run({ vim.fn.expand('%'), extra_args = { '-m', 'not slow' } })
    else
        neotest.run.run(vim.fn.expand('%'))
    end
end, { desc = 'Test: run non-slow tests' })

-- Jump to the next failing test in the current buffer
vim.keymap.set('n', '<leader>tg', function()
    neotest.jump.next({ status = 'failed' })
end, { desc = 'Test: jump to next failure' })

-- Show the output for the test nearest to the cursor
vim.keymap.set('n', '<leader>ti', function()
    neotest.output.open({ enter = true })
end, { desc = 'Test: show output' })

-- Clear all neotest diagnostics and signs in the current buffer
vim.keymap.set('n', '<leader>tc', function()
    local bufnr = vim.api.nvim_get_current_buf()
    for name, id in pairs(vim.api.nvim_get_namespaces()) do
        if name:match('neotest') then
            vim.diagnostic.reset(id, bufnr)
        end
    end
end, { desc = 'Test: clear highlights' })
