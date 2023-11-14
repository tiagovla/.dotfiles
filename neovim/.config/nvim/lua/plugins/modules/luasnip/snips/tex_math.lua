local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node

local function opt(v)
    return { trig = ("\\?%s"):format(v), regTrig = true }
end

local function in_mathzone()
    local math_nodes = {
        "displayed_equation",
        "inline_formula",
        "math_environment",
    }
    local text_commands = {
        "textrm",
    }
    local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
    while node do
        if vim.tbl_contains(math_nodes, node:type()) then
            return true
        end
        if node:type() == "generic_command" then
            local command = vim.treesitter.query.get_node_text(node, 0):match "^\\(%w+)"
            if vim.tbl_contains(text_commands, command) then
                return false
            end
        end
        node = node:parent()
    end
    return false
end

local sm = ls.extend_decorator.apply(ls.snippet, { condition = in_mathzone })

local auto_snippets = {
    sm({ trig = "([^%s]*[^%)])//", regTrig = true }, {
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
    sm({ trig = "(.*%))//", regTrig = true }, {
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
    sm("!=", { t "\neq ", i(0) }),
    sm("==", { t "&= ", i(0) }),
    sm("ooo", { t "\\infty{", i(0) }),
    sm(">=", { t "\\ge", i(0) }),
    sm("<=", { t "\\le", i(0) }),
    sm(opt "mathcal", { t "\\mathcal{", i(1), t "} ", i(0) }),
    sm(opt "mathsrc", { t "\\mathscr{", i(1), t "} ", i(0) }),
    sm(opt "mathscr", { t "\\mathscr{", i(1), t "} ", i(0) }),
    sm(opt "bm", { t "\\bm{", i(1), t "} ", i(0) }),
    sm("lll", { t "\\ell", i(0) }),
    sm("xx", { t "\\times ", i(0) }),
    sm(opt "nabla", { t "\\nabla", i(0) }),
    sm(opt "cdot", { t "\\cdot", i(0) }),
    sm("<->", { t "\\leftrightarrow", i(0) }),
    sm(opt "int", { t "\\int_{", i(1), t "}^{", i(2), t "} ", i(0) }),
    sm(opt "iint", { t "\\iint_{", i(1), t "}^{", i(2), t "} ", i(0) }),
    sm(opt "iiint", { t "\\iiint_{", i(1), t "}^{", i(2), t "} ", i(0) }),
    sm(opt "iiiint", { t "\\iiiint_{", i(1), t "}^{", i(2), t "} ", i(0) }),
    sm(opt "oint", { t "\\oint_{", i(1), t "}^{", i(2), t "} ", i(0) }),
    sm(opt "oiint", { t "\\oiint_{", i(1), t "}^{", i(2), t "} ", i(0) }),
    sm(opt "oiiint", { t "\\oiiint_{", i(1), t "}^{", i(2), t "} ", i(0) }),
    sm("->", { t "\\to ", i(0) }),
    sm("!>", { t "\\mapsto", i(0) }),
    sm("compl", { t "^{C} ", i(0) }),
    sm("\\\\\\", { t "\\setminus ", i(0) }),
    sm("set", { t "\\{", i(1), t "\\}  ", i(0) }),
    sm("cc", { t "\\subset", i(0) }),
    sm("notin", { t "\\not\\in ", i(0) }),
    sm("inn", { t "\\in ", i(0) }),
    sm("UU", { t "\\cup ", i(0) }),
    sm("Nn", { t "\\cap ", i(0) }),
    sm("NN", { t "\\N ", i(0) }),
    -- s("//", { t "\\frac{", i(1), t "}{", i(2), t "}" }),
    sm("=>", t "\\implies"),
    sm({ trig = "transp", wordTrig = false }, { t "^{\\intercal}", i(0) }),
    sm({ trig = "inv", wordTrig = false }, { t "^{-1}", i(0) }),
    sm({ trig = "__", wordTrig = false }, { t "_{", i(1), t "}", i(0) }),
    sm({ trig = "^^", wordTrig = false }, { t "^{", i(1), t "}", i(0) }),
    sm({ trig = ">>", wordTrig = false }, { t "\\gg  ", i(0) }),
    sm({ trig = "<<", wordTrig = false }, { t "\\ll  ", i(0) }),
    sm({ trig = "..." }, { t "\\ldots" }),
}

for _, v in pairs { "bar", "hat", "vec", "tilde", "tdv", "fdv" } do
    auto_snippets[#auto_snippets + 1] = s(opt(v), { t(("\\%s{"):format(v)), i(1), t "}", i(0) })
    auto_snippets[#auto_snippets + 1] = s({ trig = "([^%s]*)" .. v, regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t(("\\%s{%s}"):format(v, snip.captures[1])) }, i(0))
        end),
    })
end

local greek_letters = { "eta", "omega", "sigma", "alpha", "beta", "gamma", "mu", "epsilon", "pi" }
for _, v in pairs(greek_letters) do
    auto_snippets[#auto_snippets + 1] = s(opt(v), { t(("\\%s"):format(v)), i(0) })
end

local snippets = {
    sm("||", { t "\\mid ", i(0) }),
    sm("ceil", { t "\\left\\lceil", i(1), t "\\right\\rceil", i(0) }),
    sm("bmat", { t "\\begin{bmatrix} ", i(1), t "\\end{bmatrix} ", i(0) }),
    sm("pmat", { t "\\begin{pmatrix} ", i(1), t "\\end{pmatrix} ", i(0) }),
    sm("partial", { t { "\\frac{\\partial " }, i(1), t { "}{\\partial " }, i(2), t { "}" }, i(0) }),
    sm("integral", { t "\\int_{", i(1), t "}^{", i(2), t "} ", i(0) }),
    sm("text", { t "\\text{", i(1), t "}", i(0) }),
    sm({ trig = "()", name = "Parenthesis" }, { t "\\left(", i(1), t "\\right)", i(0) }),
    sm({ trig = "[]", name = "Brackets" }, { t "\\left[", i(1), t "\\right]", i(0) }),
    sm({ trig = "[]", name = "Curly Brackets" }, { t "\\left{", i(1), t "\\right}", i(0) }),
    sm({ trig = "(", name = "Left Parenthesis" }, { t "\\left(", i(0) }),
    sm({ trig = ")", name = "Right Parenthesis" }, { t "\\right)", i(0) }),
    sm({ trig = "[", name = "Left Bracket" }, { t "\\left[", i(0) }),
    sm({ trig = "]", name = "Right Bracket" }, { t "\\right]", i(0) }),
    sm({ trig = "{", name = "Left Curly Bracket" }, { t "\\left{", i(0) }),
    sm({ trig = "}", name = "Right Curly Bracket" }, { t "\\right}", i(0) }),
}

ls.add_snippets("tex", auto_snippets, { type = "autosnippets" })
ls.add_snippets("tex", snippets, {})
