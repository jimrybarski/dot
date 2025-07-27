-- configure linters and formatters
local null_ls = require("null-ls")
null_ls.setup({
    diagnostics_format = "#{m} [#{c}] (#{s})",
    sources = {
        null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.formatting.isort,
    }
})
