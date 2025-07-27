require('scrollEOF').setup({
    -- The pattern used for the internal autocmd to determine
    -- where to run scrollEOF. See https://neovim.io/doc/user/autocmd.html#autocmd-pattern
    pattern = '*',
    -- Whether or not scrollEOF should be enabled in insert mode
    insert_mode = true,
    -- List of filetypes to disable scrollEOF for.
    disabled_filetypes = {},
    -- List of modes to disable scrollEOF for. see https://neovim.io/doc/user/builtin.html#mode()
    disabled_modes = {},
})
require('lualine').setup({
    options = {
        icons_enabled = false,
        theme = 'auto',
        -- component_separators = {left = '', right = ''},
        -- section_separators = {left = '', right = ''},
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = { statusline = {}, winbar = {} },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = { statusline = 1000, tabline = 1000, winbar = 1000 }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = {},
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
})

require("nvim-surround").setup({
    -- don't add a space between the bracket and the text object, which is the default for some reason
    surrounds = {
        ['('] = { add = { '(', ')' } },
        ['['] = { add = { '[', ']' } },
        ['{'] = { add = { '{', '}' } },
        ['<'] = { add = { '<', '>' } },
    }
})

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

-- function needed by nvim-treesitter-textobjects
function ends_with(str, suffix)
    return suffix == "" or string.sub(str, -string.len(suffix)) == suffix
end

-- configure linters and formatters
local null_ls = require("null-ls")
null_ls.setup({
    diagnostics_format = "#{m} [#{c}] (#{s})",
    sources = {
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.formatting.isort,
    }
})

-- local actions = require("telescope.actions")
--
-- require("telescope").setup({
--     defaults = {
--         layout_config = { vertical = { width = 0.9, height = 0.9 } },
--         file_ignore_patterns = { ".git" },
--         hidden = true,
--         vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--follow' },
--     },
--     pickers = {
--         find_files = {
--             find_command = { 'fd', '--type', 'f', '--follow', '--hidden', '--exclude', '.git' }
--         },
--         lsp_references = {
--             -- by default, telescope lets you type to filter the list of results further.
--             -- however, for the list of references, I only ever want to scroll up and down with j and k
--             -- here, we force it to start in normal mode
--             initial_mode = "normal",
--         },
--     },
--     extensions = {
--         emoji = {
--             action = function(emoji)
--                 -- argument emoji is a table.
--                 -- {name="", value="", cagegory="", description=""}
--                 -- insert emoji when picked
--                 vim.api.nvim_put({ emoji.value }, 'c', false, true)
--             end,
--         },
--     },
-- })
--
-- -- Enable telescope fzf native, if installed
-- pcall(require("telescope").load_extension, "fzf")
-- pcall(require("telescope").load_extension, "emoji")
--
--
-- require("toggleterm").setup({
--     size = function(term)
--         if term.direction == "horizontal" then
--             local window_height = vim.api.nvim_win_get_height(0) * 2
--             return window_height
--         elseif term.direction == "vertical" then
--             local window_width = vim.api.nvim_win_get_width(0) * 1
--             return window_width
--         end
--     end,
--     open_mapping = [[<c-\>]],
--     shell = 'fish',
--     hide_numbers = true, -- hide the number column in toggleterm buffers
--     shade_filetypes = {},
--     shade_terminals = false,
--     shading_factor = 2,     -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
--     start_in_insert = true,
--     insert_mappings = true, -- whether or not the open mapping applies in insert mode
--     persist_size = true,
--     direction = 'float',    -- 'vertical', 'horizontal', 'tab', or 'float'
--     close_on_exit = true    -- close the terminal window when the process exits
-- })
--
--
--
--
-- -- require("ibl").setup({
-- --     indent = {
-- --         -- pick one of the symbols below or use anything else you want
-- --         -- but the char must have a display width of 1
-- --         char = "▏" -- ╎▏ ▏▎▍▌▋▊▉█│┃▕▐╎╏┆┇┊┋║
-- --     },
-- --     scope = {
-- --         -- don't highlight the current scope's vertical line, or the text at either end of the line
-- --         -- this seems to be flaky, and I'm not really sure how it helps
-- --         enabled = false
-- --     }
-- -- })
--
--
-- require('Comment').setup({
--     ---Add a space b/w comment and the line
--     padding = true,
--     ---Whether the cursor should stay at its position
--     sticky = true,
--     ---Lines to be ignored while (un)comment
--     ignore = '^#!',
--     ---LHS of toggle mappings in NORMAL mode
--     toggler = {
--         ---Line-comment toggle keymap
-- line = 'gcc',
--         ---Block-comment toggle keymap
--         block = 'gbc'
--     },
--     ---LHS of operator-pending mappings in NORMAL and VISUAL mode
--     opleader = {
--         ---Line-comment keymap
--         line = 'gc',
--         ---Block-comment keymap
--         block = 'gb'
--     },
--     ---LHS of extra mappings
--     extra = {
--         ---Add comment on the line above
--         above = 'gcO',
--         ---Add comment on the line below
--         below = 'gco',
--         ---Add comment at the end of line
--         eol = 'gcA'
--     },
--     ---Enable keybindings
--     ---NOTE: If given `false` then the plugin won't create any mappings
--     mappings = {
--         ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
--         basic = true,
--         ---Extra mapping; `gco`, `gcO`, `gcA`
--         extra = true
--     },
--     ---Function to call before (un)comment
--     pre_hook = function(ctx)
--         -- Check if the current line is a shebang line
--         local line = vim.api.nvim_get_current_line()
--         if line:match("^#!") then
--             -- Return nil to signify no commentstring adjustment needed
--             return nil
--         end
--
--         -- For other lines, you could adjust `commentstring` if needed, or leave as default
--         -- This is an example if you want to customize further, you might not need this part
--         -- return vim.bo.commentstring
--     end,
--     ---Function to call after (un)comment
--     post_hook = nil
-- })
--
-- require('diffview').setup()
--
--
-- require('neogit').setup()
--
-- require('bioinformatics')
