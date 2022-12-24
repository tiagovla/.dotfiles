local mappings = {}

vim.api.nvim_create_user_command("FormattingToggle", function()
    if vim.g.format_on_save then
        vim.g.format_on_save = false
        vim.notify "Formatting on save disabled"
    else
        vim.g.format_on_save = true
        vim.notify(print "Formatting on save enabled")
    end
end, {})

mappings.texlab = function()
    vim.keymap.set("n", "<leader>lb", "<cmd>TexlabBuild<CR>", { buffer = 0, desc = "Build document" })
    vim.keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", { buffer = 0, desc = "Forward view" })
end

mappings.clangd = function()
    keymap.set("n", "<leader><Tab>", "<cmd>ClangdSwitchSourceHeader<CR>", { buffer = 0, desc = "Build document" })
end

function mappings.setup(client_name, buffer)
    -- keymap.set("n", "gh", require("lsp-inlayhints").toggle, { buffer = buffer, desc = "Toggle typehints" })
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = buffer, desc = "Code action" })
    vim.keymap.set("v", "ga", vim.lsp.buf.code_action, { buffer = buffer, desc = "Code action (range)" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buffer, desc = "Go to declaration" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "Go to definition" })
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buffer, desc = "Go to inplementation" })
    vim.keymap.set("n", "gr", vim.lsp.buf.rename, { buffer = buffer, desc = "Rename" })
    vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = buffer, desc = "Type definition" })
    vim.keymap.set("n", "gl", vim.diagnostic.setloclist, { buffer = buffer, desc = "Diagnostics in local list" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "Hover" })
    vim.keymap.set("n", "gR", vim.lsp.buf.references, { buffer = buffer, desc = "References" })
    vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { buffer = buffer, desc = "Signature help" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = buffer, desc = "Next diagnostic" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = buffer, desc = "Prev diagnostic" })
    vim.keymap.set("n", "<leader>ge", vim.diagnostic.open_float, { buffer = buffer, desc = "Open float diagnostics" })
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
        vim.lsp.buf.format {
            timeout_ms = 5000,
            filter = function(c)
                return c.name == "null-ls"
            end,
        }
    end, { buffer = 0, desc = "Format buffer" })

    if mappings[client_name] then
        mappings[client_name]()
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local buffer = args.buf
        local client_name = vim.lsp.get_client_by_id(args.data.client_id)["name"]
        mappings.setup(client_name, buffer)
    end,
})