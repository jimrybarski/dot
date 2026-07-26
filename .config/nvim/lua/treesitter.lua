-- nvim-treesitter's main branch only installs parsers and queries -- it no longer
-- enables anything. Highlighting, folds and indentation are Neovim features now,
-- and turning them on is this file's job (see the FileType autocmd below).
local ts = require("nvim-treesitter")

-- Installs are asynchronous and a no-op once a parser is present, so calling this
-- on every startup costs nothing. `:TSUpdate` (the lazy.nvim build step) is what
-- moves them forward when the pinned revisions change.
ts.install({
    "awk", "bash", "bibtex", "css", "diff", "dockerfile",
    "fish", "gitcommit", "git_config", "gitignore", "git_rebase",
    "gpg", "html", "javascript", "json", "json5",
    "make", "markdown", "markdown_inline", "passwd", "python", "r", "regex", "rust", "scss",
    "sql", "ssh_config", "toml", "tsv", "vim",
    "yaml",
})

-- Highlighting, for any filetype we happen to have a parser for. Matching on `*`
-- rather than a filetype list keeps this in sync with the install list above by
-- construction, and covers the languages whose parser name isn't a filetype at
-- all (markdown_inline, and the git_* family).
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if lang and vim.treesitter.language.add(lang) then
            pcall(vim.treesitter.start, args.buf, lang)
        end
    end
})

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
        selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = '<c-v>',
        },
    },
    move = { set_jumps = true },
})

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

local select_maps = {
    ["af"] = "@function.outer", ["if"] = "@function.inner",
    ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
    ["ap"] = "@parameter.outer",["ip"] = "@parameter.inner",
    ["al"] = "@loop.outer",     ["il"] = "@loop.inner",
    ["a/"] = "@comment.outer",  ["i/"] = "@comment.outer",
}
for key, query in pairs(select_maps) do
    vim.keymap.set({ "x", "o" }, key, function() select.select_textobject(query) end)
end

local next_start_maps = {
    ["]f"] = "@function.outer", ["]c"] = "@class.outer",
    ["]p"] = "@parameter.outer",["]l"] = "@loop.outer",
    ["]/"] = "@comment.outer",
}
local prev_start_maps = {
    ["[f"] = "@function.outer", ["[c"] = "@class.outer",
    ["[p"] = "@parameter.outer",["[l"] = "@loop.outer",
    ["[/"] = "@comment.outer",
}
for key, query in pairs(next_start_maps) do
    vim.keymap.set({ "n", "x", "o" }, key, function() move.goto_next_start(query) end)
end
for key, query in pairs(prev_start_maps) do
    vim.keymap.set({ "n", "x", "o" }, key, function() move.goto_previous_start(query) end)
end

vim.keymap.set("n", "gp", function() swap.swap_next("@parameter.inner") end)
vim.keymap.set("n", "gP", function() swap.swap_previous("@parameter.inner") end)
