local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require "luasnip.util.types"
local conds = require "luasnip.extras.expand_conditions"

vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/plugins/config/luasnip/snips/lua.lua<cr>")

local in_mathzone = function()
    local has_treesitter, ts = pcall(require, "vim.treesitter")
    local _, query = pcall(require, "vim.treesitter.query")

    local MATH_ENVIRONMENTS = {
        displaymath = true,
        eqnarray = true,
        equation = true,
        math = true,
        array = true,
    }
    local MATH_NODES = {
        displayed_equation = true,
        inline_formula = true,
        math_environment = true,
    }

    local function get_node_at_cursor()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local cursor_range = { cursor[1] - 1, cursor[2] }
        local buf = vim.api.nvim_get_current_buf()
        local ok, parser = pcall(ts.get_parser, buf, "latex")
        if not ok or not parser then
            return
        end
        local root_tree = parser:parse()[1]
        local root = root_tree and root_tree:root()

        if not root then
            return
        end

        return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
    end

    if has_treesitter then
        local buf = vim.api.nvim_get_current_buf()
        local node = get_node_at_cursor()
        while node do
            print(node:type())
            if MATH_NODES[node:type()] then
                return true
            end
            if node:type() == "environment" then
                local begin = node:child(0)
                local names = begin and begin:field "name"

                if names and names[1] and MATH_ENVIRONMENTS[query.get_node_text(names[1], buf):gsub("[%s*]", "")] then
                    return true
                end
            end
            node = node:parent()
        end
        return false
    end
end
snippet == "equals" iA
&= $1 \\\\
endsnippet

snippet != "equals" iA
\neq 
endsnippet

context "math()"
snippet ceil "ceil" iA
\left\lceil $1 \right\rceil $0
endsnippet



    s("ceil", { t "\\left\lceil", i(1), t "\\right\rceil", i(0) }, { condition = in_mathzone }),
ls.add_snippets("tex", {
    s("bmat", { t "\\begin{bmatrix} ", i(1), t "\\end{bmatrix} ", i(0) }, { condition = in_mathzone }),
    s("pmat", { t "\\begin{pmatrix} ", i(1), t "\\end{pmatrix} ", i(0) }, { condition = in_mathzone }),
    s("__", { t "_{", i(1), t "}", i(0) }, { condition = in_mathzone }),
    s("ooo", { t "\\infty{", i(0) }, { condition = in_mathzone }),
    s(">=", { t "\\ge{", i(0) }, { condition = in_mathzone }),
    s("<=", { t "\\le{", i(0) }, { condition = in_mathzone }),
    s("mcal", { t "\\mathcal{", i(1), t "} ", i(0) }, { condition = in_mathzone }),
    s("lll", { t "\\ell", i(0) }, { condition = in_mathzone }),
    s("nabl", { t "\\nabla", i(0) }, { condition = in_mathzone }),
    s("xx", { t "\\times", i(0) }, { condition = in_mathzone }),
    s("**", { t "\\cdot", i(0) }, { condition = in_mathzone }),
    s("<->", { t "\\leftrightarrow", i(0) }, { condition = in_mathzone }),
    s("dint", { t "\\int_{", i(1), t "}^{", i(2), t "} ", i(0) }, { condition = in_mathzone }),
    s("->", { t "\\to", i(0) }, { condition = in_mathzone }),
    s("!>", { t "\\mapsto", i(0) }, { condition = in_mathzone }),
    s("inv", { t "^{-1} ", i(0) }, { condition = in_mathzone }),
    s("compl", { t "^{C} ", i(0) }, { condition = in_mathzone }),
    s("\\\\\\", { t "\\setminus ", i(0) }, { condition = in_mathzone }),
    s(">>", { t "\\gg  ", i(0) }, { condition = in_mathzone }),
    s("<<", { t "\\ll  ", i(0) }, { condition = in_mathzone }),
    s("set", { t "\\{", i(1), t "\\}  ", i(0) }, { condition = in_mathzone }),
    s("||", { t "\\mid ", i(0) }, { condition = in_mathzone }),
    s("cc", { t "\\subset", i(0) }, { condition = in_mathzone }),
    s("notin", { t "\\not\\in ", i(0) }, { condition = in_mathzone }),
    s("inn", { t "\\in ", i(0) }, { condition = in_mathzone }),
    s("UU", { t "\\cup ", i(0) }, { condition = in_mathzone }),
    s("Nn", { t "\\cap ", i(0) }, { condition = in_mathzone }),
    s("NN", { t "\\N ", i(0) }, { condition = in_mathzone }),
    s("//", { t "\\frac{", i(1), t "}{", i(2), t "}" }, { condition = in_mathzone }),
    s("comp", t "^{t}", { condition = in_mathzone }),
    s("=>", t "\\implies", { condition = in_mathzone }),
    s(
        "partial",
        { t { "\\frac{\\partial " }, i(1), t { "}{\\partial " }, i(2), t { "}" }, i(0) },
        { condition = in_mathzone }
    ),
    s({ trig = "(%d+)/", regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t("\\frac{" .. snip.captures[1] .. "}{"), i(1), t "}" }, i(0))
        end),
    }, {
        condition = in_mathzone,
    }),
    s({ trig = "..." }, {
        t "\\ldots",
    }, {
        condition = in_mathzone,
    }),
    s({ trig = "(%a)bar", regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t("\\bar{" .. snip.captures[1] .. "}") }, i(0))
        end),
    }, {
        condition = in_mathzone,
    }),
    s({ trig = "bar" }, { t "\\bar{", i(1), t "}", i(0) }, {
        condition = in_mathzone,
    }),
    s({ trig = "(%u%u)vec", regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t("\\vec{" .. snip.captures[1] .. "}") }, i(0))
        end),
    }, {
        condition = in_mathzone,
    }),
    s({ trig = "(%a)vec", regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t("\\vec{" .. snip.captures[1] .. "}") }, i(0))
        end),
    }, {
        condition = in_mathzone,
    }),
    s({ trig = "vec" }, { t "\\vec{", i(1), t "}", i(0) }, {
        condition = in_mathzone,
    }),
    s({ trig = "(%a)hat", regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t("\\hat{" .. snip.captures[1] .. "}") }, i(0))
        end),
    }, {
        condition = in_mathzone,
    }),
    s({ trig = "hat" }, { t "\\hat{", i(1), t "}", i(0) }, {
        condition = in_mathzone,
    }),
}, {
    type = "autosnippets",
})
