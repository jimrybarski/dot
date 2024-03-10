local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys to spacebar
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Show relative line numbers except on the current line, which shows the absolute line number
vim.opt.number = true
vim.opt.relativenumber = true
-- Don't make annoying backup files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
-- Always show the sign column (the column on the left that shows lint warnings and git changes)
-- Otherwise it will appear/disappear frequently, which is annoying
vim.opt.signcolumn = "yes"
-- Faintly highlight the line the cursor is on
vim.opt.cursorline = true
-- Use larger color palette
vim.opt.termguicolors = true
-- Milliseconds to wait to trigger CursorHold
vim.o.updatetime = 500
-- Set the number of spaces that a tab character represents. 
-- When you press the tab key, it will insert spaces equal to this number.
vim.opt.tabstop = 4

-- Set the number of spaces to use for each step of (auto)indent. 
-- This affects commands like >>, <<, ==, etc.
vim.opt.shiftwidth = 4

-- When inserting a tab, it will act as if it's made up of spaces equal to this number.
-- This helps in aligning with the tabstop when using spaces in place of tabs.
vim.opt.softtabstop = 4

-- Make the tab key insert spaces instead of a tab
vim.opt.expandtab = true

-- menu, menuone: show the completion menu if there are one or more matches
-- preview: show extra information about a selection
-- noinsert: don't insert text until a selection is made
-- noselect: don't select a match automatically
vim.g.completopt = "menu,menuone,preview,noinsert,noselect"

-- keep the cursor in the center of the screen (if there is space)
vim.o.scrolloff = 10

-- highlight the 120th column
vim.opt.colorcolumn = "120"

-- autoindent in codebases
vim.opt.smartindent = true
vim.opt.shiftwidth = 4

-- wrapped text starts at the same level of indentation as the first line
vim.opt.breakindent = true

-- open new splits down or to the right
vim.opt.splitright = true
vim.opt.splitbelow = true

-- transparently edit compressed files
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_zipPlugin = 1

vim.g.python3_host_prog = vim.fn.expand("$HOME/.local/pylspenv/bin/python3")

-- Dumps the text of a table's keys and values to a popup notification
function dbg(thing) vim.notify(vim.inspect(thing)) end

-- Make a shorter alias for some commands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Use real tabs and not spaces in .tsv files
autocmd("FileType", {
    pattern = "tsv",
    callback = function() vim.opt_local.expandtab = false end
})
-- Use real tabs and not spaces in Makefiles
autocmd("FileType", {
    pattern = "make",
    callback = function() vim.opt_local.expandtab = false end
})

-- load plugins
require("lazy").setup {
    -- highlight undo/redo text
    { 'tzachar/highlight-undo.nvim' },
    -- keep some space below the cursor even at the end of the buffer
    {
        'Aasim-A/scrollEOF.nvim',
        event = { 'CursorMoved', 'WinScrolled' },
        opts = {},
    },
    { "xiyaowong/telescope-emoji.nvim" },
    {
      "nvim-zh/colorful-winsep.nvim",
      config = true,
      event = { "WinNew" },
    },
    -- none-ls, telescope and others depend on plenary
    {"nvim-lua/plenary.nvim"}, {"nvimtools/none-ls.nvim"},
    -- { "folke/trouble.nvim",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    -- },
    {"neovim/nvim-lspconfig"}, {"L3MON4D3/LuaSnip"},
    {"saadparwaiz1/cmp_luasnip"}, {"hrsh7th/cmp-calc"}, {"max397574/cmp-greek"},
    {"chrisgrieser/cmp-nerdfont"}, {"ray-x/cmp-treesitter"},
    {"rcarriga/nvim-notify"}, {"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"}, {"hrsh7th/nvim-cmp"}, {"windwp/nvim-autopairs"}, {
        "chrisgrieser/nvim-origami",
        event = "BufReadPost", -- later or on keypress would prevent saving folds
        opts = true -- needed even when using default config
    }, {"lukas-reineke/indent-blankline.nvim"}, {"kylechui/nvim-surround"},
    {'smoka7/hop.nvim'}, {"akinsho/toggleterm.nvim"},
    {"nvim-lualine/lualine.nvim"}, {"lewis6991/gitsigns.nvim"},
    -- nice color map 
    {"ellisonleao/gruvbox.nvim"}, -- commands to comment/uncomment code
    {"numToStr/Comment.nvim"}, {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                highlight = {enable = true},
                ensure_installed = {
                    "awk", "bash", "bibtex", "css", "diff", "dockerfile",
                    "fish", "gitcommit", "git_config", "gitignore",
                    "git_rebase", "gpg", "html", "javascript", "json", "json5",
                    "latex", "lua", "luadoc", "make", "markdown",
                    "markdown_inline", "passwd", "python", "r",
                    "regex", "rust", "scss", "sql", "ssh_config", "toml", "tsv",
                    "vim", "vimdoc", "yaml"
                }
            })
        end
    }, {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {"nvim-treesitter/nvim-treesitter"}
    }, {"RRethy/vim-illuminate"},
    {"kevinhwang91/nvim-ufo", dependencies = {"kevinhwang91/promise-async"}},
    {"lunarvim/bigfile.nvim"}, {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim", {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
                cond = vim.fn.executable("cmake") == 1
            }
        }
    }
}

