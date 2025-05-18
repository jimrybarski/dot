-- load plugins
require("lazy").setup {
    -- { 'jimrybarski/bioinformatics.nvim' },
    { 'bioinformatics',             dir = '/home/jim/bioinformatics.nvim' },
    -- highlight undo/redo text
    { 'tzachar/highlight-undo.nvim' },
    -- keep some space below the cursor even at the end of the buffer
    {
        'Aasim-A/scrollEOF.nvim',
        event = { 'CursorMoved', 'WinScrolled' },
        opts = {},
    },
    { "xiyaowong/telescope-emoji.nvim" },
    { "norcalli/nvim-colorizer.lua" },
    -- none-ls, telescope and others depend on plenary
    { "nvim-lua/plenary.nvim" },
    { "nvimtools/none-ls.nvim" },
    -- { "folke/trouble.nvim",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    -- },
    { 'nvim-tree/nvim-web-devicons' },
    { "neovim/nvim-lspconfig" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "hrsh7th/cmp-calc" },
    { "max397574/cmp-greek" },
    { "chrisgrieser/cmp-nerdfont" },
    { "ray-x/cmp-treesitter" },
    { "rcarriga/nvim-notify" },
    { "notomo/vusted" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/nvim-cmp" },
    { "windwp/nvim-autopairs" },
    { 'mfussenegger/nvim-dap' },
    {
        "chrisgrieser/nvim-origami",
        event = "BufReadPost", -- later or on keypress would prevent saving folds
        opts = true            -- needed even when using default config
    },
    { "lukas-reineke/indent-blankline.nvim" },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
    },
    { 'smoka7/hop.nvim' },
    { "akinsho/toggleterm.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "lewis6991/gitsigns.nvim" },
    -- nice color map
    { "ellisonleao/gruvbox.nvim" },
    -- commands to comment/uncomment code
    { "numToStr/Comment.nvim" },
    {
        "nvim-treesitter/nvim-treesitter",
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
                ignore_install = { 'org' },
                additional_vim_regex_highlighting = false,
                auto_install = true,
            })
        end,
        install = {
            silent = true
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" }
    },
    { "RRethy/vim-illuminate" },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        }, config = true },
    { "lunarvim/bigfile.nvim" }, {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim", {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        cond = vim.fn.executable("cmake") == 1
    },
    },
},
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    {
        'nvim-orgmode/orgmode',
        event = 'VeryLazy',
        ft = { 'org' },
        config = function()
            require('orgmode').setup({
                -- See: https://github.com/nvim-orgmode/orgmode/blob/master/docs/configuration.org
                org_agenda_files = '~/notes/**/*',
                org_default_notes_file = '~/notes/refile.org',
                org_todo_keywords = { 'TODO(t)', 'NOW(n)', '|', 'DONE(d)' },
                org_todo_keyword_faces = {
                    TODO = ':foreground yellow',
                    NOW = ':background black :foreground blue :underline on',
                    DONE = ':foreground gray',
                },
                org_todo_repeat_to_state = "TODO",
                org_startup_folded = 'content',
                org_log_into_drawer = "LOGBOOK",
                org_agenda_skip_scheduled_if_done = true,
                org_agenda_skip_deadline_if_done = true,
                mappings = {
                    prefix = '<localleader>',
                },
                win_border = "double",
                org_capture_templates = {
                    j = {
                        description = 'Journal entry',
                        template = '* %?',
                        target = '~/notes/journal.org',
                        datetree = {
                            tree_type = 'day',
                        },
                    },
                    w = {
                        description = 'Work',
                        template = '* TODO %?',
                        target = '~/notes/todo/work.org',
                    },
                    l = {
                        description = 'Life',
                        template = '* TODO %?',
                        target = '~/notes/todo/life.org',
                    },
                    p = {
                        description = 'Project',
                        template = '* TODO %?',
                        target = '~/notes/todo/projects.org',
                    },
                    t = {
                        description = 'General',
                        template = '* TODO %?',
                        target = '~/notes/todo/todo.org',
                    },
                },
                org_agenda_custom_commands = {
                    l = {
                        description = "Life TODOs",
                        types = {
                            {
                                type = 'tags_todo',
                                org_agenda_overriding_header = 'Life TODOs',
                                org_agenda_files = { '~/notes/todo/life.org' },
                                org_agenda_sorting_strategy = { 'todo-state-up', 'priority-down' }
                            },
                        }
                    },
                    p = {
                        description = "Project TODOs",
                        types = {
                            {
                                type = 'tags_todo',
                                org_agenda_overriding_header = 'Project TODOs',
                                org_agenda_files = { '~/notes/todo/project.org' },
                                org_agenda_sorting_strategy = { 'todo-state-up', 'priority-down' }
                            },
                        }
                    },

                }
            })
        end,
    },
    -- {
    --   "chipsenkbeil/org-roam.nvim",
    --   tag = "0.1.1",
    --   dependencies = {
    --     {
    --       "nvim-orgmode/orgmode",
    --       tag = "0.3.7",
    --     },
    --   },
    --   config = function()
    --     require("org-roam").setup({
    --       directory = "~/notes",
    --     })
    --   end
    -- },
    --   {
    --     "nvim-orgmode/telescope-orgmode.nvim",
    --     event = "VeryLazy",
    --     dependencies = {
    --       "nvim-orgmode/orgmode",
    --       "nvim-telescope/telescope.nvim",
    --     },
    --     config = function()
    --       require("telescope").load_extension("orgmode")
    --
    --       vim.keymap.set("n", "<leader>r", require("telescope").extensions.orgmode.refile_heading)
    --       vim.keymap.set("n", "<leader>fh", require("telescope").extensions.orgmode.search_headings)
    --       vim.keymap.set("n", "<leader>li", require("telescope").extensions.orgmode.insert_link)
    --     end,
    --   }
}
