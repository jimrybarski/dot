-- Pin Python to the ABI 14 revision. v0.25.0 (ABI 15) declares 'string' as a
-- supertype, which Neovim 0.12's query validator rejects in the highlight queries.
require("nvim-treesitter.parsers").get_parser_configs().python.install_info.revision = "710796b8b877a970297106e5bbc8e2afa47f86ec"

-- nvim-treesitter master passes bare TSNodes in directive match tables, but Neovim
-- 0.12 changed match values to TSNode[] lists. Override the broken handler.
local _lang_aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = match[pred[2]]
    if not node then return end
    if type(node) == "table" and not node.range then node = node[1] end
    if not node then return end
    local alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias })
        or _lang_aliases[alias] or alias
end, { force = true })

require("nvim-treesitter").setup({
    ensure_installed = {
        "awk", "bash", "bibtex", "css", "diff", "dockerfile",
        "fish", "gitcommit", "git_config", "gitignore", "git_rebase",
        "gpg", "html", "javascript", "json", "json5",
        "make", "passwd", "python", "r", "regex", "rust", "scss",
        "sql", "ssh_config", "toml", "tsv", "vim",
        "yaml",
    },
    highlight = { enable = true },
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