require('highlight-undo').setup({
  duration = 3000,
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
        hidden = true
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

local luasnip = require("luasnip")

-- MY CUSTOM SNIPPETS
local date = function() return os.date("%Y-%m-%d") end
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node

luasnip.add_snippets("all", {
    s("bash", {t("#!/usr/bin/env bash")}), s("zsh", {t("#!/usr/bin/env zsh")}),
    s("fish", {t("#!/usr/bin/env fish")}), s("d", {f(date, {})})
})

luasnip.add_snippets("python", {
    s("mpl", {t("import matplotlib.pyplot as plt")}),
    s("fig", {t("fig, ax = plt.subplots()")}), s("figs", {
        t("fig, ax = plt.subplots(figsize=("), i(1, "height"), t(", "),
        i(2, "width"), t("))")
    }), s("def", {
        t("def "), i(1, "fname"), t("("), i(2, "arg"), t(") -> "),
        i(3, "returns"), t(":\n\t"), i(4, "pass"), i(0)
    }), s("ifmain", {
        t("if __name__ == '__main__':"), t({"", "\t"}), -- Splitting the newline and indentation into a new text node
        i(1, "pass"), i(0)
    }),
    s("fim", {t("from "), i(1, "package"), t(" import "), i(2, "module"), i(0)})
})

-- message notifications in popups at the top right of the window
vim.notify = require("notify")

-- autocompletion framework
local cmp = require("cmp")
local window_config = {scrollbar = true, side_padding = 1, col_offset = 0}
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

vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

local autopairs = require('nvim-autopairs')
autopairs.setup({ignored_next_char = "[%w%.%(%[{]"})

require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter'}
    end,
    -- disable highlighting the unfolded text right after its unfolded
    open_fold_hl_timeout = 0
})

vim.keymap.set('n', 'zO', require('ufo').openAllFolds)
vim.keymap.set('n', 'zC', require('ufo').closeAllFolds)
require("origami").setup({
    keepFoldsAcrossSessions = true,
    -- pause folds is something I want, but its behavior is finnicky and broken
    pauseFoldsOnSearch = false,
    -- I think this is broken too
    setupFoldKeymaps = false

})
-- re-remap h and l to their default meaning. nvim-origami installs some stupid 
-- keymap even though I set it not to
vim.api.nvim_set_keymap('n', 'h', 'h', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'l', 'l', {noremap = true, silent = true})

-- puts vertical guide lines for each scope
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
        component_separators = {left = '', right = ''},
        section_separators = {left = '', right = ''},
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
        add = {text = '│'},
        change = {text = '│'},
        delete = {text = '_'},
        topdelete = {text = '‾'},
        changedelete = {text = '~'},
        untracked = {text = '┆'}
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
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
    yadm = {enable = false}
})
-- Show the last commit (author, timestamp and commit message) that changed the current line
vim.api.nvim_set_keymap('n', '<leader>vb', ':Gitsigns blame_line<CR>',
                        {noremap = true, silent = true})

require('Comment').setup({
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,
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
    pre_hook = nil,
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

require("bigfile").setup {
    filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
    pattern = {"*"}, -- autocmd pattern or function see <### Overriding the detection of big files>
    features = { -- features to disable
        "indent_blankline", "illuminate", "lsp", "treesitter", "syntax",
        "matchparen", "vimopts", "filetype"
    }
}

-- Set the colorscheme to a nice color palette
vim.cmd("colorscheme gruvbox")

require("toggleterm").setup({
    size = function(term)
        if term.direction == "horizontal" then
            local window_height = vim.api.nvim_win_get_height(0) * 4
            return window_height
        elseif term.direction == "vertical" then
            local window_width = vim.api.nvim_win_get_width(0) * 2
            return window_width
        end
    end,
    open_mapping = [[<c-\>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = false,
    shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = true,
    direction = 'vertical', -- 'vertical', 'horizontal', 'tab', or 'float'
    close_on_exit = true -- close the terminal window when the process exits
})
require("hop").setup()
vim.api.nvim_set_keymap("n", "\\", ":HopChar1<CR>", {noremap = true})
vim.api.nvim_set_keymap("o", "\\", ":HopChar1<CR>", {noremap = true})

require("nvim-surround").setup()

local lspconfig = require('lspconfig')
local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities(
                         lsp_capabilities)

lspconfig.jedi_language_server.setup({
    cmd = {vim.fn.expand("$HOME/.local/pylspenv/bin/jedi-language-server")},
    capabilities = capabilities
})

lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    settings = {["rust-analyzer"] = {checkOnSave = {command = "clippy"}}}
})

-- Give the signature help a rounded border
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})

