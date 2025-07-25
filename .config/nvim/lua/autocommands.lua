-- Make a shorter alias for some commands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Use real tabs and not spaces in .tsv files
autocmd("FileType", {
    pattern = "tsv",
    callback = function() 
        vim.opt_local.expandtab = false
        vim.opt_local.list = true
    end
})
-- Use real tabs and not spaces in Makefiles
autocmd("FileType", {
    pattern = "make",
    callback = function() vim.opt_local.expandtab = false end
})
