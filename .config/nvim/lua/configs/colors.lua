-- Set the colorscheme to a nice color palette
require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = { strings = false, comments = true },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,    -- invert background for search, diffs, statuslines and errors
    contrast = "soft", -- can be "hard", "soft" or empty string
    dim_inactive = false,
    transparent_mode = false
})
vim.cmd("colorscheme gruvbox")

-- set the colors for search highlighting
--
-- bright red for current match where the cursor is
vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#FF6C24', fg = '#000000' })
-- pale yellow for other, non-selected matches
vim.api.nvim_set_hl(0, 'Search', { bg = '#FFBC48', fg = '#000000' })

-- set the colors of the vertical indentation lines
-- these are used by folke/snacks.nvim
--
-- color of the current scope where the cursor is
vim.api.nvim_set_hl(0, 'IblScope', { fg = '#7C6856' })
-- color of inactive scopes
vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#5A4B3E' })

-- Briefly highlight text affected by undo/redo and auto-formatting
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
        lhs = 'U',
        map = 'redo',
        opts = {}
    },
    keymaps = {
        paste = { disabled = true },
        Paste = { disabled = true },
    },
    highlight_for_count = true,
})

-- Emphasize all occurrences of the word under the cursor
require("illuminate").configure({
    -- providers: provider used to get references in the buffer, ordered by priority
    providers = { 'lsp', 'treesitter', 'regex' },
    -- delay: delay in milliseconds
    delay = 0,
    -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
    filetypes_denylist = { 'dirbuf', 'dirvish', 'fugitive' },
    -- under_cursor: whether or not to illuminate under the cursor
    under_cursor = false,
    -- large_file_cutoff: number of lines at which to use large_file_config
    -- The `under_cursor` option is disabled when this cutoff is hit
    large_file_cutoff = 20000,
    -- min_count_to_highlight: minimum number of matches required to perform highlighting
    min_count_to_highlight = 1,
    -- should_enable: a callback that overrides all other settings to
    -- enable/disable illumination. This will be called a lot so don't do
    -- anything expensive in it.
    should_enable = function(bufnr) return true end,
    -- case_insensitive_regex: sets regex case sensitivity
    case_insensitive_regex = false
})
vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bold = true, underline = true })
vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bold = true, underline = true })
vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bold = true, underline = true })

-- Highlight hex color codes (e.g. #0072B2) with the actual color
require('colorizer').setup({
    'css',
    'javascript',
    'html',
    'lua',
})
