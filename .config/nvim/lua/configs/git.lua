require("gitsigns").setup({
    signs = {
        add = { text = '█' }, -- │
        change = { text = '~' }, -- │
        delete = { text = '█' },
        topdelete = { text = '█' },
        changedelete = { text = '█' },
        untracked = { text = '┆' }
    },
    signcolumn = true,
    numhl = true,
    word_diff = false,
    linehl = false,
    watch_gitdir = { follow_files = true },
    auto_attach = true,
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = {
        hl_mode = 'combine',
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = true,
        virt_text_priority = 10
    },
    current_line_blame_formatter = '<author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,  -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
})
-- We show the git blame message for the current line. This sets the color of that virtual text.
vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = '#9B643D', italic = true })
