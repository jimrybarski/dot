require("telescope").setup({
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim"
        },
        layout_config = { vertical = { width = 0.9, height = 0.9 } },
        file_ignore_patterns = { ".git" },
        hidden = true,
    },
    pickers = {
        find_files = {
            find_command = { 'fd', '--type', 'f', '--follow', '--hidden', '--exclude', '.git' }
        },
        lsp_references = {
            -- by default, telescope lets you type to filter the list of results further.
            -- however, for the list of references, I only ever want to scroll up and down with j and k
            -- here, we force it to start in normal mode
            initial_mode = "normal",
        },
    },
})
