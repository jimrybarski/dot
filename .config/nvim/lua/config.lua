require('diffview').setup()

-- message notifications in popups at the top right of the window
vim.notify = require("notify")

require('colorizer').setup({
  'css';
  'javascript';
  'html';
})

require('neogit').setup()

require('bioinformatics')

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
      paste = { disabled = true},
      Paste = { disabled = true},
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

function ends_with(str, suffix)
    return suffix == "" or string.sub(str, -string.len(suffix)) == suffix
end

require('nvim-treesitter.configs').setup({
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            move = {
                enable = true,
                set_jumps = true,
                goto_previous_start = {["]]"] = "@function.outer"},
                goto_next_start = {["[["] = "@function.outer"},
            },
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["as"] = "@scope",
            },
            selection_modes = {
                ['@parameter.outer'] = 'v', -- charwise
                ['@function.outer'] = 'V', -- linewise
                ['@class.outer'] = '<c-v>' -- blockwise
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

local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        layout_config = {vertical = {width = 0.9, height = 0.9}},
        file_ignore_patterns = {".git"},
        hidden = true,
        vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--follow' },
    },
    pickers = {
		find_files = {
			find_command = {'fd', '--type', 'f', '--follow', '--hidden', '--exclude', '.git'}
		},
        lsp_references = {
          -- by default, telescope lets you type to filter the list of results further.
          -- however, for the list of references, I only ever want to scroll up and down with j and k
          -- here, we force it to start in normal mode
          initial_mode = "normal",
        },
	},
    extensions = {
        emoji = {
            action = function(emoji)
                -- argument emoji is a table.
                -- {name="", value="", cagegory="", description=""}
                -- insert emoji when picked
                vim.api.nvim_put({ emoji.value }, 'c', false, true)
            end,
        },
    },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "emoji")

-- configure linters and formatters
null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.pylint, 
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.formatting.isort,
    }
})

require("toggleterm").setup({
    size = function(term)
        if term.direction == "horizontal" then
            local window_height = vim.api.nvim_win_get_height(0) * 2
            return window_height
        elseif term.direction == "vertical" then
            local window_width = vim.api.nvim_win_get_width(0) * 1
            return window_width
        end
    end,
    open_mapping = [[<c-\>]],
    shell = 'fish',
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = false,
    shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = true,
    direction = 'float', -- 'vertical', 'horizontal', 'tab', or 'float'
    close_on_exit = true -- close the terminal window when the process exits
})
require("hop").setup()

require("nvim-surround").setup()

require('nvim-autopairs').setup({ignored_next_char = "[%w%.%(%[{]"})

-- puts vertical guide lines for each scope
-- is this "local highlight" line necessary?
local highlight = {"CursorColumn"}
require("ibl").setup({
    indent = {
        -- pick one of the symbols below or use anything else you want
        -- but the char must have a display width of 1
        char = "▏" -- ╎▏ ▏▎▍▌▋▊▉█│┃▕▐╎╏┆┇┊┋║
    },
    scope = {
        -- don't highlight the current scope's vertical line, or the text at either end of the line
        -- this seems to be flaky, and I'm not really sure how it helps
        enabled = false
    }
})
require("illuminate").configure({
    -- providers: provider used to get references in the buffer, ordered by priority
    providers = {'lsp', 'treesitter', 'regex'},
    -- delay: delay in milliseconds
    delay = 0,
    -- filetype_overrides: filetype specific overrides.
    -- The keys are strings to represent the filetype while the values are tables that
    -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
    filetype_overrides = {},
    -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
    filetypes_denylist = {'dirbuf', 'dirvish', 'fugitive'},
    -- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
    -- You must set filetypes_denylist = {} to override the defaults to allow filetypes_allowlist to take effect
    filetypes_allowlist = {},
    -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
    -- See `:help mode()` for possible values
    modes_denylist = {},
    -- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
    -- See `:help mode()` for possible values
    modes_allowlist = {},
    -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_denylist = {},
    -- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_allowlist = {},
    -- under_cursor: whether or not to illuminate under the cursor
    under_cursor = true,
    -- large_file_cutoff: number of lines at which to use large_file_config
    -- The `under_cursor` option is disabled when this cutoff is hit
    large_file_cutoff = nil,
    -- large_file_config: config to use for large files (based on large_file_cutoff).
    -- Supports the same keys passed to .configure
    -- If nil, vim-illuminate will be disabled for large files.
    large_file_overrides = nil,
    -- min_count_to_highlight: minimum number of matches required to perform highlighting
    min_count_to_highlight = 1,
    -- should_enable: a callback that overrides all other settings to
    -- enable/disable illumination. This will be called a lot so don't do
    -- anything expensive in it.
    should_enable = function(bufnr) return true end,
    -- case_insensitive_regex: sets regex case sensitivity
    case_insensitive_regex = false
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
require("gitsigns").setup({
    signs = {
        add = {text = '█'}, -- │
        change = {text = '~'}, -- │
        delete = {text = '█'},
        topdelete = {text = '█'},
        changedelete = {text = '█'},
        untracked = {text = '┆'}
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    linehl = false,
    watch_gitdir = {follow_files = true},
    auto_attach = true,
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
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

require("nvim-surround").setup({
    surrounds = {
        ['('] = { add = { '(', ')' } },
        ['['] = { add = { '[', ']' } },
        ['{'] = { add = { '{', '}' } },
        ['<'] = { add = { '<', '>' } },
    }
})

require('Comment').setup({
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = '^#!',
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc'
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = 'gc',
        ---Block-comment keymap
        block = 'gb'
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA'
    },
    ---Enable keybindings
    ---NOTE: If given `false` then the plugin won't create any mappings
    mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true
    },
    ---Function to call before (un)comment
    pre_hook = function(ctx)
        -- Check if the current line is a shebang line
        local line = vim.api.nvim_get_current_line()
        if line:match("^#!") then
            -- Return nil to signify no commentstring adjustment needed
            return nil
        end

        -- For other lines, you could adjust `commentstring` if needed, or leave as default
        -- This is an example if you want to customize further, you might not need this part
        -- return vim.bo.commentstring
    end,
    ---Function to call after (un)comment
    post_hook = nil
})
require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = {strings = true, comments = true},
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "soft", -- can be "hard", "soft" or empty string
    dim_inactive = false,
    transparent_mode = false
})
-- Set the colorscheme to a nice color palette
vim.cmd("colorscheme gruvbox")

require("bigfile").setup {
    filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
    pattern = {"*"}, -- autocmd pattern or function see <### Overriding the detection of big files>
    features = { -- features to disable
        "indent_blankline", "illuminate", "lsp", "treesitter", "syntax",
        "matchparen", "vimopts", "filetype"
    }
}

