require("nvim-surround").setup({
    -- don't add a space between the bracket and the text object, which is the default for some reason
    surrounds = {
        ['('] = { add = { '(', ')' } },
        ['['] = { add = { '[', ']' } },
        ['{'] = { add = { '{', '}' } },
        ['<'] = { add = { '<', '>' } },
    }
})
