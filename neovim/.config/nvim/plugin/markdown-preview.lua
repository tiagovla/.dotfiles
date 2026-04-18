vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "markdown-preview.nvim" and (kind == "install" or kind == "update") then
            vim.system({ "yarn", "install" }, { cwd = ev.data.path .. "/app" })
        end
    end,
})

vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" }, { confirm = false })

vim.g.mkdp_filetypes = { "markdown" }
