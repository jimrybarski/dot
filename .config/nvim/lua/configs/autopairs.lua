-- automatically insert closing brackets/quotes
require("nvim-autopairs").setup({
    check_ts = true, -- use treesitter
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
    ignored_next_char = "[%w%.]" -- will ignore alphanumeric and `.` symbol
})
-- Handle Python's triple quotes correctly
local rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
npairs.add_rules {
    rule('"""', '"""', 'python')
        :with_move(function(opts)
            return opts.char == '"'
        end)
        :with_pair(function(opts)
            local prev_char = opts.line:sub(opts.col - 1, opts.col - 1)
            return prev_char ~= '"'
        end)
        :with_del(function(opts)
            return opts.col >= 3 and opts.line:sub(opts.col - 2, opts.col) == '"""'
        end)
}
