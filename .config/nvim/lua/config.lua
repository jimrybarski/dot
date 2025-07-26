-- Set the colorscheme to a nice color palette
require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = { strings = true, comments = true },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,    -- invert background for search, diffs, statuslines and errors
    contrast = "soft", -- can be "hard", "soft" or empty string
    dim_inactive = false,
    transparent_mode = false
})
vim.cmd("colorscheme gruvbox")

-- set the colors of the vertical indentation lines 
-- color of the current scope where the cursor is
vim.api.nvim_set_hl(0, 'IblScope', { fg = '#7C6856' })
-- color of inactive scopes 
vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#5A4B3E' })

require("illuminate").configure({
    -- providers: provider used to get references in the buffer, ordered by priority
    providers = { 'lsp', 'treesitter', 'regex' },
    -- delay: delay in milliseconds
    delay = 0,
    -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
    filetypes_denylist = { 'dirbuf', 'dirvish', 'fugitive' },
    -- under_cursor: whether or not to illuminate under the cursor
    under_cursor = false,
    -- large_file_cutoff: number of lines at which to use large_file_config
    -- The `under_cursor` option is disabled when this cutoff is hit
    large_file_cutoff = 20000,
    -- min_count_to_highlight: minimum number of matches required to perform highlighting
    min_count_to_highlight = 1,
    -- should_enable: a callback that overrides all other settings to
    -- enable/disable illumination. This will be called a lot so don't do
    -- anything expensive in it.
    should_enable = function(bufnr) return true end,
    -- case_insensitive_regex: sets regex case sensitivity
    case_insensitive_regex = false
})
vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bold = true, underline = true })
vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bold = true, underline = true })
vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bold = true, underline = true })

require("hop").setup()
-- Highlight hex color codes (e.g. #0072B2) with the actual color
require('colorizer').setup({
    'css',
    'javascript',
    'html',
})

require("gitsigns").setup({
    signs = {
        add = { text = '█' }, -- │
        change = { text = '~' }, -- │
        delete = { text = '█' },
        topdelete = { text = '█' },
        changedelete = { text = '█' },
        untracked = { text = '┆' }
    },
    signcolumn = true,
    numhl = true,
    word_diff = false,
    linehl = false,
    watch_gitdir = { follow_files = true },
    auto_attach = true,
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = {
        hl_mode = 'combine',
        virt_text = false,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 10000,
        ignore_whitespace = true,
        virt_text_priority = 10
    },
    current_line_blame_formatter = '<author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,  -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
})
-- We show the git blame message for the current line. This sets the color of that virtual text.
vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = '#9B643D', italic = true })


require('highlight-undo').setup({
    duration = 300,
    undo = {
        hlgroup = 'HighlightUndo',
        mode = 'n',
        lhs = 'u',
        map = 'undo',
        opts = {}
    },
    redo = {
        hlgroup = 'HighlightUndo',
        mode = 'n',
        lhs = '<C-r>',
        map = 'redo',
        opts = {}
    },
    keymaps = {
        paste = { disabled = true },
        Paste = { disabled = true },
    },
    highlight_for_count = true,
})

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
        disabled_filetypes = {statusline = {}, winbar = {}},
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {statusline = 1000, tabline = 1000, winbar = 1000}
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
})

require("nvim-surround").setup()
require("nvim-autopairs").setup({
    check_ts = true, -- use treesitter
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
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
require('nvim-treesitter.configs').setup({
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
                ["gp"] = "@parameter.inner",
            },
            swap_previous = {
                ["gP"] = "@parameter.inner",
            },
        },
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            move = {
                enable = true,
                set_jumps = true,
                goto_previous_start = { 
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                    ["[p"] = "@parameter.outer",
                    ["[l"] = "@loop.outer",
                    ["[/"] = "@comment.outer",
                },
                goto_next_start = { 
                    ["]f"] = "@function.outer", 
                    ["]c"] = "@class.outer",
                    ["]p"] = "@parameter.outer",
                    ["]l"] = "@loop.outer",
                    ["]/"] = "@comment.outer",
                },
            },
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ['ap'] = '@parameter.outer',
                ['ip'] = '@parameter.inner',
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["a/"] = "@comment.outer",
                ["i/"] = "@comment.outer", -- no inner for comment
            },
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V',  -- linewise
                ['@class.outer'] = '<c-v>'  -- blockwise
            },
            include_surrounding_whitespace = function(opts)
                local mode = vim.api.nvim_get_mode()
                if ends_with(opts.query_string, "outer") and mode.mode ~= "v" then
                    return true
                else
                    return false
                end
            end
        }
    }
})
-- configure linters and formatters
null_ls = require("null-ls")
null_ls.setup({
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
-- require("nvim-surround").setup({
--     surrounds = {
--         ['('] = { add = { '(', ')' } },
--         ['['] = { add = { '[', ']' } },
--         ['{'] = { add = { '{', '}' } },
--         ['<'] = { add = { '<', '>' } },
--     }
-- })
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
