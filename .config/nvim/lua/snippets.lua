local ls = require("luasnip")
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local k = require("luasnip.nodes.key_indexer").new_key
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local ms = ls.multi_snippet

local date = function() return os.date("%Y-%m-%d") end

local bash_shebang = s("#b", {t({"#!/usr/bin/env bash", "", "set -euo pipefail", "", ""})})
local zsh_shebang = s("#z", {t({"#!/usr/bin/env zsh", "", "set -euo pipefail", "", ""})})
local fish_shebang = s("#f", {t({"#!/usr/bin/env fish", "", "set -euo pipefail", "", ""})})
local current_date = s("d", {f(date, {})})

ls.add_snippets("all", {
    bash_shebang,    
    zsh_shebang,
    fish_shebang,
    current_date 
})


local pydef_no_return = s("defn", {
        t("def "),
        i(1, "FUNCTION-NAME"),
        t("("), i(2, "PARAMETERS"),
        t({":", ""}),
        t('    """'), i(3, "COMMENT"), t({'"""', "    "}),
        i(4, "FUNCTION-BODY")
    })

local pydef_return = s("def", {
        t("def "),
        i(1, "FUNCTION-NAME"),
        t("("), i(2, "PARAMETERS"), t(") -> "),
        i(3, "RETURN-TYPE"),
        t({":", ""}),
        t('    """'), i(4, "COMMENT"), t({'"""', "    "}),
        i(5, "FUNCTION-BODY")
    })

ls.add_snippets("python", {
    pydef_no_return,
    pydef_return,
    s("mpl", {t("import matplotlib.pyplot as plt")}),
    s("fig", {t("fig, ax = plt.subplots()")}),
    s("figs", {
        t("fig, ax = plt.subplots(figsize=("),
        i(1, "height"),
        t(", "),
        i(2, "width"),
        t("))")
    }),
    s("ifm", {
        t("if __name__ == '__main__':"),
        t({"", "    "}),
        i(1, "pass"), i(0)
    }),
    s("fim", {
        t("from "),
        i(1, "package"),
        t(" import "),
        i(2, "module"),
        i(0)
    })
})
