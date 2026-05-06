local previewers_utils = require("telescope.previewers.utils")
previewers_utils.ts_highlighter = function(bufnr, ft)
    local lang = vim.treesitter.language.get_lang(ft)
    if lang and vim.treesitter.language.add(lang) then
        local ok = pcall(vim.treesitter.start, bufnr, lang)
        if ok then return true end
    end
    -- fallback to vim regex syntax
    if ft and ft ~= "" then
        vim.bo[bufnr].syntax = ft
    end
    return false
end

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
        layout_config = {
            horizontal = { preview_width = 0.65 },
            vertical = { width = 0.9, height = 0.9 },
        },
        file_ignore_patterns = { ".git" },
        hidden = true,
        preview = {
            treesitter = true,
        },
    },
    pickers = {
        find_files = {
            find_command = { 'fd', '--type', 'f', '--follow', '--hidden', '--exclude', '.git' }
        },
        live_grep = {
            entry_maker = function(line)
                local entry = require("telescope.make_entry").gen_from_vimgrep()(line)
                if not entry then return nil end
                entry.display = function(e)
                    local filename = vim.fn.fnamemodify(e.filename, ":.")
                    return filename, { { { 0, #filename }, "TelescopeResultsFile" } }
                end
                return entry
            end,
        },
        lsp_references = {
            -- by default, telescope lets you type to filter the list of results further.
            -- however, for the list of references, I only ever want to scroll up and down with j and k
            -- here, we force it to start in normal mode
            initial_mode = "normal",
        },
    },
})

