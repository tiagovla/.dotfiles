local function define_signs(signs)
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = nil, texthl = nil, numhl = hl })
        -- without icon, but with number highlight
    end
end

define_signs { Error = "", Warn = "", Hint = "", Info = "" }

vim.diagnostic.config {
    virtual_text = {
        prefix = "",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
}
