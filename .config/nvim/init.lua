local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath
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

-- transparently edit compressed files
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_zipPlugin = 1


-- Make a shorter alias for some commands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Use real tabs and not spaces in .tsv files
autocmd("FileType", {
    pattern = "tsv",
    callback = function()
        vim.opt_local.expandtab = false
    end,
})
-- Use real tabs and not sapces in Makefiles
autocmd("FileType", {
    pattern = "make",
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

-- load plugins
require("lazy").setup{
    {"L3MON4D3/LuaSnip"},
    {"saadparwaiz1/cmp_luasnip"},
    { "hrsh7th/cmp-calc" },
    { "max397574/cmp-greek" },
    { "chrisgrieser/cmp-nerdfont" },
    { "ray-x/cmp-treesitter" },
    {"hrsh7th/cmp-nvim-lua"},
    {"rcarriga/nvim-notify"},
    {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-cmdline"},
    -- {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/cmp-path"},
    {"hrsh7th/nvim-cmp"},
    {"windwp/nvim-autopairs"},
    { "chrisgrieser/nvim-origami",
        event = "BufReadPost", -- later or on keypress would prevent saving folds
        opts = true, -- needed even when using default config
    },
    {"lukas-reineke/indent-blankline.nvim"},
    {"kylechui/nvim-surround"},
    {'smoka7/hop.nvim'},
    {"akinsho/toggleterm.nvim"},
    {"nvim-lualine/lualine.nvim"},
    {"lewis6991/gitsigns.nvim"},
    -- nice color map 
    {"ellisonleao/gruvbox.nvim"}, 
    -- commands to comment/uncomment code
    {"numToStr/Comment.nvim"}, 
    { "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            highlight = {
                enable = true
            },
            ensure_installed = {
                "awk",
                "bash",
                "bibtex",
                "css",
                "diff",
                "dockerfile",
                "fish",
                "gitcommit",
                "git_config",
                "gitignore",
                "git_rebase",
                "gpg",
                "html",
                "javascript",
                "json",
                "json5",
                "latex",
                "lua",
                "luadoc",
                "make",
                "markdown",
                "markdown_inline",
                "passwd",
                "printf",
                "python",
                "r",
                "regex",
                "rust",
                "scss",
                "sql",
                "ssh_config",
                "toml",
                "tsv",
                "vim",
                "vimdoc",
                "yaml"
                }
              })
          end
    }, 
    {"RRethy/vim-illuminate"},
    { "kevinhwang91/promise-async" },
    { "kevinhwang91/nvim-ufo" },
    {"lunarvim/bigfile.nvim"},
    {"hrsh7th/cmp-emoji"},
}

local luasnip = require("luasnip")

-- MY CUSTOM SNIPPETS
local date = function() return os.date("%Y-%m-%d") end
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node

luasnip.add_snippets("all", {
    s("bash", {t("#!/usr/bin/env bash")}),
    s("zsh", {t("#!/usr/bin/env zsh")}),
    s("fish", {t("#!/usr/bin/env fish")}),
    s("d", {f(date, {})})
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
vim.notify = require("notify")
local cmp = require("cmp")
local window_config = {
            scrollbar = true,
            side_padding = 1,
            col_offset = 0,
        }
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(window_config),
        documentation = cmp.config.window.bordered(window_config),
    },
    mapping = { 
        -- When autocomplete is available, no selection is made automatically. The user
        -- must press tab or shift+tab to cycle through the options. function_node
        ['<C-n>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then luasnip.jump(1) end
        end, {"i", "s"}),
        ['<C-p>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then luasnip.jump(-1) end
        end, {"i", "s"}),
        ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    if luasnip.expand_or_jumpable() then
                        cmp.select_next_item({})
                    else
                        cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
                    end
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
        ['<Esc>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                local entry = cmp.get_selected_entry({behavior = cmp.SelectBehavior.Select})
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
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        },
        sources = cmp.config.sources({
            { name = 'luasnip' },
            { name = 'calc' },
            { name = 'greek',
            option = { insert = true } },
            { name = 'nerdfont', 
              option = { insert = true } },
            { name = 'emoji' , 
              option = { insert = true } },
            { name = 'treesitter' },
            { name = 'buffer' },
            { name = 'cmdline' },
            { name = 'path'},
        }),
        preselect = cmp.PreselectMode.None,
})

cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { '!' }
      }
    }
  })
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
	setupFoldKeymaps = false,
  
})

-- puts vertical guide lines for each scope
local highlight = {"CursorColumn"}
require("ibl").setup({
    indent = {
        -- pick one of the symbols below or use anything else you want
        -- but the char must have a display width of 1
        char = "▏"  -- ╎▏ ▏▎▍▌▋▊▉█│┃▕▐╎╏┆┇┊┋║
    },
    scope = { 
        -- don't highlight the current scope's vertical line, or the text at either end of the line
        -- this seems to be flaky, and I'm not really sure how it helps
            enabled = false, 
            }
})
require("illuminate").configure({
-- providers: provider used to get references in the buffer, ordered by priority
    providers = {
        'lsp',
        'treesitter',
        'regex',
    },
    -- delay: delay in milliseconds
    delay = 0,
    -- filetype_overrides: filetype specific overrides.
    -- The keys are strings to represent the filetype while the values are tables that
    -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
    filetype_overrides = {},
    -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
    filetypes_denylist = {
        'dirbuf',
        'dirvish',
        'fugitive',
    },
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
    under_cursor = false,
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
    case_insensitive_regex = false,
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
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
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
  yadm = {
    enable = false
  },
})
-- Show the last commit (author, timestamp and commit message) that changed the current line
vim.api.nvim_set_keymap('n', '<leader>vb', ':Gitsigns blame_line<CR>', {noremap = true, silent = true})

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
  pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
  features = { -- features to disable
    "indent_blankline",
    "illuminate",
    "lsp",
    "treesitter",
    "syntax",
    "matchparen",
    "vimopts",
    "filetype",
  },
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

--     "nvim-lua/plenary.nvim", 
--     "tamago324/nlsp-settings.nvim",
--     "neovim/nvim-lspconfig", {
--         "nvim-telescope/telescope.nvim",
--         config = function()
--             require("telescope").setup({
--                 defaults = {
--                     vimgrep_arguments = {
--                         "rg", "--color=never", "--no-heading",
--                         "--with-filename", "--line-number", "--column",
--                         "--smart-case", "--hidden", "--glob=!.git/"
--                     },
--                     path_display = {"smart"},
--                     border = {},
--                     borderchars = nil,
--                     color_devicons = true,
--                     set_env = {["COLORTERM"] = "truecolor"}
--                 }
--             })
--         end
--     }, {"nvim-telescope/telescope-fzf-native.nvim", build = "make"}, 
--
--     
--     {"klen/nvim-test"},
--     {"mfussenegger/nvim-dap"},
--     
--     {"ray-x/lsp_signature.nvim"},
--     {"rcarriga/nvim-dap-ui"},
-- }, {})
--
-- require("nvim-test").setup {}
--
--
-- require("lsp_signature").setup({
--     debug = false, -- set to true to enable debug logging
--     log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
--     -- default is  ~/.cache/nvim/lsp_signature.log
--     verbose = false, -- show debug line number
--     bind = true, -- This is mandatory, otherwise border config won't get registered.
--     -- If you want to hook lspsaga or other signature handler, pls set to false
--     doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
--     -- set to 0 if you DO NOT want any API comments be shown
--     -- This setting only take effect in insert mode, it does not affect signature help in normal
--     -- mode, 10 by default
--     max_height = 12, -- max height of signature floating_window
--     max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
--     -- the value need >= 40
--     wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
--     floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
--     floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
--     -- will set to true when fully tested, set to false will use whichever side has more space
--     -- this setting will be helpful if you do not want the PUM and floating win overlap
--
--     floating_window_off_x = 1, -- adjust float windows x position.
--     -- can be either a number or function
--     floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
--     -- can be either number or function, see examples
--
--     close_timeout = 4000, -- close floating window after ms when laster parameter is entered
--     fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
--     hint_enable = true, -- virtual hint enable
--     hint_prefix = "> ",
--     hint_scheme = "String",
--     hint_inline = function() return false end, -- should the hint be inline(nvim 0.10 only)?  default false
--     -- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
--     -- return 'right_align' to display hint right aligned in the current line
--     hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
--     handler_opts = {
--         border = "double" -- double, rounded, single, shadow, none, or a table of borders
--     },
--
--     always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
--
--     auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
--     extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
--     zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
--
--     padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc
--
--     transparency = nil, -- disabled by default, allow floating win transparent value 1~100
--     shadow_blend = 36, -- if you using shadow as border use this set the opacity
--     shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
--     timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
--     toggle_key = nil, -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
--     toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
--     -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
--     -- may not popup when typing depends on floating_window setting
--
--     select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
--     move_cursor_key = nil -- imap, use nvim_set_current_win to move cursor between current win and floating
-- })
--
-- local cmp = require("cmp")
-- local cmp_types = require('cmp.types')

