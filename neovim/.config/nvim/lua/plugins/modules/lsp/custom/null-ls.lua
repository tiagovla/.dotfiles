local h = require "null-ls.helpers"
local methods = require "null-ls.methods"

local FORMATTING = methods.internal.FORMATTING

local custom = { format = {} }
--
custom.format["tex-fmt"] = h.make_builtin {
    name = "tex-fmt",
    method = { FORMATTING },
    filetypes = { "tex" },
    generator_opts = {
        command = "tex-fmt",
        args = { "--stdin", "--tabsize", "4" },
        to_stdin = true,
    },
    factory = h.formatter_factory,
}

return custom
