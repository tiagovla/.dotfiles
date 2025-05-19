-- local call = vim.api.nvim_call_function
vim.keymap.set("n", "gqq", "mzgqip`z", {})
-- defer 1s and call the command below
vim.defer_fn(function()
    vim.cmd "syntax on"
end, 500)

-- call("TexNewMathZone", { "E", "align", 1 })
-- call("TexNewMathZone", { "F", "alignat", 1 })
-- call("TexNewMathZone", { "G", "equation", 1 })
-- call("TexNewMathZone", { "H", "flalign", 1 })
-- call("TexNewMathZone", { "I", "gather", 1 })
-- call("TexNewMathZone", { "J", "multline", 1 })
-- call("TexNewMathZone", { "K", "xalignat", 1 })
-- call("TexNewMathZone", { "L", "dmath", 0 })
