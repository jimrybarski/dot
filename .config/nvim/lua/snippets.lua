local luasnip = require("luasnip")

-- MY CUSTOM SNIPPETS
local date = function() return os.date("%Y-%m-%d") end
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node

luasnip.add_snippets("all", {
    s("#b", {t("#!/usr/bin/env bash")}), s("#z", {t("#!/usr/bin/env zsh")}),
    s("#f", {t("#!/usr/bin/env fish")}), s("d", {f(date, {})})
})

luasnip.add_snippets("python", {
    s("mpl", {t("import matplotlib.pyplot as plt")}),
    s("fig", {t("fig, ax = plt.subplots()")}), s("figs", {
        t("fig, ax = plt.subplots(figsize=("), i(1, "height"), t(", "),
        i(2, "width"), t("))")
    }), s("def", {
        t("def "), i(1, "fname"), t("("), i(2, "arg"), t(") -> "),
        i(3, "returns"), t(":\n\t"), i(4, "pass"), i(0)
    }), s("ifmain", {
        t("if __name__ == '__main__':"), t({"", "\t"}), -- Splitting the newline and indentation into a new text node
        i(1, "pass"), i(0)
    }),
    s("fim", {t("from "), i(1, "package"), t(" import "), i(2, "module"), i(0)})
})


