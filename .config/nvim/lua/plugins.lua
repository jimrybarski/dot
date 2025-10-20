-- function needed by nvim-treesitter-textobjects
local function ends_with(str, suffix)
    return suffix == "" or string.sub(str, -string.len(suffix)) == suffix
end

-- load plugins
require("lazy").setup {
    -- Color scheme
    { "ellisonleao/gruvbox.nvim",    event = 'VeryLazy' },
    -- After undoing something, the changed text is briefly highlighted
    { 'tzachar/highlight-undo.nvim', event = 'VeryLazy' },
    -- Emphasize all occurrences of the word under the cursor
    { "RRethy/vim-illuminate",       event = 'BufReadPost' },
    -- Jump to any character on the screen
    { 'smoka7/hop.nvim',             event = 'VeryLazy' },
    -- Utility library. Currently, we're using the following features:
    -- 1) bigfile: disables expensive processes when editing very large files
    -- 2) indent: shows vertical lines that match each indentation scope
    -- 3) input: a popup that can capture input from the user
    -- 4) notifier: popup notification messages
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false, -- must be false to be used during startup
        opts = {
            bigfile = { enabled = true, notify = false },
            indent = { enabled = true,
                animate = {
                    enabled = false
                },
                indent = {
                    hl = 'IblIndent', -- or set a custom color directly
                },
                scope = {
                    hl = 'IblScope', -- current scope highlight
                },
            },
            input = { enabled = true },
            notifier = {
                enabled = true,
                timeout = 5000,
                icons = {
                    error = " ",
                    warn = " ",
                    info = "",
                    debug = " ",
                    trace = " ",
                },
            },
        },
    },
    -- sets the background color of valid HTML colors to the actual color
    { "norcalli/nvim-colorizer.lua", ft = { 'css', 'javascript', 'html' }, event = 'VeryLazy' },
    -- utility functions that many other plugins use
    { "nvim-lua/plenary.nvim" },
    -- puts colored symbols in the sign gutter to mark where modifications to the file have occurred
    { "lewis6991/gitsigns.nvim",     event = 'VeryLazy' },
    -- testing framework
    { "notomo/vusted",               ft = 'lua',                           event = 'VeryLazy' },
    -- prevents the cursor from getting all the way to the bottom of the screen
    -- if you're on the last line, some virtual empty lines will be added to create a bit of a margin
    -- this is purely aesthetic
    {
        'Aasim-A/scrollEOF.nvim',
        event = { 'CursorMoved', 'WinScrolled' },
        opts = {},
    },
    -- Improved status line with cleaner and more useful information
    { "nvim-lualine/lualine.nvim", event = 'VeryLazy' },
    -- Highlights certain keywords and places an icon in the sign column
    -- Keywords: TODO, HACK, WARN, PERF, NOTE, TEST, WARNING, XXX, OPTIM, PERFORMANCE, OPTIMIZE, INFO, TESTING, PASSED, FAILED
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = 'VeryLazy',
        opts = {}
    },
    -- Adds the "surround" motion, letting you put quotes or brackets or whatever around a text object
    {
        "kylechui/nvim-surround",
        version = "*",
        event = 'VeryLazy'
    },
    -- Automatically insert closing brackets/quotes
    { "windwp/nvim-autopairs",     event = 'VeryLazy' },
    -- adds more programming-related text objects (functions, arguments, classes)
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        lazy = false,   -- Load immediately to ensure proper initialization
        config = false, -- Config is handled by treesitter main plugin
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false, -- Load immediately to ensure textobjects work
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                highlight = { enable = true },
                ensure_installed = {
                    "awk", "bash", "bibtex", "css", "diff", "dockerfile",
                    "fish", "gitcommit", "git_config", "gitignore",
                    "git_rebase", "gpg", "html", "javascript", "json", "json5",
                    "lua", "luadoc", "make", "markdown",
                    "markdown_inline", "passwd", "python", "r",
                    "regex", "rust", "scss", "sql", "ssh_config", "toml", "tsv",
                    "vim", "vimdoc", "yaml"
                },
                additional_vim_regex_highlighting = { 'org' },
                auto_install = true,
                sync_install = false,
                modules = {},
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
                    select = {
                        enable = true,
                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,
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
        end,
        install = {
            silent = true
        },
    },
    { "nvimtools/none-ls.nvim",      event = 'VeryLazy' },
    { 'nvim-tree/nvim-web-devicons', event = 'VeryLazy' },
    { "hrsh7th/nvim-cmp",            event = 'VeryLazy' },
    { "hrsh7th/cmp-nvim-lsp",        event = 'VeryLazy' },
    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {
            handler_opts = {
                border = "rounded"
            },
            doc_lines = 0,                           -- don't show function documentation in popup window
            floating_window_above_cur_line = false,  -- show popup below the cursor
            floating_window_off_y = 3,               -- move the popup a few lines down. The true offset appears to be random but
            -- a value of 3 seems to prevent it from covering up the cursor
            hint_enable = false,                     -- disable virtual text signature help
            toggle_key_flip_floatwin_setting = true, -- not sure what this does
        },
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        }, config = true,
        event = 'VeryLazy',
    },
    { "L3MON4D3/LuaSnip",
        build = "make install_jsregexp" },
    { "hrsh7th/cmp-calc" },
    { "max397574/cmp-greek" },
    { "chrisgrieser/cmp-nerdfont" },
    { "ray-x/cmp-treesitter" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "saadparwaiz1/cmp_luasnip" },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    (function()
        local local_path = vim.fn.expand("$HOME/bioinformatics.nvim")
        local stat = vim.uv.fs_stat(local_path)
        if stat and stat.type == "directory" then
            return { 'bioinformatics', dir = local_path }
        else
            return { 'jimrybarski/bioinformatics.nvim' }
        end
    end)(),
    { 'mfussenegger/nvim-dap',           event = 'VeryLazy' },
    { 'rcarriga/nvim-dap-ui',            dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' }, event = 'VeryLazy' },
    { 'theHamsta/nvim-dap-virtual-text', dependencies = { 'mfussenegger/nvim-dap' },                          event = 'VeryLazy' },
    { 'mfussenegger/nvim-dap-python',    dependencies = { 'mfussenegger/nvim-dap' },                          event = 'VeryLazy', ft = 'python' },
    {
        "greggh/claude-code.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("claude-code").setup()
        end
    },
    {
        "jiaoshijie/undotree", event = 'VeryLazy',
        opts = {
            window = {
                winblend = 0, -- make the diff window's background totally opaque (it's partially transparent by default)
                border = "rounded",
            },
        }
    },
    {
        "nvim-orgmode/orgmode",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = "VeryLazy",
        config = function()
            require('orgmode').setup({
                org_agenda_files = '~/notes/**/*',
                org_default_notes_file = '~/notes/refile.org',
                org_hide_emphasis_markers = true,
                org_startup_folded = 'showeverything',
                org_blank_before_new_entry = {
                    heading = false,
                    plain_list_item = false,
                },
                mappings = {
                    org_return_uses_meta_return = true,
                    org = {
                        org_open_at_point = '<CR>',
                    }
                }
            })
        end,
    },
    {
        "chipsenkbeil/org-roam.nvim",
        dependencies = {
            "nvim-orgmode/orgmode",
        },
        config = function()
            require("org-roam").setup({
                directory = "~/notes",
                templates = {
                    m = {
                        description = "meeting",
                        template = "%<%Y-%m-%d>\n\n* %?",
                        target = "meetings/%<%Y-%m-%d>-%[slug].org",
                    },
                    i = {
                        description = "info",
                        template = "* %?",
                        target = "info/%[slug].org",
                    },
                },
                bindings = {
                    ---Adjusts the prefix for every keybinding. Can be used in keybindings with <prefix>.
                    prefix = ",",
                    ---Adds an alias to the node under cursor.
                    add_alias = "<prefix>aa",

                    ---Adds an origin to the node under cursor.
                    add_origin = "<prefix>oa",

                    ---Opens org-roam capture window.
                    capture = "<prefix>c",

                    ---Completes the node under cursor.
                    complete_at_point = "<prefix>.",

                    ---Finds node and moves to it.
                    find_node = "<prefix>f",

                    ---Goes to the next node sequentially based on origin of the node under cursor.
                    ---
                    ---If more than one node has the node under cursor as its origin, a selection
                    ---dialog is displayed to choose the node.
                    goto_next_node = "<prefix>n",

                    ---Goes to the previous node sequentially based on origin of the node under cursor.
                    goto_prev_node = "<prefix>p",

                    ---Inserts node at cursor position.
                    insert_node = "<prefix>i",

                    ---Inserts node at cursor position without opening capture buffer.
                    insert_node_immediate = "<prefix>m",

                    ---Opens the quickfix menu for backlinks to the current node under cursor.
                    quickfix_backlinks = "<prefix>q",

                    ---Removes an alias from the node under cursor.
                    remove_alias = "<prefix>ar",

                    ---Removes the origin from the node under cursor.
                    remove_origin = "<prefix>or",

                    ---Toggles the org-roam node-view buffer for the node under cursor.
                    toggle_roam_buffer = "<prefix>l",

                    ---Toggles a fixed org-roam node-view buffer for a selected node.
                    toggle_roam_buffer_fixed = "<prefix>b",
                },
            })
        end
    },
    { 'akinsho/org-bullets.nvim', config = function()
        require('org-bullets').setup({
            concealcursor = true,
            symbols = {
                headlines = {
                    { "●", "MyBulletL1" },
                    { "-", "MyBulletL2" },
                    { "○", "MyBulletL3" },
                    { "◌", "MyBulletL4" },
                },
            },
        })
    end
    },
}
