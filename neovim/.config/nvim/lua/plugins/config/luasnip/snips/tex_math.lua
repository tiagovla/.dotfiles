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

local function add_snippets_in_math_zone(lang, snips, opts)
    for _, v in pairs(snips) do
        v.condition = in_mathzone
    end
    ls.add_snippets(lang, snips, opts)
end

local auto_snippets = {
    s("mk", { t { "$" }, i(1), t { "$ " }, i(0) }),
    s({ trig = "([^%s]*[^%)])//", regTrig = true }, {
        d(1, function(_, snip)
            local selected = snip.env.TM_SELECTED_TEXT[1]
            if selected then
                return sn(nil, { t "\\frac{", t(selected), t "}{", i(1), t "}" })
            end
            P(snip.captures[1])
            if snip.captures[1] == " " then
                return sn(nil, { t "\\frac{", i(1), t "}{", i(2), t "}" })
            end
            return sn(nil, { t "\\frac{", t(snip.captures[1]), t "}{", i(1), t "}" })
        end),
        i(0),
    }),
    s({ trig = "(.*%))//", regTrig = true }, {
        d(1, function(_, snip)
            local capture = snip.captures[1]
            local level = 0
            local pos = #capture
            while pos > 1 do
                local char = capture:sub(pos, pos)
                if char == ")" then
                    level = level + 1
                elseif char == "(" then
                    level = level - 1
                end
                if level == 0 then
                    break
                end
                pos = pos - 1
            end
            return sn(nil, {
                t(capture:sub(1, pos - 1)),
                t "\\frac{",
                t(capture:sub(pos + 1, #capture - 1)),
                t "}{",
                i(1),
                t "}",
                i(0),
            })
        end),
    }),
    s("!=", { t "\neq ", i(0) }),
    s("==", { t "&= ", i(0) }),
    s("ooo", { t "\\infty{", i(0) }),
    s(">=", { t "\\ge", i(0) }),
    s("<=", { t "\\le", i(0) }),
    s("mcal", { t "\\mathcal{", i(1), t "} ", i(0) }),
    s("msrc", { t "\\mathsrc{", i(1), t "} ", i(0) }),
    s("lll", { t "\\ell", i(0) }),
    s("nabl", { t "\\nabla", i(0) }),
    s("xx", { t "\\times", i(0) }),
    s("cdot", { t "\\cdot", i(0) }),
    s("<->", { t "\\leftrightarrow", i(0) }),
    s("dint", { t "\\int_{", i(1), t "}^{", i(2), t "} ", i(0) }),
    s("->", { t "\\to", i(0) }),
    s("!>", { t "\\mapsto", i(0) }),
    s("compl", { t "^{C} ", i(0) }),
    s("\\\\\\", { t "\\setminus ", i(0) }),
    s("set", { t "\\{", i(1), t "\\}  ", i(0) }),
    s("cc", { t "\\subset", i(0) }),
    s("notin", { t "\\not\\in ", i(0) }),
    s("inn", { t "\\in ", i(0) }),
    s("UU", { t "\\cup ", i(0) }),
    s("Nn", { t "\\cap ", i(0) }),
    s("NN", { t "\\N ", i(0) }),
    -- s("//", { t "\\frac{", i(1), t "}{", i(2), t "}" }),
    s("=>", t "\\implies"),
    s({ trig = "transp", wordTrig = false }, { t "^{\\intercal}", i(0) }),
    s({ trig = "inv", wordTrig = false }, { t "^{-1}", i(0) }),
    s({ trig = "__", wordTrig = false }, { t "_{", i(1), t "}", i(0) }),
    s({ trig = ">>", wordTrig = false }, { t "\\gg  ", i(0) }),
    s({ trig = "<<", wordTrig = false }, { t "\\ll  ", i(0) }),
    s({ trig = "..." }, {
        t "\\ldots",
    }),
}

for _, v in pairs { "bar", "hat", "vec", "tilde" } do
    auto_snippets[#auto_snippets + 1] = s(
        { trig = ("\\?%s"):format(v), regTrig = true },
        { t(("\\%s{"):format(v)), i(1), t "}", i(0) }
    )
    auto_snippets[#auto_snippets + 1] = s({ trig = "([^%s]*)" .. v, regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t(("\\%s{%s}"):format(v, snip.captures[1])) }, i(0))
        end),
    })
end

add_snippets_in_math_zone("tex", auto_snippets, { type = "autosnippets" })

local snippets = {
    s("||", { t "\\mid ", i(0) }),
    s("ceil", { t "\\left\\lceil", i(1), t "\\right\\rceil", i(0) }),
    s("bmat", { t "\\begin{bmatrix} ", i(1), t "\\end{bmatrix} ", i(0) }),
    s("pmat", { t "\\begin{pmatrix} ", i(1), t "\\end{pmatrix} ", i(0) }),
    s("partial", { t { "\\frac{\\partial " }, i(1), t { "}{\\partial " }, i(2), t { "}" }, i(0) }),
    s("integral", { t "\\int_{", i(1), t "}^{", i(2), t "} ", i(0) }),
}

add_snippets_in_math_zone("tex", snippets, {})

local container_snippets = {
    s({ trig = "()", name = "Parenthesis" }, { t "\\left(", i(1), t "\\right)", i(0) }),
    s({ trig = "[]", name = "Brackets" }, { t "\\left[", i(1), t "\\right]", i(0) }),
    s({ trig = "[]", name = "Curly Brackets" }, { t "\\left{", i(1), t "\\right}", i(0) }),
    s({ trig = "(", name = "Left Parenthesis" }, { t "\\left(", i(0) }),
    s({ trig = ")", name = "Right Parenthesis" }, { t "\\right)", i(0) }),
    s({ trig = "[", name = "Left Bracket" }, { t "\\left[", i(0) }),
    s({ trig = "]", name = "Right Bracket" }, { t "\\right]", i(0) }),
    s({ trig = "{", name = "Left Curly Bracket" }, { t "\\left{", i(0) }),
    s({ trig = "}", name = "Right Curly Bracket" }, { t "\\right}", i(0) }),
}

add_snippets_in_math_zone("tex", container_snippets, {})
