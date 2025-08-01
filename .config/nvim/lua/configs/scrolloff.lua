require('scrollEOF').setup({
    -- The pattern used for the internal autocmd to determine
    -- where to run scrollEOF. See https://neovim.io/doc/user/autocmd.html#autocmd-pattern
    pattern = '*',
    -- Whether or not scrollEOF should be enabled in insert mode
    insert_mode = true,
    -- List of filetypes to disable scrollEOF for.
    disabled_filetypes = {},
    -- List of modes to disable scrollEOF for. see https://neovim.io/doc/user/builtin.html#mode()
    disabled_modes = {},
})
