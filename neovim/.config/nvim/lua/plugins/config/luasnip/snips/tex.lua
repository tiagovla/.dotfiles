local ls = require "luasnip"
local parse = ls.parser.parse_snippet
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local rep = require("luasnip.extras").rep
local events = require "luasnip.util.events"

ls.add_snippets("tex", {
    s({ trig = "math" }, { i(1), t " ", i(0) }, {
        callbacks = {
            [1] = {
                [events.leave] = function(node)
                    local from_pos, to_pos = node.mark:pos_begin_end_raw()
                    P(from_pos)
                    P(to_pos)
                    local lines = vim.api.nvim_buf_get_lines(0, from_pos[1], to_pos[1] + 1, false)
                    local script = ([[!wolframscript -c "ToString@TeXForm[%s]"]]):format(node:get_text()[1])
                    local output = vim.split(vim.api.nvim_exec(script, true), "\n")
                    output = output[#output - 1]
                    if #lines == 1 then
                        vim.api.nvim_buf_set_text(0, from_pos[1], from_pos[2], to_pos[1], to_pos[2], { output })
                    end
                end,
            },
        },
    }),
}, {})

local tex_template = [[
\documentclass[a4paper,12pt]{article}
\usepackage[a4paper, margin=1in, total={20cm,27cm}]{geometry}
\usepackage{import}
\usepackage{pdfpages}
\usepackage{transparent}
\usepackage{xcolor}
\usepackage{textcomp}
\usepackage{amsmath, amssymb}
\usepackage{graphicx}
\usepackage{tikz}
\usepackage{wrapfig}
\title{$1}
\author{$2}
\begin{document}
\maketitle
\tableofcontents
$0
\addcontentsline{toc}{section}{Unnumbered Section}
\end{document}]]

local tex_table = [[
\begin{center}
  \begin{tabular}{ c c c }
    cell1 & cell2 & cell3 \\\\
    \\hline
    cell4 & cell5 & cell6 \\\\
    \\hline
    cell7 & cell8 & cell9
  \end{tabular}
\end{center}]]

ls.add_snippets("tex", {
    parse({ trig = "template" }, tex_template),
    parse({ trig = "table" }, tex_table),
    s({ trig = "frame" }, {
        t { "\\begin{frame}", "\t" },
        i(1),
        t { "", "\\end{frame}", "" },
        i(0),
    }),
    s({ trig = "begin" }, {
        t "\\begin{",
        i(1),
        t { "}", "\t" },
        i(2),
        t { "", "\\end{" },
        rep(1),
        t { "}", "" },
        i(0),
    }),
    s({ trig = "section" }, {
        t "\\section{",
        i(1),
        t "}",
        d(2, function(args)
            local text
            if args[1] == "" then
                text = "section"
            else
                text = args[1][1]:gsub(" ", "_"):lower()
            end
            return sn(nil, { t "\\label{sec:", i(1, text), t "}", t { "", "" }, i(0) })
        end, { 1 }),
    }),
    s({ trig = "chapter" }, {
        t "\\chapter{",
        i(1),
        t "}",
        d(2, function(args)
            local text
            if args[1] == "" then
                text = "section"
            else
                text = args[1][1]:gsub(" ", "_"):lower()
            end
            return sn(nil, { t "\\label{chap:", i(1, text), t "}", t { "", "" }, i(0) })
        end, { 1 }),
    }),
    s({ trig = "subsection" }, {
        t "\\subsection{",
        i(1),
        t "}",
        d(2, function(args)
            local text
            if args[1] == "" then
                text = "section"
            else
                text = args[1][1]:gsub(" ", "_"):lower()
            end
            return sn(nil, { t "\\label{subsec:", i(1, text), t "}", t { "", "" }, i(0) })
        end, { 1 }),
    }),
    s("rm", { t "\\textrm{", i(1), t "}", i(0) }),
    s("bold", { t "\\textbf{", i(1), t "}", i(0) }),
    s("italic", { t "\\textit{", i(1), t "}", i(0) }),
    s("smallcaps", { t "\\textsc{", i(1), t "}", i(0) }),
    s("reals", { t "\\mathbb{R}", i(0) }),
}, {})
