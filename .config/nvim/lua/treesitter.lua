-- Pin Python to the ABI 14 revision. v0.25.0 (ABI 15) declares 'string' as a
-- supertype, which Neovim 0.12's query validator rejects in the highlight queries.
require("nvim-treesitter.parsers").get_parser_configs().python.install_info.revision = "710796b8b877a970297106e5bbc8e2afa47f86ec"

-- nvim-treesitter master expects bare TSNodes in match tables, but Neovim 0.12
-- removed the {all=false} option and always returns TSNode[] arrays. Patch
-- iter_prepared_matches to unwrap arrays before the rest of the module sees them.
local _ts_query_mod = require("nvim-treesitter.query")
local _orig_iter_prepared = _ts_query_mod.iter_prepared_matches
_ts_query_mod.iter_prepared_matches = function(query, qnode, bufnr, start_row, end_row)
    local _wrapped = setmetatable({}, { __index = query })
    _wrapped.iter_matches = function(_, node, source, start, stop, opts)
        local iter = query:iter_matches(node, source, start, stop, opts)
        return function()
            local pattern, match, metadata = iter()
            if pattern == nil then return nil end
            local unwrapped = {}
            for id, nodes in pairs(match) do
                unwrapped[id] = type(nodes) == "table" and nodes[1] or nodes
            end
            return pattern, unwrapped, metadata
        end
    end
    return _orig_iter_prepared(_wrapped, qnode, bufnr, start_row, end_row)
end

-- Same issue in the set-lang-from-info-string! directive callback.
local _lang_aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
local function _unwrap(node)
    if type(node) == "table" and not node.range then node = node[1] end
    return node
end

vim.treesitter.query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local node = _unwrap(match[pred[2]])
    if not node then return end
    local alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias })
        or _lang_aliases[alias] or alias
end, { force = true })

-- Same TSNode[] unwrap for downcase! (bash heredoc injections) and set-lang-from-mimetype! (html).
vim.treesitter.query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = _unwrap(match[id])
    if not node then return end
    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    if not metadata[id] then metadata[id] = {} end
    metadata[id].text = string.lower(text)
end, { force = true })

local _html_script_type_languages = {
    ["importmap"] = "json",
    ["module"] = "javascript",
    ["application/ecmascript"] = "javascript",
    ["text/ecmascript"] = "javascript",
}
vim.treesitter.query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local node = _unwrap(match[pred[2]])
    if not node then return end
    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = _html_script_type_languages[type_attr_value]
    if configured then
        metadata["injection.language"] = configured
    else
        local parts = vim.split(type_attr_value, "/", {})
        metadata["injection.language"] = parts[#parts]
    end
end, { force = true })

require("nvim-treesitter").setup()
local _to = require("nvim-treesitter-textobjects")
if type(_to.init) == "function" then _to.init() end
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "awk", "bash", "bibtex", "css", "diff", "dockerfile",
        "fish", "gitcommit", "git_config", "gitignore", "git_rebase",
        "gpg", "html", "javascript", "json", "json5",
        "make", "markdown", "markdown_inline", "passwd", "python", "r", "regex", "rust", "scss",
        "sql", "ssh_config", "toml", "tsv", "vim",
        "yaml",
    },
    highlight = { enable = true },
    textobjects = {
        select = {
            lookahead = true,
            selection_modes = {
                ['@parameter.outer'] = 'v',
                ['@function.outer'] = 'V',
                ['@class.outer'] = '<c-v>',
            },
        },
        move = { set_jumps = true },
    },
})

-- Module paths differ between linux and macOS apparently :eyeroll:
local function req_to(name)
    local ok, mod = pcall(require, "nvim-treesitter.textobjects." .. name)
    if ok then return mod end
    return require("nvim-treesitter-textobjects." .. name)
end
local select = req_to("select")
local move = req_to("move")
local swap = req_to("swap")

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