-- For diagnostics with virtualtext, show the source of the diagnostic message
vim.diagnostic.config({
    virtual_text = {source = "always"},
    float = {source = "always"}
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local opts = {buffer = ev.buf}
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', 'gn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'g[', function(opts)
            vim.diagnostic.goto_next({float = false})
        end, opts)
        vim.keymap.set('n', 'g]', function(opts)
            vim.diagnostic.goto_prev({float = false})
        end, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, opts)
    end
})

-- check for file existence
function exists(path)
    local stat = vim.loop.fs_stat(path)
    return stat and true or false
end

-- Run unit tests and stop immediately if one fails
function RunUntilFirstFailingTest()
    if exists("tests") then
        vim.cmd('!pytest tests -x')
    else
        vim.notify("No tests directory!", "error", {title = "Error!"})
    end
end

-- Run unit tests and stop immediately if one fails
function RunUntilFirstFailingVerboseTest()
    if exists("tests") then
        vim.cmd('!pytest tests -xvvv')
    else
        vim.notify("No tests directory!", "error", {title = "Error!"})
    end
end

function RunAllTests()
    if exists("tests") then
        vim.cmd('!pytest tests')
    else
        vim.notify("No tests directory!", "error", {title = "Error!"})
    end
end

function RunMutationTests()
    if exists("run-tests") then
        vim.cmd('!bash run-tests')
    else
        vim.notify("No run-tests file!", "error", {title = "Error!"})
    end
end

-- copy selection to system clipboard
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>g', ':Telescope grep_string<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ft', ':Telescope<cr><Esc>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope fd<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fs', ':Telescope git_status<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fk', ':Telescope keymaps<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fm', ':Telescope man_pages<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>fe', ':Telescope emoji<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>c', ':split $HOME/.config/nvim/init.lua<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ns', ':split /tmp/scratch-notes.txt<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-S-j>', '1<C-w>-', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-S-k>', '1<C-w>+', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-S-h>', '1<C-w><', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-S-l>', '1<C-w>>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>tt', ':lua RunUntilFirstFailingTest()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>ta', ':lua RunAllTests()<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>tv', ':lua RunUntilFirstFailingVerboseTest<cr>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>tm', ':lua RunMutationTests()<cr>', {noremap = true, silent = true})
-- remove search highlight with escape
vim.api.nvim_set_keymap('n', '<Esc>', ':nohl<cr>:echo<cr>', { noremap = true, silent = true })
-- prevent register from being filled with empty strings or other things we never want to paste later
vim.api.nvim_set_keymap("n", "x", '"_x', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "c", '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "dd", "v:lua.check_line()", {expr = true, noremap = true})

function _G.check_line()
    if vim.fn.getline(".") == "" then
        return '"_dd'
    else
        return 'dd'
    end
end

-- needed for setting up PAO system only
-- Function to swap names based on ID
function swap_names_with_id(target_id)
    local bufnr = vim.api.nvim_get_current_buf() -- Get current buffer number
    local current_line_nr = vim.api.nvim_win_get_cursor(0)[1] -- Get current line number
    local current_line = vim.api.nvim_buf_get_lines(bufnr, current_line_nr-1, current_line_nr, false)[1] -- Get current line content
    
    -- Parse current line to extract ID and name
    local current_id, current_name = current_line:match("(%d+)%s(.+)")
    if not current_id then
        print("Current line does not contain a valid ID and name format.")
        return
    end
    
    -- Find target line by ID and extract name
    local target_line_nr, target_name
    for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
        if line:match("^" .. target_id .. "%s") then
            target_line_nr = i
            target_name = line:match("%d+%s(.+)")
            break
        end
    end
    
    if not target_line_nr then
        print("Target ID not found.")
        return
    end
    
    -- Swap names
    vim.api.nvim_buf_set_lines(bufnr, current_line_nr-1, current_line_nr, false, {current_id .. " " .. target_name})
    vim.api.nvim_buf_set_lines(bufnr, target_line_nr-1, target_line_nr, false, {target_id .. " " .. current_name})
end

-- Mapping function to key combination
vim.api.nvim_set_keymap('n', '<leader>s', ':lua swap_names_with_id(vim.fn.input("Enter target ID: "))<CR>', {noremap = true, silent = true})
