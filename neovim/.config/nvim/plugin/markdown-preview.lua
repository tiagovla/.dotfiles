vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" }, { confirm = false })

vim.g.mkdp_filetypes = { "markdown" }

local hooks = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "markdown-preview" and (kind == "install" or kind == "update") then
        vim.system({ "cd app && yarn install" }, { cwd = ev.data.path })
    end
end
vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })
