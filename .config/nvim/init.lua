local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable",
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

-- Show relative line numbers except on the current line, which shows the absolute line number
vim.opt.number = true
vim.opt.relativenumber = true

-- Don't make annoying backup files
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Always show the sign column (the column on the left that shows lint warnings and git changes)
vim.opt.signcolumn = "yes"

-- Faintly highlight the line the cursor is on
vim.opt.cursorline = true

require("lazy").setup({
    -- nice color map 
    {"ellisonleao/gruvbox.nvim"}, 
    -- commands to comment/uncomment code
    {"numToStr/Comment.nvim"}, 
    -- popup to explain what various keys will do
    {"folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            plugins = {
                marks = true, -- shows a list of your marks on ' and `
                registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
                -- the presets plugin, adds help for a bunch of default keybindings in Neovim
                -- No actual key bindings are created
                spelling = {
                    enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                    suggestions = 20 -- how many suggestions should be shown in the list?
                },
                presets = {
                    operators = true, -- adds help for operators like d, y, ...
                    motions = true, -- adds help for motions
                    text_objects = true, -- help for text objects triggered after entering an operator
                    windows = true, -- default bindings on <c-w>
                    nav = true, -- misc bindings to work with windows
                    z = true, -- bindings for folds, spelling and others prefixed with z
                    g = true -- bindings for prefixed with g
                }
            },
            -- add operators that will trigger motion and text object completion
            -- to enable all native operators, set the preset / operators plugin above
            operators = {gc = "Comments"},
            key_labels = {
                -- override the label used to display some keys. It doesn't effect WK in any other way.
                -- For example:
                -- ["<space>"] = "SPC",
                -- ["<cr>"] = "RET",
                -- ["<tab>"] = "TAB",
            },
            motions = {count = true},
            icons = {
                breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
                separator = "➜", -- symbol used between a key and its label
                group = "+" -- symbol prepended to a group
            },
            popup_mappings = {
                scroll_down = "<c-d>", -- binding to scroll down inside the popup
                scroll_up = "<c-u>" -- binding to scroll up inside the popup
            },
            window = {
                border = "none", -- none, single, double, shadow
                position = "bottom", -- bottom, top
                margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
                padding = {1, 2, 1, 2}, -- extra window padding [top, right, bottom, left]
                winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
                zindex = 1000 -- positive value to position WhichKey above other floating windows.
            },
            layout = {
                height = {min = 4, max = 25}, -- min and max height of the columns
                width = {min = 20, max = 50}, -- min and max width of the columns
                spacing = 3, -- spacing between columns
                align = "left" -- align columns left, center or right
            },
            ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
            hidden = {
                "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ",
                "^lua "
            }, -- hide mapping boilerplate
            show_help = true, -- show a help message in the command line for using WhichKey
            show_keys = true, -- show the currently pressed key and its label as a message in the command line
            triggers = "auto", -- automatically setup triggers
            -- triggers = {"<leader>"} -- or specifiy a list manually
            -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
            triggers_nowait = {
                -- marks
                "`", "'", "g`", "g'", -- registers
                '"', "<c-r>", -- spelling
                "z="
            },
            triggers_blacklist = {
                -- list of mode / prefixes that should never be hooked by WhichKey
                -- this is mostly relevant for keymaps that start with a native binding
                i = {"j", "k"},
                v = {"j", "k"}
            },
            -- disable the WhichKey popup for certain buf types and file types.
            -- Disabled by default for Telescope
            disable = {buftypes = {}, filetypes = {}}
        }
    }
})

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

-- Set the colorscheme to a nice color palette
vim.cmd("colorscheme gruvbox")

