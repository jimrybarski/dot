local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    completion = {
        -- menu: show completion menu even if there's only one match
        -- menuone: doesn't automatically select the first match even if there's only one
        -- noselect: don't select the first match
        completeopt = 'menu,menuone,noselect',
    },
    preselect = cmp.PreselectMode.None,
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() and cmp.get_selected_entry().source.name == 'luasnip' then
                luasnip.expand()
            else
                fallback()
            end
        end),
        ['<C-h>'] = cmp.mapping.scroll_docs(-4),
        ['<C-l>'] = cmp.mapping.scroll_docs(4),
    }),
    sources = cmp.config.sources({
        -- Autocompletes from LSP servers
        { name = 'nvim_lsp' },
        -- Autocompletes text from the current buffer
        { name = 'buffer',   max_item_count = 3 },
        -- Autocompletes file paths
        { name = 'path' },
        -- Autocompletes from snippets (defined in lua/snippets.lua)
        { name = 'luasnip',  max_item_count = 5 },
        -- To use greek characters, type ":" and the name of the letter
        -- e.g. :sigma: makes σ, :Sigma: makes Σ
        { name = 'greek',    option = { insert = true }, max_item_count = 3 },
        -- To use icons, type ":" and then a descriptor
        -- You'll need to guess the word that occurs in the name or look it up here:
        -- https://www.nerdfonts.com/cheat-sheet
        { name = 'nerdfont', option = { insert = true }, max_item_count = 5 },
        -- Autocompletes simple math equations with the solution
        { name = 'calc' }
    }),
    experimental = {
        ghost_text = false,
    },
})
