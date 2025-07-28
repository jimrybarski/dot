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
        event = 'BufReadPost',
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
        event = 'VeryLazy'
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = 'VeryLazy',
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
                ignore_install = { "org" },
                additional_vim_regex_highlighting = false,
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
            }
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
    { "L3MON4D3/LuaSnip" },
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
            {
                "jimrybarski/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
                cond = vim.fn.executable("cmake") == 1
            },
        },
    },
    { 'bioinformatics',                  dir = vim.fn.expand("$HOME/bioinformatics.nvim") },
    { 'mfussenegger/nvim-dap',           event = 'VeryLazy' },
    { 'rcarriga/nvim-dap-ui',            dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' }, event = 'VeryLazy' },
    { 'theHamsta/nvim-dap-virtual-text', dependencies = { 'mfussenegger/nvim-dap' },                          event = 'VeryLazy' },
    { 'mfussenegger/nvim-dap-python',    dependencies = { 'mfussenegger/nvim-dap' },                          event = 'VeryLazy', ft = 'python' },
}
