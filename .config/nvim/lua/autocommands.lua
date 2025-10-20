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

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            vim.notify(string.format("%s active", client.name), "info", { timeout = 1500 })
        end
    end,
})

-- Enable link concealment in org files
autocmd("FileType", {
    pattern = "org",
    callback = function()
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = 'nvic'
        -- Tab/Shift-Tab for promoting/demoting headlines in insert mode
        vim.keymap.set('i', '<Tab>', function()
            local line_num = vim.fn.line('.')
            local line_text = vim.fn.getline(line_num)
            local col = vim.fn.col('.')

            -- Check if line starts with asterisks followed by space
            local stars = line_text:match('^(%*+)%s')
            if stars then
                -- Add one asterisk at the beginning
                vim.fn.setline(line_num, '*' .. line_text)
                -- Move cursor right by 1
                vim.fn.cursor(line_num, col + 1)
            end
        end, { buffer = true })
        vim.keymap.set('i', '<S-Tab>', function()
            local line_num = vim.fn.line('.')
            local line_text = vim.fn.getline(line_num)
            local col = vim.fn.col('.')

            -- Check if line starts with asterisks followed by space
            local stars = line_text:match('^(%*+)%s')
            if stars and #stars > 1 then
                -- Remove one asterisk from the beginning
                vim.fn.setline(line_num, line_text:sub(2))
                -- Move cursor left by 1
                vim.fn.cursor(line_num, col - 1)
            end
        end, { buffer = true })
    end
})
