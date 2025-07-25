-- Move the cursor to any character on the screen
vim.keymap.set("n", "\\", ":HopChar1<CR>", { desc = "Hop to character" })
-- This lets you use hop as a motion, so you can do things like `d\x` which would delete from the cursor to the selected occurence of the character `x` 
vim.keymap.set("o", "\\", ":HopChar1<CR>", { desc = "Hop to character (operator)" })
