local keymap = vim.keymap
local lsp = vim.lsp
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
    keymap.set("n", "<leader>lb", "<cmd>TexlabBuild<CR>", { buffer = 0, desc = "Build document" })
    keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", { buffer = 0, desc = "Forward view" })
end

mappings.clangd = function()
    keymap.set("n", "<leader><Tab>", "<cmd>ClangdSwitchSourceHeader<CR>", { buffer = 0, desc = "Build document" })
end

function mappings.setup(client_name, buffer)
    -- keymap.set("n", "gh", require("lsp-inlayhints").toggle, { buffer = buffer, desc = "Toggle typehints" })
    keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = buffer, desc = "Code action" })
    keymap.set("v", "ga", vim.lsp.buf.code_action, { buffer = buffer, desc = "Code action (range)" })
    keymap.set("n", "gD", lsp.buf.declaration, { buffer = buffer, desc = "Go to declaration" })
    keymap.set("n", "gd", lsp.buf.definition, { buffer = buffer, desc = "Go to definition" })
    keymap.set("n", "gi", lsp.buf.implementation, { buffer = buffer, desc = "Go to inplementation" })
    keymap.set("n", "gr", lsp.buf.rename, { buffer = buffer, desc = "Rename" })
    keymap.set("n", "gT", lsp.buf.type_definition, { buffer = buffer, desc = "Type definition" })
    keymap.set("n", "gl", vim.diagnostic.setloclist, { buffer = buffer, desc = "Diagnostics in local list" })
    keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "Hover" })
    keymap.set("n", "gR", lsp.buf.references, { buffer = buffer, desc = "References" })
    keymap.set("n", "<leader>gk", lsp.buf.signature_help, { buffer = buffer, desc = "Signature help" })
    keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = buffer, desc = "Next diagnostic" })
    keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = buffer, desc = "Prev diagnostic" })
    keymap.set("n", "<leader>ge", vim.diagnostic.open_float, { buffer = buffer, desc = "Open float diagnostics" })
    keymap.set({ "n", "v" }, "<leader>f", function()
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
