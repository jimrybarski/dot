-- load plugins
require("lazy").setup {
    { 'tzachar/highlight-undo.nvim',    event = 'VeryLazy' },
    { "RRethy/vim-illuminate", event = 'BufReadPost' },
    -- Color scheme
    { "ellisonleao/gruvbox.nvim" },
    -- Jump to any character on the screen
    { 'smoka7/hop.nvim',          event = 'VeryLazy' },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
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
    { "norcalli/nvim-colorizer.lua",    ft = { 'css', 'javascript', 'html' } },
    { "nvim-lua/plenary.nvim" },
    { "lewis6991/gitsigns.nvim" },
}
--     { 'jimrybarski/bioinformatics.nvim' },
--     -- { 'bioinformatics', dir = '/home/jim/bioinformatics.nvim', event = 'VeryLazy' },
--     -- keep some space below the cursor even at the end of the buffer
--     {
--         'Aasim-A/scrollEOF.nvim',
--         event = { 'CursorMoved', 'WinScrolled' },
--         opts = {},
--     },
--     { "xiyaowong/telescope-emoji.nvim", event = 'VeryLazy' },
--     -- none-ls, telescope and others depend on plenary
--     { "nvimtools/none-ls.nvim" },
--     -- { "folke/trouble.nvim",
--     --     dependencies = { "nvim-tree/nvim-web-devicons" },
--     -- },
--     { 'nvim-tree/nvim-web-devicons' },
--     { "neovim/nvim-lspconfig" },
--     { "L3MON4D3/LuaSnip" },
--     { "saadparwaiz1/cmp_luasnip" },
--     { "hrsh7th/cmp-calc" },
--     { "max397574/cmp-greek" },
--     { "chrisgrieser/cmp-nerdfont" },
--     { "ray-x/cmp-treesitter" },
--     { "notomo/vusted",                  ft = 'lua' },
--     { "hrsh7th/cmp-nvim-lsp" },
--     { "hrsh7th/cmp-buffer" },
--     { "hrsh7th/cmp-path" },
--     { "hrsh7th/nvim-cmp" },
--     -- { "windwp/nvim-autopairs" },
--     -- { 'mfussenegger/nvim-dap',          event = 'VeryLazy' },
--     {
--         "kylechui/nvim-surround",
--         version = "*",
--         event = 'VeryLazy'
--     },
--     { "akinsho/toggleterm.nvim",  event = 'VeryLazy' },
--     { "nvim-lualine/lualine.nvim" },
--     -- nice color map
--     -- commands to comment/uncomment code
--     {
--         "nvim-treesitter/nvim-treesitter",
--         build = ":TSUpdate",
--         config = function()
--             local configs = require("nvim-treesitter.configs")
--             configs.setup({
--                 highlight = { enable = true },
--                 ensure_installed = {
--                     "awk", "bash", "bibtex", "css", "diff", "dockerfile",
--                     "fish", "gitcommit", "git_config", "gitignore",
--                     "git_rebase", "gpg", "html", "javascript", "json", "json5",
--                     "lua", "luadoc", "make", "markdown",
--                     "markdown_inline", "passwd", "python", "r",
--                     "regex", "rust", "scss", "sql", "ssh_config", "toml", "tsv",
--                     "vim", "vimdoc", "yaml"
--                 },
--                 ignore_install = { "org" },
--                 additional_vim_regex_highlighting = false,
--                 auto_install = true,
--             })
--         end,
--         install = {
--             silent = true
--         },
--     },
--     {
--         "nvim-treesitter/nvim-treesitter-textobjects",
--         dependencies = { "nvim-treesitter/nvim-treesitter" }
--     },
--     {
--         "NeogitOrg/neogit",
--         dependencies = {
--             "nvim-lua/plenary.nvim",
--             "sindrets/diffview.nvim",
--             "nvim-telescope/telescope.nvim",
--         }, config = true },
--     {
--         "nvim-telescope/telescope.nvim",
--         branch = "0.1.x",
--         dependencies = {
--             "nvim-lua/plenary.nvim", {
--             "nvim-telescope/telescope-fzf-native.nvim",
--             build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
--             cond = vim.fn.executable("cmake") == 1
--         },
--         },
--     },
--     {
--         "folke/todo-comments.nvim",
--         dependencies = { "nvim-lua/plenary.nvim" },
--         event = 'BufReadPost',
--         opts = {}
--     },
--     {
--         'nvim-orgmode/orgmode',
--         event = 'VeryLazy',
--         ft = { 'org' },
--         config = function()
--             require('orgmode').setup({
--                 -- See: https://github.com/nvim-orgmode/orgmode/blob/master/docs/configuration.org
--                 org_agenda_files = '~/notes/**/*',
--                 org_todo_keywords = { 'TODO(t)', 'NOW(n)', '|', 'DONE(d)' },
--                 org_todo_keyword_faces = {
--                     TODO = ':foreground yellow',
--                     NOW = ':background black :foreground blue :underline on',
--                     DONE = ':foreground gray',
--                 },
--                 org_todo_repeat_to_state = "TODO",
--                 org_startup_folded = 'showeverything',
--                 org_log_into_drawer = "LOGBOOK",
--                 org_agenda_skip_scheduled_if_done = true,
--                 org_agenda_skip_deadline_if_done = true,
--                 mappings = {
--                     prefix = '<localleader>',
--                 },
--                 win_border = "double",
--             })
--         end,
--     },
--     {
--         "chipsenkbeil/org-roam.nvim",
--         tag = "0.1.1",
--         dependencies = {
--             {
--                 "nvim-orgmode/orgmode",
--             },
--         },
--         config = function()
--             require("org-roam").setup({
--                 directory = "~/notes",
--                 bindings = {
--                     prefix = "<localleader>n",
--                     add_alias = "<prefix>aa",
--                     ---Adds an origin to the node under cursor.
--                     add_origin = "<prefix>oa",
--                     ---Opens org-roam capture window.
--                     capture = "<prefix>c",
--                     ---Completes the node under cursor.
--                     complete_at_point = "<prefix>.",
--                     ---Finds node and moves to it.
--                     find_node = "<prefix>f",
--                     ---Goes to the next node sequentially based on origin of the node under cursor.
--                     ---If more than one node has the node under cursor as its origin, a selection
--                     ---dialog is displayed to choose the node.
--                     goto_next_node = "<prefix>n",
--                     ---Goes to the previous node sequentially based on origin of the node under cursor.
--                     goto_prev_node = "<prefix>p",
--                     ---Inserts node at cursor position.
--                     insert_node = "<prefix>i",
--                     ---Inserts node at cursor position without opening capture buffer.
--                     insert_node_immediate = "<prefix>m",
--                     ---Opens the quickfix menu for backlinks to the current node under cursor.
--                     quickfix_backlinks = "<prefix>q",
--                     ---Removes an alias from the node under cursor.
--                     remove_alias = "<prefix>ar",
--                     ---Removes the origin from the node under cursor.
--                     remove_origin = "<prefix>or",
--                     ---Toggles the org-roam node-view buffer for the node under cursor.
--                     toggle_roam_buffer = "<prefix>l",
--                     ---Toggles a fixed org-roam node-view buffer for a selected node.
--                     toggle_roam_buffer_fixed = "<prefix>b",
--                 },
--                 capture = {
--                     templates = {
--                         d = {
--                             template = "%?",
--                             target = "%<%Y-%m-%d>.org",
--                         },
--                         -- Learning subjects from TODO.md
--                         r = {
--                             description = "Rust learning note",
--                             template = "#+title: %?\n#+filetags: :rust:\n\n",
--                             target = "rust/%<%Y%m%d%H%M%S>-${slug}.org",
--                         },
--                         b = {
--                             description = "Biology/Bioinformatics note",
--                             template = "#+title: %?\n#+filetags: :biology:\n\n",
--                             target = "biology/%<%Y%m%d%H%M%S>-${slug}.org",
--                         },
--                         c = {
--                             description = "Chinese language note",
--                             template = "#+title: %?\n#+filetags: :chinese:\n\n",
--                             target = "chinese/%<%Y%m%d%H%M%S>-${slug}.org",
--                         },
--                         s = {
--                             description = "Spanish language note",
--                             template = "#+title: %?\n#+filetags: :spanish:\n\n",
--                             target = "spanish/%<%Y%m%d%H%M%S>-${slug}.org",
--                         },
--                         e = {
--                             description = "Electronics note",
--                             template = "#+title: %?\n#+filetags: :electronics:\n\n",
--                             target = "electronics/%<%Y%m%d%H%M%S>-${slug}.org",
--                         },
--                         m = {
--                             description = "Statistics/ML note",
--                             template = "#+title: %?\n#+filetags: :statistics:ml:\n\n",
--                             target = "ml-stats/%<%Y%m%d%H%M%S>-${slug}.org",
--                         },
--                         p = {
--                             description = "Paper/Publication note",
--                             template =
--                             "#+title: %?\n#+filetags: :paper:\n#+bibliography: ~/notes/bibliography.bib\n\n* Summary\n\n* Key Findings\n\n* References\n",
--                             target = "papers/%<%Y%m%d%H%M%S>-${slug}.org",
--                         },
--                         t = {
--                             description = "Meeting notes",
--                             template =
--                             "#+title: Meeting: %?\n#+filetags: :meeting:\n#+date: %<%Y-%m-%d>\n\n* Attendees\n\n* Discussion\n\n* Action Items\n",
--                             target = "meetings/%<%Y%m%d%H%M%S>-${slug}.org",
--                         },
--                     },
--                 },
--             })
--         end
--     },
--     {
--         "nvim-orgmode/telescope-orgmode.nvim",
--         event = "VeryLazy",
--         dependencies = {
--             "nvim-orgmode/orgmode",
--             "nvim-telescope/telescope.nvim",
--         },
--         config = function()
--             require("telescope").load_extension("orgmode")
--
--             vim.keymap.set("n", "<leader>or", require("telescope").extensions.orgmode.refile_heading)
--             vim.keymap.set("n", "<leader>of", require("telescope").extensions.orgmode.search_headings)
--             vim.keymap.set("n", "<leader>oi", require("telescope").extensions.orgmode.insert_link)
--         end,
--     }
-- }
