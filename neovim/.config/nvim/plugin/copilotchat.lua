local hooks = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "CopilotChat" and (kind == "install" or kind == "update") then
        vim.system({ "make tiktoken" }, { cwd = ev.data.path })
    end
end
vim.api.nvim_create_autocmd("PackChanged", { callback = hooks })

vim.pack.add {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/CopilotC-Nvim/CopilotChat.nvim",
}
