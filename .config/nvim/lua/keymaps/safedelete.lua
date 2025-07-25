-- Remaps most destructive operations so that they don't overwrite the clipboard with junk
function _G.check_line()
    if vim.fn.getline(".") == "" then
        return '"_dd'
    else
        return 'dd'
    end
end

vim.keymap.set("n", "x", '"_x', { desc = "Delete character without yanking", silent = true })
vim.keymap.set("n", "c", '"_c', { desc = "Change without yanking", silent = true })
vim.keymap.set("n", "dd", "v:lua.check_line()", { desc = "Delete line (smart)", expr = true })
