local autocmd = vim.api.nvim_create_autocmd

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

-- Notes settings. conceallevel=2 is what hides the timestamp in [[20260725-193045|Comedians]]
-- and what render-markdown.nvim expects.
autocmd("FileType", {
    pattern = "markdown",
    callback = function(args)
        vim.opt_local.conceallevel = 2

        -- <CR> follows the [[link]] under the cursor. Buffer-local, and it only
        -- takes over when the cursor is actually inside a link -- anywhere else
        -- it feeds the keystroke back unmapped so <CR> still moves to the next
        -- line, which is what it does in every other buffer.
        vim.keymap.set("n", "<CR>", function()
            local notes = require("notes")
            if notes.followable() then
                notes.follow()
            else
                vim.api.nvim_feedkeys(
                    vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
            end
        end, { buffer = args.buf, desc = "Follow link under cursor" })
    end
})

-- The stamp -> title map backs the [[timestamp]] rendering, so it has to drop
-- whenever a note's frontmatter could have changed. `*` spans path separators in
-- autocmd patterns, so this covers every year directory.
autocmd("BufWritePost", {
    pattern = vim.fn.expand("~/notes") .. "/*.md",
    callback = function() require("notes").invalidate() end
})

autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            vim.notify(string.format("%s active", client.name), "info", { timeout = 1500 })
        end
    end,
})
