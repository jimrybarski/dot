vim.keymap.set('n', '<leader>k', function()
    local Snacks = require("snacks")
    Snacks.notifier.hide()
end, { desc = 'Dismiss all notifications' })