-- cmp.setup({
--     -- Specify the completion behavior
--     completion = {completeopt = 'menu,menuone,noselect'},
--
--     -- Disable preselecting the first completion item
--     preselect = cmp.PreselectMode.None,
--
--     -- Mapping for keyboard shortcuts
--     mapping = {
--         ['<C-n>'] = cmp.mapping(function(fallback)
--             if luasnip.jumpable(1) then luasnip.jump(1) end
--         end, {"i", "s"}),
--         ['<C-p>'] = cmp.mapping(function(fallback)
--             if luasnip.jumpable(-1) then luasnip.jump(-1) end
--         end, {"i", "s"}),
--         ['<Tab>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 if luasnip.expand_or_jumpable() then
--                     cmp.select_next_item({})
--                 else
--                     cmp.select_next_item({behavior = cmp.SelectBehavior.Insert})
--                 end
--             else
--                 fallback()
--             end
--         end, {"i", "s"}),
--
--         ['<S-Tab>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 if luasnip.expand_or_jumpable() then
--                     cmp.select_prev_item({})
--                 else
--                     cmp.select_prev_item({behavior = cmp.SelectBehavior.Insert})
--                 end
--             else
--                 fallback()
--             end
--         end, {"i", "s"}),
--
--         ['<CR>'] = cmp.mapping(function(fallback)
--             local entry = cmp.get_selected_entry()
--             if entry == nil then
--                 -- for some reason, after entering a snippet and pressing enter, this mapping still
--                 -- gets called, but entry will be nil, in which case we just fallback, after which
--                 -- we'll have left the autocomplete context and everything returns to normal.
--                 -- Is there a more elegant way to fix this? Probably!
--                 fallback()
--             elseif entry:get_kind() == cmp_types.lsp.CompletionItemKind.Snippet then
--                 -- Insert the snippet and escape from autocomplete mode
--                 cmp.confirm({select = true})
--                 cmp.abort()
--                 fallback()
--             elseif luasnip.expand_or_jumpable() then
--                 luasnip.expand_or_jump()
--             end
--             if cmp.visible() then cmp.close() end
--             fallback()
--         end, {"i", "s"}),
--
--         ['<Esc>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 local entry = cmp.get_selected_entry()
--                 if not entry then
--                     cmp.abort()
--                     fallback()
--                 else
--                     fallback()
--                 end
--             else
--                 fallback()
--             end
--         end, {"i", "s"})
--     },
--
--     -- Define the sources for completion
--     sources = cmp.config.sources({
--         {name = 'nvim_lsp'}, {name = 'luasnip'}, {name = 'buffer'},
--         {name = 'path'}
--     })
-- })
--
-- local on_attach = function(client, bufnr)
--     client.config.flags.debounce_text_changes = 150
--     local opts = {noremap = true, silent = true}
--     local buf_set_keymap = vim.api.nvim_buf_set_keymap
--     buf_set_keymap(bufnr, 'n', 'gd', ':Telescope lsp_definitions<CR>', opts)
--     buf_set_keymap(bufnr, 'n', 'gr', ':Telescope lsp_references<CR><Esc>', opts)
--     buf_set_keymap(bufnr, 'n', 'go', ':Telescope diagnostics<CR><Esc>', opts)
--     buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
--     buf_set_keymap(bufnr, 'n', 'g[', '<cmd>lua vim.diagnostic.goto_next()<CR>',
--                    opts)
--     buf_set_keymap(bufnr, 'n', 'g]', '<cmd>lua vim.diagnostic.goto_prev()<CR>',
--                    opts)
--     buf_set_keymap(bufnr, 'n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--     buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--     buf_set_keymap(bufnr, 'n', 'gs',
--                    '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
-- end
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- local lspconfig = require('lspconfig')
-- -- lspconfig.pylsp.setup {
-- --     cmd = {vim.fn.expand('$HOME/.local/pylspenv/bin/pylsp')},
-- --     capabilities = capabilities,
-- --     on_attach = on_attach
-- -- }
-- require('lspconfig').ruff_lsp.setup {
--   on_attach = on_attach,
--   cmd = { vim.fn.expand('$HOME/.local/pylspenv/bin/ruff-lsp') },
--   init_options = {
--     settings = {
--       args = {},
--     }
--   }
-- }
--
-- -- lspconfig.jedi_language_server.setup({
-- --     cmd = { vim.fn.expand("$HOME/.local/pylspenv/bin/jedi-language-server")}
-- -- })
--
-- lspconfig.rust_analyzer.setup({
--     capabilities = capabilities,
--     on_attach = on_attach,
--     settings = {["rust-analyzer"] = {checkOnSave = {command = "clippy"}}}
-- })
--
-- vim.api.nvim_create_autocmd("CursorHold", {
--     callback = function()
--         local opts = {
--             focusable = false,
--             close_events = {
--                 "BufLeave", "CursorMoved", "InsertEnter", "FocusLost"
--             },
--             border = 'rounded',
--             source = 'always',
--             prefix = ' ',
--             scope = 'cursor'
--         }
--         vim.diagnostic.open_float(nil, opts)
--     end
-- })
--

-- local dap = require('dap')
--
-- dap.adapters.python = {
--     type = 'executable',
--     command = get_python_path(),
--     args = {'-m', 'debugpy.adapter'}
-- }
--
-- dap.configurations.python = {
--     {
--         type = 'python',
--         request = 'launch',
--         name = "Launch file",
--         console = "integratedTerminal",
--         redirectOutput = true,
--
--         -- Adjust the program path to point to your specific main Python file
--         program = "${file}",
--         pythonPath = function() return get_python_path() end
--     }
-- }
--
-- local dapui = require('dapui')
-- dapui.setup({
--     layouts = {
--         {
--             elements = {"scopes", "breakpoints", "stacks", "watches"},
--             size = 40,
--             position = "left" -- Can be "left", "right", "top", "bottom"
--         }, {elements = {"console"}, size = 16, position = "bottom"}
--     }
-- })
--
-- dap.listeners.after.event_initialized["dapui_config"] =
--     function() dapui.open() end
-- dap.listeners.before.event_terminated["dapui_config"] =
--     function() dapui.close() end
-- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
--
--
--
-- vim.o.background = "dark"
-- 

-- 

-- vim.api.nvim_set_keymap('n', '<leader>c',
--                         '<C-w>v<C-w>l:e $HOME/.config/nvim/init.lua<cr>',
--                         {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>r', ':source $MYVIMRC<cr>',
--                         {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>f', ':Telescope find_files<cr>',
--                         {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>g', ':Telescope live_grep<cr>',
--                         {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>t', ':!pytest tests -x<cr>',
--                         {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>m', ':!bash run-tests<cr>',
--                         {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>"', 'i""""""<Esc>hhi ',
--                         {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('t', '<C-n>', [[<C-\><C-n>]],
--                         {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<leader>b',
--                         '<Cmd>lua require("dap").toggle_breakpoint()$cr$', {})
-- vim.api.nvim_set_keymap('n', '<leader>b',
--                         '<Cmd>lua require("dap").toggle_breakpoint()<cr>', {})
-- vim.api.nvim_set_keymap('n', '<F1>', '<Cmd>lua require("dap").step_over()<cr>',
--                         {})
-- vim.api.nvim_set_keymap('n', '<F2>', '<Cmd>lua require("dap").step_into()<cr>',
--                         {})
-- vim.api.nvim_set_keymap('n', '<F3>', '<Cmd>lua require("dap").step_out()<cr>',
--                         {})
-- vim.api.nvim_set_keymap('n', '<F5>', '<Cmd>lua require("dap").continue()<cr>',
--                         {})
-- vim.api.nvim_set_keymap('n', '<F12>', ':DapTerminate<cr>', {})
-- vim.api.nvim_set_keymap('n', 's', ':w<cr>', {})
-- vim.cmd.highlight("default link IndentLine Comment")


vim.api.nvim_set_keymap('v', '<leader>y', '"+y', {noremap = true, silent = true})
