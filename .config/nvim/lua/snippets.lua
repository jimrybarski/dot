local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
    s("ifm", { t({ 'if __name__ == "__main__":', "    " }), i(1) }),
    s("dc", {
        t({ "@dataclass", "class " }), i(1, "Name"), t({ ":", "    " }), i(2),
    }),
})
