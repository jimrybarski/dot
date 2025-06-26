local cmp = require("cmp")
local window_config = {scrollbar = true, side_padding = 1, col_offset = 0}
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    window = {
        completion = cmp.config.window.bordered(window_config),
        documentation = cmp.config.window.bordered(window_config)
    },
    mapping = {
        ['<C-n>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            end
        end, {"i", "s"}),
        ['<C-p>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, {"i", "s"}),
        ['<C-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({behavior = cmp.SelectBehavior.Replace})
            else
                fallback()
            end
        end, {"i", "s"}),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({behavior = cmp.SelectBehavior.Replace})
            else
                fallback()
            end
        end, {"i", "s"}),
        ['<C-i>'] = cmp.mapping(function(fallback)
            if luasnip.expandable() then
                luasnip.expand()
            else
                cmp.confirm({
                    select = true,
                })
            end
        end, {"i", "s"}),
        ['<Tab>'] = cmp.mapping(function(fallback)
            fallback()
        end),
        ['<C-h>'] = cmp.mapping.scroll_docs(-2),
        ['<C-l>'] = cmp.mapping.scroll_docs(2)
    },
    sources = cmp.config.sources({
        -- Autocompletes from snippets (defined in lua/snippets.lua)
        {name = 'luasnip', max_item_count = 5},
        -- Autocompletes from LSP servers
        {name = 'nvim_lsp'}, 
        -- Autocompletes text from the current buffer
        {name = 'buffer'},
        -- Autocompletes file paths
        {name = 'path'},
        -- To use greek characters, type ":" and the name of the letter
        -- e.g. :sigma: makes σ, :Sigma: makes Σ 
        {name = 'greek', option = {insert = true}, max_item_count = 1},
        -- To use nerd icons, type ":" and then a descriptor
        -- You'll need to guess the word that occurs in the name or look it up here:
        -- https://www.nerdfonts.com/cheat-sheet
        {name = 'nerdfont', option = {insert = true}},
        -- Autocompletes simple math equations with the solution
        {name = 'calc'}
    }),
    preselect = cmp.PreselectMode.None,
    completion = {keyword_length = 1},
    enabled = function()
        local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
        local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
        
        -- Disable completion in org-roam selection dialog
        if string.match(vim.api.nvim_buf_get_name(0), 'org%-roam%-select') then
            return false
        end
        
        return true
    end
})
