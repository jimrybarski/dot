local dap = require('dap')
local dapui = require('dapui')

-- Open the debug TUI
vim.keymap.set('n', '<leader>d', dapui.toggle, { desc = 'Toggle UI' })

-- Mark lines to pause at during debugging
vim.keymap.set('n', 'gb', dap.toggle_breakpoint, { desc = 'Toggle breakpoint'} )
vim.keymap.set('n', 'gB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = 'Set conditional breakpoint' })

-- Advance the program state
vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Start/continue debugger'})
vim.keymap.set('n', '<F6>', dap.step_over, { desc = 'Step over'})
vim.keymap.set('n', '<F7>', dap.step_into, { desc = 'Step into'})
vim.keymap.set('n', '<F8>', dap.step_out, { desc = 'Step out'})

-- Quit the debugger
vim.keymap.set('n', '<F9>', function ()
    dap.terminate()
    dapui.toggle()
end, { desc = 'Terminate' })
