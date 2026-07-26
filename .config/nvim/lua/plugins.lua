require("lazy").setup({
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
    -- Color scheme (high priority so it loads before everything else)
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.o.background = "dark"
            vim.cmd("colorscheme gruvbox")
        end,
    },
    -- After undoing something, the changed text is briefly highlighted
    {
        "tzachar/highlight-undo.nvim",
        event = "VeryLazy",
        config = function() require("highlight-undo").setup({}) end,
    },
    -- Emphasize all occurrences of the word under the cursor
    {
        "RRethy/vim-illuminate",
        event = "BufReadPost",
        config = function() require("illuminate").configure({}) end,
    },
    -- Jump to any character on the screen
    { "smoka7/hop.nvim", event = "VeryLazy" },
    -- Sets the background color of valid CSS colors to the actual color
    {
        "catgoose/nvim-colorizer.lua",
    },
    -- A nice interface that allows fuzzy finding on lists
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    -- Put markers in the sign column to indicate where edits have occurred since the last commit
    { "lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {} },
    -- Virtual blank lines at EOF so the cursor stays scrolloff lines from the bottom
    { "Aasim-A/scrollEOF.nvim", event = { "BufRead", "BufNewFile" }, opts = {} },
    -- Nice-looking status bar
    { "nvim-lualine/lualine.nvim", event = "VeryLazy", opts = {} },
    -- Highlights TODO/HACK/WARN/NOTE/etc. keywords with icons
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        opts = {},
    },
    -- Adds the "surround" motion for wrapping text objects in quotes/brackets/etc.
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
    -- adds more programming-related text objects (functions, arguments, classes)
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        lazy = false, -- Load immediately to ensure proper initialization
        config = false, -- configured alongside treesitter itself, in lua/treesitter.lua
    },
    -- Bioinformatics conveniences
    { "jimrybarski/bioinformatics.nvim" },
    -- In-buffer markdown rendering (headers, code blocks, tables, etc.)
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "markdown" },
        opts = {
            link = {
                wiki = {
                    -- Aliased links already render correctly by default: the
                    -- destination is concealed and the alias shown. This only
                    -- covers [[20260725-211310]] written without one, which
                    -- would otherwise display as a bare timestamp.
                    body = function(ctx)
                        -- Returning a string here would take the branch that
                        -- conceals the whole node and re-inlines it, undoing the
                        -- default handling. Leave aliased links alone.
                        if ctx.alias then return nil end
                        if not ctx.destination:match("^%d%d%d%d%d%d%d%d%-%d%d%d%d%d%d$") then
                            return nil
                        end
                        -- nil for an unresolved stamp, so a dangling link shows
                        -- what it points at rather than quietly rendering as prose
                        return require("notes").title_for(ctx.destination)
                    end,
                },
            },
        },
    },
    -- Treesitter: syntax highlighting and parsing
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false, -- main does not support lazy-loading
        branch = "main",
        build = ":TSUpdate",
        config = function() require("treesitter") end,
    },
    -- Debugger
    {
        'mfussenegger/nvim-dap',
        event = 'VeryLazy',
        config = function()
            local dap = require('dap')
            -- brew install codelldb  OR  download from https://github.com/vadimcn/codelldb/releases
            -- extract the vsix (rename to .zip) to ~/.local/codelldb/
            dap.adapters.codelldb = {
                type = 'server',
                port = '${port}',
                executable = {
                    command = vim.fn.expand('~/.local/codelldb/extension/adapter/codelldb'),
                    args = { '--port', '${port}' },
                },
            }
            dap.configurations.rust = {
                {
                    name = 'Debug binary',
                    type = 'codelldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input('Executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                },
            }
        end,
    },
    -- Puts the values of variables inline as virtual text
    { 'theHamsta/nvim-dap-virtual-text', dependencies = { 'mfussenegger/nvim-dap' }, event = 'VeryLazy' },
    -- Python debugger adapter
    {
        'mfussenegger/nvim-dap-python',
        dependencies = { 'mfussenegger/nvim-dap' },
        event = 'VeryLazy',
        ft = 'python',
        config = function()
            -- python3 -m venv ~/.local/debugpy && ~/.local/debugpy/bin/pip install debugpy
            require('dap-python').setup(vim.fn.expand('$HOME/.local/pylspenv/bin/python'))
        end,
    },
    -- Interface for the debugger
    {
        'igorlfs/nvim-dap-view',
        dependencies = { 'mfussenegger/nvim-dap' },
        event = 'VeryLazy',
        opts = {},
    },
    -- Snippet engine
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip").config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
            })
            require("luasnip.loaders.from_vscode").lazy_load()
            require("snippets")
        end,
    },
    -- nvim-cmp source compatibility shim (needed for cmp-greek)
    { "Saghen/blink.compat", version = "*", opts = {} },
    -- Greek character completions (e.g. type :delta: and pick δ from the completion popup)
    { "max397574/cmp-greek" },
    -- Autocomplete
    {
        "Saghen/blink.cmp",
        version = "*",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "Saghen/blink.compat",
            "max397574/cmp-greek",
        },
        opts = {
            keymap = {
                preset = "none",
                -- C-y is used to select snippets because it's a mess having them auto-insert.
                -- All other sources have their text automatically inserted
                ["<C-y>"] = { "accept", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-h>"] = { "scroll_documentation_up", "fallback" },
                ["<C-l>"] = { "scroll_documentation_down", "fallback" },
                -- Tab/S-Tab navigate snippet tabstops; fall back to literal tab otherwise
                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
                -- Esc exits snippet mode (if active), hides the menu, then exits insert mode
                ["<Esc>"] = {
                    function()
                        require("luasnip").unlink_current()
                        require("blink.cmp").hide()
                    end,
                    "fallback",
                },
            },
            snippets = { preset = "luasnip" },
            sources = {
                default = { "lsp", "snippets", "buffer", "path", "greek" },
                providers = {
                    lsp      = { min_keyword_length = 1 },
                    snippets = { min_keyword_length = 1 },
                    buffer   = { min_keyword_length = 1 },
                    path     = { min_keyword_length = 1, opts = { show_hidden_files_by_default = true } },
                    greek = {
                        name = "greek",
                        module = "blink.compat.source",
                        min_keyword_length = 1,
                    },
                },
            },
            completion = {
                accept = {
                    auto_brackets = { enabled = true },
                },
                menu = {
                    auto_show = true,
                    -- Go above the cursor when signature help is also visible, below otherwise.
                    -- blink re-evaluates this function on every CursorMovedI, so it tracks
                    -- sig_active (set by the LSP callback in lsp.lua) with at most one-char lag.
                    -- package.loaded avoids a premature require during blink's startup validation.
                    direction_priority = function()
                        local lsp = package.loaded['lsp']
                        return (lsp and lsp.sig_active()) and { 'n', 's' } or { 's', 'n' }
                    end,
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind", gap = 1 },
                            { "source_name" },
                        },
                    },
                },
                list = {
                    selection = {
                        preselect = false,  -- don't auto-select; user navigates with C-j/C-k
                        auto_insert = true, -- navigating to an item immediately inserts it
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                    window = { border = "rounded" },
                },
            },
        },
    },
    -- Helpers for running tests and displaying results in the editor
    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-neotest/nvim-nio',
            'nvim-lua/plenary.nvim',
            'nvim-neotest/neotest-python',
            'rouge8/neotest-rust',
        },
        event = 'VeryLazy',
        config = function() require('testing') end,
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
    -- Notes: full-text search, tags, [[links]] and backlinks over ~/notes.
    -- Creating notes and walking the timeline live in lua/notes.lua instead,
    -- since telekasten can only file new notes into its own periodic-note dirs.
    {
        "nvim-telekasten/telekasten.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        -- Every entry point is a :Telekasten command, and with auto_set_syntax off
        -- there is nothing to apply on opening a note, so cmd-lazy is enough.
        cmd = "Telekasten",
        opts = {
            home = vim.fn.expand("~/notes"),
            extension = ".md",

            -- Tags live in the frontmatter as `tags: [ recipe, dinner ]`.
            -- The inline #tag notation would need ripgrep's PCRE2 engine to tell
            -- tags from hex colors, and our ripgrep is built without it.
            tag_notation = "yaml-bare",

            -- Leave notes as filetype=markdown so render-markdown.nvim keeps working
            auto_set_filetype = false,
            take_over_my_home = false,

            -- Telekasten's pickers run `set syntax=telekasten` in post_open, but
            -- notes.lua opens notes with :edit and never triggers it. Turning it
            -- off keeps rendering uniformly render-markdown's job no matter which
            -- keymap opened the note.
            auto_set_syntax = false,

            -- Generate [[20260725-193045]] rather than [[2026/20260725-193045]].
            -- Link resolution scans the year directories either way.
            subdirs_in_links = false,

            -- notes.lua owns note creation; never let telekasten place a file
            follow_creates_nonexisting = false,
            dailies_create_nonexisting = false,
            weeklies_create_nonexisting = false,
            monthlies_create_nonexisting = false,
            quarterlies_create_nonexisting = false,
            yearlies_create_nonexisting = false,

            image_subdir = "img",
            image_link_style = "markdown",
            clipboard_program = "xclip",
            sort = "modified",
            show_tags_theme = "ivy",
        },
    },
    -- Read-only agenda over checkbox tasks. Only lines matching `- [ ]` or `- [-]`
    -- AND carrying an @scheduled(...) or @deadline(...) annotation are collected;
    -- everything else, including `- [x]`, is ignored:
    --
    --     - [ ] Buy tofu @scheduled(2026-07-30) @deadline(2026-08-05)
    --
    -- Dates are day-granularity only. The plugin never writes to a note; every
    -- action that does is lua/agenda.lua, mapped both in notes and in this
    -- window.
    {
        "Kamyil/markdown-agenda.nvim",
        cmd = "MarkdownAgenda",
        opts = {
            -- Globbed as `<directory>/**/*.md`, so every year directory is covered
            directory = "~/notes",
            recursive = true,
            date_format = "%Y-%m-%d",

            border = "rounded",

            -- The footer help line is hardcoded in the plugin and only ever
            -- mentions its own three keys, so the editing ones go in the title.
            -- It fits: min_width is 95 whenever the calendar sits on the right.
            title = " Agenda   x done · p progress · s schedule · d deadline · r rescan ",

            calendar = {
                enabled = true,
                months_to_show = 3,
                position = "right",
                week_start = "monday",
            },

            -- Keymaps live in keymaps.lua, so suppress the built-in <leader>na
            keymaps = { open = false },
        },
    },
}, {
    -- Lazy.nvim options
    ui = { border = "rounded" },
})