--     "nvim-lua/plenary.nvim", 
--     "nvim-tree/nvim-web-devicons", 
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
--     }, {"nvim-telescope/telescope-fzf-native.nvim", build = "make"}, {
--         "nvim-treesitter/nvim-treesitter",
--         build = ":TSUpdate",
--         config = function()
--             local configs = require("nvim-treesitter.configs")
--             configs.setup({
--                 ensure_installed = {
--                     "awk",
--                     "bash",
--                     "bibtex",
--                     "css",
--                     "diff",
--                     "dockerfile",
--                     "fish",
--                     "gitcommit",
--                     "git_config",
--                     "gitignore",
--                     "git_rebase",
--                     "gpg",
--                     "html",
--                     "javascript",
--                     "json",
--                     "json5",
--                     "latex",
--                     "lua",
--                     "luadoc",
--                     "make",
--                     "markdown",
--                     "markdown_inline",
--                     "passwd",
--                     "printf",
--                     "python",
--                     "r",
--                     "regex",
--                     "rust",
--                     "scss",
--                     "sql",
--                     "ssh_config",
--                     "toml",
--                     "tsv",
--                     "vim",
--                     "vimdoc",
--                     "yaml"
--                 }
--             })
--         end
--     }, 
--     {"akinsho/toggleterm.nvim"},
--     
--     {"hrsh7th/cmp-buffer"},
--     {"hrsh7th/cmp-cmdline"},
--     {"hrsh7th/cmp-nvim-lsp"},
--     {"hrsh7th/cmp-path"},
--     {"hrsh7th/nvim-cmp"},
--     {"klen/nvim-test"},
--     {"kylechui/nvim-surround"},
--     {"L3MON4D3/LuaSnip"},
--     {"lewis6991/gitsigns.nvim"},
--     {"lukas-reineke/indent-blankline.nvim"},
--     {"lunarvim/bigfile.nvim"},
--     {"mfussenegger/nvim-dap"},
--     
--     {"nvim-lualine/lualine.nvim"},
--     {"ray-x/lsp_signature.nvim"},
--     {"rcarriga/nvim-dap-ui"},
--     {"RRethy/vim-illuminate"},
--     {"saadparwaiz1/cmp_luasnip"},
--     {'smoka7/hop.nvim'},
--     {"windwp/nvim-autopairs"},
-- }, {})
--
-- require("nvim-test").setup {}
--
-- local highlight = {"CursorColumn"}
-- require('ibl').setup({
--     scope = {highlight = highlight, show_start = false, show_end = false}
-- })
-- require("toggleterm").setup()
-- require('lualine').setup({
--     options = {
--         icons_enabled = false,
--         theme = 'auto',
--         component_separators = {left = '', right = ''},
--         section_separators = {left = '', right = ''},
--         disabled_filetypes = {statusline = {}, winbar = {}},
--         ignore_focus = {},
--         always_divide_middle = true,
--         globalstatus = false,
--         refresh = {statusline = 1000, tabline = 1000, winbar = 1000}
--     },
--     sections = {
--         lualine_a = {'mode'},
--         lualine_b = {'branch', 'diff', 'diagnostics'},
--         lualine_c = {'filename'},
--         lualine_x = {'filetype'},
--         lualine_y = {'progress'},
--         lualine_z = {'location'}
--     },
--     inactive_sections = {
--         lualine_a = {},
--         lualine_b = {},
--         lualine_c = {'filename'},
--         lualine_x = {'location'},
--         lualine_y = {},
--         lualine_z = {}
--     },
--     tabline = {},
--     winbar = {},
--     inactive_winbar = {},
--     extensions = {}
-- })
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
-- local luasnip = require("luasnip")
--
-- local date = function() return os.date("%Y-%m-%d") end
--
-- -- MY CUSTOM SNIPPETS
-- local s = luasnip.snippet
-- local t = luasnip.text_node
-- local i = luasnip.insert_node
-- local f = luasnip.function_node
--
-- luasnip.add_snippets("all", {
--     s("bash", {t("#!/usr/bin/env bash")}),
--     s("zsh", {t("#!/usr/bin/env zsh")}),
--     s("fish", {t("#!/usr/bin/env fish")}),
--     s("d", {f(date, {})})
-- })
--
-- luasnip.add_snippets("python", {
--     s("mpl", {t("import matplotlib.pyplot as plt")}),
--     s("fig", {t("fig, ax = plt.subplots()")}), s("figs", {
--         t("fig, ax = plt.subplots(figsize=("), i(1, "height"), t(", "),
--         i(2, "width"), t("))")
--     }), s("def", {
--         t("def "), i(1, "fname"), t("("), i(2, "arg"), t(") -> "),
--         i(3, "returns"), t(":\n\t"), i(4, "pass"), i(0)
--     }), s("ifmain", {
--         t("if __name__ == '__main__':"), t({"", "\t"}), -- Splitting the newline and indentation into a new text node
--         i(1, "pass"), i(0)
--     }),
--     s("fim", {t("from "), i(1, "package"), t(" import "), i(2, "module"), i(0)})
-- })
--
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
-- local autopairs = require('nvim-autopairs')
-- autopairs.setup({ignored_next_char = "[%w%.%(%[{]"})
-- require("which-key").setup()
-- require("gitsigns").setup()

-- require("bigfile").setup()
--
-- require("toggleterm").setup {
--     open_mapping = [[<c-\>]], -- Change this keymap to your preferred key binding
--     hide_numbers = true, -- hide the number column in toggleterm buffers
--     shade_filetypes = {},
--     shade_terminals = true,
--     shading_factor = 2, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
--     start_in_insert = true,
--     insert_mappings = true, -- whether or not the open mapping applies in insert mode
--     persist_size = true,
--     direction = 'float', -- 'vertical', 'horizontal', 'tab', or 'float'
--     close_on_exit = true -- close the terminal window when the process exits
-- }
--
-- local function get_python_path(workspace)
--     -- Check if a virtual environment is active
--     local venv_path = os.getenv("VIRTUAL_ENV")
--     if venv_path then
--         -- If a virtual environment is active, use the Python from it
--         return venv_path .. "/bin/python"
--     else
--         -- Otherwise, fall back to system Python
--         return "/usr/bin/python3" -- Or your system's default Python 3 path
--     end
-- end
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
-- require("hop").setup()
-- vim.api.nvim_set_keymap("n", "\\", ":HopChar1<CR>", {noremap = true})
-- vim.api.nvim_set_keymap("o", "\\", ":HopChar1<CR>", {noremap = true})
--
-- require("nvim-surround").setup({})
--
-- vim.o.background = "dark"
-- vim.o.updatetime = 500
-- 

-- 
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

-- Use real tabs and not spaces in .tsv files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tsv",
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

-- Use real tabs and not sapces in Makefiles
vim.api.nvim_create_autocmd("FileType", {
    pattern = "make",
    callback = function()
        vim.opt_local.expandtab = false
    end,
})

-- transparently edit gzipped files
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
-- vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

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
--                         '<Cmd>lua require("dap").toggle_breakpoint()<cr>', {})
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
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', {noremap = true, silent = true})
--
-- vim.cmd.highlight("default link IndentLine Comment")
--
