local ls = require "luasnip"

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
    s("importmatplotlib", {
        t { "from matplotlib import pyplot as plt", "" },
        i(0),
    }),
    s("importnumpy", {
        t { "import numpy as np", "" },
        i(0),
    }),
    s("defmain", {
        t { "def main():", "\t" },
        i(0, "..."),
        t { "", "", "" },
        t { 'if __name__ == "__main__":' },
        t { "", "\tmain()" },
        i(0),
    }),
    s("if__name__", {
        t { 'if __name__ == "__main__":', "\t" },
        i(0),
    }),
})
