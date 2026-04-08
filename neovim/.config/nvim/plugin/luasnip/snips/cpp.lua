local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("cpp", {
    s(
        "template",
        fmt(
            [[
                #include <iostream>

                int main() {{
                    {}
                    return 0;
                }}
            ]],
            { i(0) }
        )
    ),
})

ls.add_snippets("cpp", {}, {})
