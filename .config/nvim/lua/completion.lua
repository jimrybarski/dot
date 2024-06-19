local cmp = require("cmp")
local window_config = {scrollbar = true, side_padding = 1, col_offset = 0}
local luasnip = require("luasnip")
cmp.setup({
    snippet = {
        expand = function(args) require('luasnip').lsp_expand(args.body) end
    },
    window = {
        completion = cmp.config.window.bordered(window_config),
        documentation = cmp.config.window.bordered(window_config)
    },
    mapping = {
        -- When autocomplete is available, no selection is made automatically. The user
        -- must press tab or shift+tab to cycle through the options. function_node
        ['<C-n>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif luasnip.jumpable(1) then
                luasnip.jump(1)
            end
        end, {"i", "s"}),
        ['<C-p>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then luasnip.jump(-1) end
        end, {"i", "s"}),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
            else
                fallback()
            end
        end, {"i", "s"}),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({behavior = cmp.SelectBehavior.Insert})
            else
                fallback()
            end
        end, {"i", "s"}),
        ['<CR>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, {"i", "s"}),
        ['<Esc>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry({
                    behavior = cmp.SelectBehavior.Select
                })
                if not entry then
                    -- autocomplete was open but nothing was selected. the user wants to go into
                    -- normal mode directly
                    -- so close the autocomplete window first
                    cmp.abort()
                    -- then escape
                    fallback()
                else
                    -- the user had highlighted an autocomplete item, but then pressed escape
                    -- we just escape here, which closes the window and escapes to normal mode.
                    -- the inserted text remains. calling cmp.abort() here causes a bug in autocomplete
                    -- where entries aren't inserted anymore. So I'm not sure why the window closes.
                    fallback()
                end
            else
                -- I don't know how this would be possible
                fallback()
            end
        end, {"i", "s"}),
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4)
    },

    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, 
        {name = 'luasnip', max_item_count = 5},
        {name = 'treesitter'}, {name = 'buffer', max_item_count = 5},
        {name = 'path', max_item_count = 5},
        {name = 'greek', option = {insert = true}, max_item_count = 1},
        {name = 'nerdfont', option = {insert = true}},
        {name = 'calc'}
    }),
    preselect = cmp.PreselectMode.None,
    completion = {keyword_length = 1}
})


