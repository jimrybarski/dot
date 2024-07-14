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
    { "norcalli/nvim-colorizer.lua" },
    -- none-ls, telescope and others depend on plenary
    {"nvim-lua/plenary.nvim"},
    {"nvimtools/none-ls.nvim"},
    -- { "folke/trouble.nvim",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    -- },
    {'nvim-tree/nvim-web-devicons'},
    {"neovim/nvim-lspconfig"},
    {"L3MON4D3/LuaSnip"},
    {"saadparwaiz1/cmp_luasnip"},
    {"hrsh7th/cmp-calc"},
    {"max397574/cmp-greek"},
    {"chrisgrieser/cmp-nerdfont"},
    {"ray-x/cmp-treesitter"},
    {"rcarriga/nvim-notify"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"},
    {"hrsh7th/nvim-cmp"},
    {"windwp/nvim-autopairs"}, 
    {
        "chrisgrieser/nvim-origami",
        event = "BufReadPost", -- later or on keypress would prevent saving folds
        opts = true -- needed even when using default config
    },
    {"lukas-reineke/indent-blankline.nvim"}, 
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
    },
    {'smoka7/hop.nvim'},
    {"akinsho/toggleterm.nvim"},
    {"nvim-lualine/lualine.nvim"},
    {"lewis6991/gitsigns.nvim"},
    -- nice color map 
    {"ellisonleao/gruvbox.nvim"},
    -- commands to comment/uncomment code
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
                    "lua", "luadoc", "make", "markdown",
                    "markdown_inline", "passwd", "python", "r",
                    "regex", "rust", "scss", "sql", "ssh_config", "toml", "tsv",
                    "vim", "vimdoc", "yaml"
                },
                additional_vim_regex_highlighting = false,
                auto_install = true,
            })
        end,
        install = {
            silent = true
        },
    }, {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {"nvim-treesitter/nvim-treesitter"}
    }, {"RRethy/vim-illuminate"},
    {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  }, config = true },
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
    },
    {
        "nvim-neorg/neorg",
        lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
        version = "*", -- Pin Neorg to the latest stable release
    }
}
